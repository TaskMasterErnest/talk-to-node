#!/bin/bash

# get the NodePort
PORT=$(kubectl -n default get svc ${serviceName} -o json | jq .spec.ports[].nodePort)

# allow permissions for all users
chmod 777 $(pwd)
echo $(id -u):$(id -g)

# run the scan
# docker run -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-weekly:w2023-05-09 zap-api-scan.py -t $applicationURL:$PORT/v3/api-docs -f openapi -r zap-report.html

# new scan with rules to ignore
docker run -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-weekly:w2023-05-09 zap-api-scan.py -t $applicationURL:$PORT/v3/api-docs -f openapi -c zap-rules -r zap-report.html

# get the exit code
exit_code=$?

# generate the HTML report
sudo mkdir -p owasp-zap-report
sudo mv zap-report.html owasp-zap-report

# get the exit code
echo "Exit Code : $exit_code"

# processing the exit code
if [[ ${exit_code} -ne 0 ]]; then
  echo "OWASP ZAP report has either Low/Medium/High. Please check the HTML report"
  exit 1;
else
  echo "OWASP ZAP did not report any Risk"
fi;

