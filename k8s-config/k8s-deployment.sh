#!/bin/bash

#Kubernetes deployment script

#first get the image to be used for the deployment
sed -i "s#replace#${imageName}#g" k8s-config/k8s_deployment_service.yaml

kubectl -n default get deployment ${deploymentName} > /dev/null
exit_code = "$?"

if [[ "${exit_code}" -ne 0 ]]; then
  echo "deployment ${deploymentName} does NOT exist"
  kubectl -n default apply -f k8s-config/k8s_deployment_service.yaml
else
  #here we confirm if the deployment exists. we just change the image build used for the file
  echo "deployment ${deploymentName} does exist"
  echo "image name = ${imageName}"
  kubectl -n default set image deployment ${deploymentName} ${containerName}=${imageName} --record=true
fi