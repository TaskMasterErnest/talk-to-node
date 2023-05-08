pipeline {
	agent any
	tools { 
      maven 'MAVEN_HOME' 
      jdk 'JAVA_HOME' 
    }

	stages {

		stage('test') {
			steps {
          sh 'mvn -B -ntp -Dmaven.test.failure.ignore verify'
      }
		}

// 		stage('Build Artifacts - Maven') {
// 			steps {
// 				sh "mvn clean package -DskipTests=true"
// 				archiveArtifacts artifacts: 'target/*jar', followSymlinks: false //persisting the jar file for later downloads
// 			}
// 		}

// 		stage('Test - JaCoCo and JUnit') {
// 			steps {
// 				sh 'mvn test'
// 			}
// 		}

// 		stage('Test - PIT Mutation') {
// 			steps {
// 				sh 'mvn org.pitest:pitest-maven:mutationCoverage'
// 			}
// 		}

// 		stage('SAST - SonarQube') {
// 			steps {
// 				withSonarQubeEnv(credentialsId: 'SonarQube', installationName: 'SonarQube') {
// 					sh 'mvn sonar:sonar \
// 							-Dsonar.projectKey=devsecops-node \
// 							-Dsonar.host.url=http://35.198.170.179:9000'
// 				}
// 				timeout(time: 10, unit: 'SECONDS') {
// 					script {
//           waitForQualityGate abortPipeline: true
// 					}
//         }
// 			}
// 		}

// 		stage('Dependency & Vulnerability Checks') {
// 			steps {
// 				parallel (
// 					"Maven Dependency Check": {
// 						sh 'mvn dependency-check:check'
// 					},
// 					"Trivy Docker Image Scan": {
// 						sh "sudo bash trivy-docker-scan.sh"
// 					}
// 				)
// 			}
// 		}

// 		// stage('Vulnerability Check - Trivy') {
// 		// 	steps {
// 		// 		sh "sudo bash trivy-docker-scan.sh"
// 		// 	}
// 		// }

// 		stage('Build & Push - Docker') {
// 			steps {
// 				withDockerRegistry(credentialsId: 'docker-creds', url: "") {
// 					sh 'sudo docker build -t ernestklu/numeric-application:""$GIT_COMMIT"" .'
// 					sh 'sudo docker push ernestklu/numeric-application:""$GIT_COMMIT""'
// 				}
// 			}
// 		}

// 	}

// 	post {
// 		always {
// 			junit 'target/surefire-reports/*.xml'
// 			jacoco (
// 				execPattern: 'target/jacoco.exec'
// 			)
// 			pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
// 			dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
// 		}
// 	}

}
