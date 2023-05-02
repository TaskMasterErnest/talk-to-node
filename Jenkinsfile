pipeline {
  agent any

  stages {
		
		stage('Check Versions') {
			steps {
				sh 'sudo docker version'
				sh 'git version'
				sh 'mvn version'
				sh 'kubectl version && kubelet version'
			}
		}
	}
}