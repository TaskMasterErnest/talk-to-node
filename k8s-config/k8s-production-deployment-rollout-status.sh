#!/bin/bash

#k8s-deployment-rollout-status.sh

sleep 30s

if [[ $(kubectl -n production rollout status deploy ${prodDeploymentName} --timeout 5s) != *"successfully rolled out"* ]]; 
then     
	echo "Deployment ${prodDeploymentName} Rollout has Failed"
    kubectl -n production rollout undo deploy ${prodDeploymentName}
    exit 1;
else
	echo "Deployment ${prodDeploymentName} Rollout is Success"
fi;