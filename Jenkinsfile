pipeline {
  agent any

  stages {
		
		stage('Check Versions') {
			steps {
				sh 'sudo docker version'
				sh 'git version'
				sh 'mvn -v'
    		sh 'sudo kubectl get nodes'
			}
		}
	}
}