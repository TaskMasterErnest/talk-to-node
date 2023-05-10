#!/bin/bash

#print out the second variable in the first line of the Dockerfile
dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile)
echo $dockerImageName

#run a docker container of Trivy to check the vulnerabilities in the docker image.
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.41.0 -q image --exit-code 0 --severity HIGH --light $dockerImageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.41.0 -q image --exit-code 1 --severity CRITICAL --light $dockerImageName

#Trivy scan result processing
exit_code=$?
echo "Exit code : $exit_code"

#Check the scan results
if [[ "${exit_code}" == 1 ]]; then
  echo "Image scanning failed. Vulnerability found"
  exit 1;
else
  echo "Image scanning passed. No CRITICAL vulnerabilities found"
fi