pipeline {
  agent any

  stages {
		
		stage('Check Versions') {
			steps {
				sh 'sudo docker version'
				sh 'git version'
				sh 'mvn -v'
				withKubeConfig(credentialsId: 'kube-config', restrictKubeConfigAccess: false) {
    			sh 'sudo kubectl get nodes'
				}
			}
		}
	}
}