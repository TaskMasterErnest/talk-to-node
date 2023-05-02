pipeline {
  agent any

  stages {
		
		stage('Check Versions') {
			steps {
				sh 'sudo docker version'
				sh 'git version'
				sh 'mvn -v'
				withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'kube-config', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
    			sh 'sudo kubectl version && sudo kubelet version --short'
				}
			}
		}
	}
}