pipeline {
  agent any

  stages {
#      stage('Build Artifact') {
#            steps {
#              sh "mvn clean package -DskipTests=true"
#              archive 'target/*.jar' //so that they can be downloaded later
#            }
#        }   
    stage('Check versions') {
    	steps {
		sh 'sudo docker version'
		sh 'mvn version'
		sh 'git version'
		sh 'kubectl version && kubelete version'
	}
    }
}
}
