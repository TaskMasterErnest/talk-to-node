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
