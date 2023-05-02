pipeline {
  agent any

  stages {
		
		stage('Check Versions') {
			steps {
				sh 'sudo docker version'
				sh 'git version'
				sh 'mvn -v'
				withKubeConfig(credentialsId: 'kube-config', restrictKubeConfigAccess: false, serverUrl: 'https://10.128.0.9:6443') {
    			sh 'sudo kubectl get nodes'
				}
			}
		}
	}
}