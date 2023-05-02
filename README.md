# kubernetes-devops-security

## Fork and Clone this Repo
- To be able to use this repo, you must either fork or clone it. I suggest you clone it, if you want to go through with the challenge alone.

## Clone to Desktop and VM
- This project will be used in a VM, hence it has to be cloned to that VM too.

The images used are gotten from a sample application, designed and published by a third-party toe be used for this specific project.

Docker and Kubernetes are employed in this project.

## NodeJS Microservice - Docker Image -
`docker run -p 8787:5000 siddharth67/node-service:v1`

`curl localhost:8787/plusone/99`
 
## NodeJS Microservice - Kubernetes Deployment -
`kubectl create deploy node-app --image siddharth67/node-service:v1`

`kubectl expose deploy node-app --name node-service --port 5000 --type ClusterIP`

`curl node-service-ip:5000/plusone/99`
