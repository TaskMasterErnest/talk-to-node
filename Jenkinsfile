pipeline {
	agent any
	tools {
		maven "Maven"
	}

	environment {
		deploymentName = "devsecops"
		containerName = "devsecops-container"
		serviceName = "devsecops-svc"
		imageName = "ernestklu/numeric-application:${GIT_COMMIT}"
		applicationURL = "http://10.96.147.112"
		applicationURI = "/increment/99"
	}

	stages {

		// stage('test') {
		// 	steps {
		// 		sh "java -version"
		// 		sh "mvn -v"
    //     sh "mvn test"
    //   }
		// }

		stage('Build Artifacts - Maven') {
			steps {
				echo "Packaging java artifact"
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

		stage('SAST - SonarQube') {
			steps {
				withSonarQubeEnv(credentialsId: 'SonarQube', installationName: 'SonarQube') {
					sh 'mvn sonar:sonar \
							-Dsonar.projectKey=devsecops-node \
							-Dsonar.host.url=http://35.198.170.179:9000'
				}
				timeout(time: 10, unit: 'SECONDS') {
					script {
          waitForQualityGate abortPipeline: true
					}
        }
			}
		}

		stage('Dependency & Vulnerability Checks') {
			steps {
				parallel (
					"Maven Dependency Check": {
						sh 'mvn dependency-check:check'
					},
					"Trivy Docker Image Scan": {
						sh "sudo bash trivy/trivy-docker-scan.sh"
					},
					"OPA Conftest - Dockerfile": {
						sh 'sudo docker run --rm -v $(pwd):/project openpolicyagent/conftest:v0.42.1 test --policy conftest/opa-dockerfile-security.rego Dockerfile'
					}
				)
			}
		}

		// stage('OPA Conftest - Dockerfile') {
		// 	steps {
		// 		sh 'sudo docker run --rm -v $(pwd):/project openpolicyagent/conftest:v0.42.1 test --policy conftest/opa-dockerfile-security.rego Dockerfile'
		// 	}
		// }

		// stage('Vulnerability Check - Trivy') {
		// 	steps {
		// 		sh "sudo bash trivy-docker-scan.sh"
		// 	}
		// }

		stage('Build & Push - Docker') {
			steps {
				withDockerRegistry(credentialsId: 'docker-creds', url: "") {
					sh 'sudo docker build -t ernestklu/numeric-application:""$GIT_COMMIT"" .'
					sh 'sudo docker push ernestklu/numeric-application:""$GIT_COMMIT""'
				}
			}
		}

		stage('OPA Conftest - Kubernetes') {
			steps {
				sh 'sudo docker run --rm -v $(pwd):/project openpolicyagent/conftest:v0.42.1 test --policy conftest/opa-k8s-security.rego k8s-config/k8s_deployment_service.yaml'
			}
		}

		stage('Kubesec Scan - Kubernetes') {
			steps {
				sh "bash k8s-config/kubesec-scan.sh"
			}
		}

		stage('Trivy Scan - Kubernetes') {
			steps {
				sh "bash trivy/trivy-k8s-scan.sh"
			}
		}

		stage('Deploy to Kubernetes - DEV') {
			steps {
				withKubeConfig(credentialsId: 'kube-config', restrictKubeConfigAccess: false, serverUrl: '') {
					sh "bash k8s-config/k8s-deployment.sh"
				}
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
			dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
		}
 	}

}
