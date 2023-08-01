#!/bin/bash

#using the kubesec v2 API

# scan_result=$(curl -sSX POST --data-binary@"k8s-config/k8s_deployment_service.yaml" https://v2.kubesec.io/scan)
# scan_message=$(curl -sSX POST --data-binary@"k8s-config/k8s_deployment_service.yaml" https://v2.kubesec.io/scan | jq.[0].message -r)
# scan_score=$(curl -sSX POST --data-binary@"k8s-config/k8s_deployment_service.yaml" https://v2.kubesec.io/scan | jq.[0].score)

# using kubesec docker image for scanning
scan_result=$(docker run -i kubesec/kubesec:v2 scan /dev/stdin < k8s-config/k8s_deployment_service.yaml)
scan_message=$(docker run -i kubesec/kubesec:v2 scan /dev/stdin < k8s-config/k8s_deployment_service.yaml | jq .[0].message -r)
scan_score=$(docker run -i kubesec/kubesec:v2 scan /dev/stdin < k8s-config/k8s_deployment_service.yaml | jq .[0].score)


# processing the results
if [[ "${scan_score}" -ge 5 ]]; then
  echo "Score is $scan_score"
  echo "Kubesec scan message: $scan_message"
else
  echo "Score is $scan_score, which is less than or equal to 5"
  echo "Kubernetes resource scan has failed, scan score has to be greater than or equal to 5"
  exit 1;
fi;