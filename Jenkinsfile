pipeline {
	agent any

	stages {
		stage('Build Artifacts - Maven') {
			steps {
				sh "mvn clean package -DskipTests=true"
				archive 'target/*.jar' //persisting the jar file for later downloads
			}
		}

		stage('Version Check') {
			steps {
				sh 'sudo docker version'
				sh 'git version'
				sh 'mvn -v'
				withKubeConfig(credentialsId: 'kube-config', restrictKubeConfigAccess: false, serverUrl: '') {
					sh 'kubectl version --short'
				}
			}
		}

	}
}