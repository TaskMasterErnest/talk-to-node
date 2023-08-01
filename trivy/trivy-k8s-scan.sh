#!/bin/bash

# Trivy Scan for Docker image used for Pods

echo $imageName #image name in env-vars of Jenkinsfile

# run scan for vulnerabilities
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.41.0 -q image --exit-code 0 --severity LOW,MEDIUM --light $imageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.41.0 -q image --exit-code 1 --severity HIGH,CRITICAL --light $imageName

exit_code=$?
echo "Exit code: $exit_code"

# processing the results
if [[ "${exit_code}" == 1 ]]; then
  echo "Image scannig failed. Vulnerabilites found"
  exit 1;
else
  echo "Image scanning successful. No vulnerabilities found."
fi;