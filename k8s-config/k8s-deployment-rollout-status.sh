#!/bin/bash

# Script to check the rollout status of the Kubernetes deployment

# wait for 1 min
sleep 60s

# check the rollout status and perform an action if neccessary
if [[ $(kubectl -n default rollout status deploy ${deploymentName} --timeout 5s) != *"successfully rolled out"* ]]; then
  echo "Deployment ${deploymentName}, rollout has FAILED!!"
  kubectl -n default rollout undo deploy ${deploymentName}
  exit 1;
else
  echo "Deployment ${deploymentName}, rollout was SUCCESSFUL!!"
fi;