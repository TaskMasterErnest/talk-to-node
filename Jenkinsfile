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
			post { //have to move this post stage the bottom eventually
				always {
					junit 'target/surefire-reports/*.xml'
					jacoco execPattern: 'target/jacoco.exec'
				}
			}
		}

	}
}