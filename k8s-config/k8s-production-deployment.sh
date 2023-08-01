#!/bin/bash

#Kubernetes deployment script

#first get the image to be used for the deployment
sed -i "s#replace#${imageName}#g" k8s-config/k8s_production_deployment_service.yaml

# kubectl -n production get deploy ${deploymentName} > /dev/null
# exit_code=$?

# if [[ "$exit_code" -ne 0 ]]; then
#   echo "deployment ${deploymentName} does NOT exist"
#   kubectl -n production apply -f k8s-config/k8s_production_deployment_service.yaml
# else
#   #here we confirm if the deployment exists. we just change the image build used for the file
#   echo "deployment ${deploymentName} does exist"
#   echo "image name = ${imageName}"
#   kubectl -n production set image deploy ${deploymentName} ${containerName}=${imageName} --record=true
# fi

kubectl apply -f k8s-config/k8s_production_deployment_service.yaml -n production