pipeline {
	agent any

	stages {
		stage('Build Artifacts - Maven') {
			steps {
				sh "mvn clean package -DskipTests=true"
				archiveArtifacts artifacts: 'target/*jar', followSymlinks: false //persisting the jar file for later downloads
			}
		}

		stage('Test - JaCoCo and JUnit') {
			steps {
				sh 'mvn test'
			}
		}

		stage('Test - PIT Mutation') {
			steps {
				sh 'mvn org.pitest:pitest-maven:mutationCoverage'
			}
		}

		stage('SAST - SonarQube') {
			steps {
				sh 'mvn clean verify sonar:sonar \
  					-Dsonar.projectKey=devsecops-node \
  					-Dsonar.host.url=http://35.198.170.179:9000 \
  					-Dsonar.login=sqp_0b7e2f969b9e77b3a34e2289fe94d4f55b225824'
			}
		}

		stage('Build & Push - Docker') {
			steps {
				withDockerRegistry(credentialsId: 'docker-creds') {
					sh 'sudo docker build -t ernestklu/numeric-application:""$GIT_COMMIT"" .'
					sh 'sudo docker push ernestklu/numeric-application:""$GIT_COMMIT""'
				}
			}
		}

	}

	post {
		always {
			junit 'target/surefire-reports/*.xml'
			jacoco (
				execPattern: 'target/jacoco.exec'
			)
			pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
		}
	}

}
