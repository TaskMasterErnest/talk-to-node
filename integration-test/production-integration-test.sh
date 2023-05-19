#!/bin/bash

# Integration test between the microservices

# wait before starting
sleep 5s

# get NodePort value from the running service's yaml file
# this is taken from the Istio Ingress Gateway Port 80 - NodePort
PORT=$(kubectl -n istio-system get svc istio-ingressgateway -o json | jq '.spec.ports[] | select(.port == 80)' | jq .nodePort)

# link the port to the URL and URI
echo $PORT
echo $applicationURL:$PORT$applicationURI

# processing the response
if [[ ! -z "$PORT" ]]; then

  response=$(curl -s $applicationURL:$PORT$applicationURI)
  http_code=$(curl -s -o /dev/null -w "%{http_code}" $applicationURL:$PORT$applicationURI)

  if [[ "$response" == 100 ]]; then
    echo "Increment Test Passed"
  else
    echo "Increment Test Failed"
    exit 1;
  fi;

  if [[ "$http_code" == 200 ]]; then
    echo "HTTP Status Code Test Passed"
  else
    echo "HTTP Status Code is not 200"
    exit 1;
  fi;

else
  echo "The service does not have a NodePort"
  exit 1;
fi;
