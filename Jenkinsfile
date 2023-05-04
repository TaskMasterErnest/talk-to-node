pipeline {
	agent any

	stages {

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