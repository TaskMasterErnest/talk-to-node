#!/bin/bash

# script to use kube-bench to assess some security compliances in Kubernetes

total_fail=$(sudo kube-bench --check 1.2.7,1.2.8,1.2.9,1.2.20,1.2.21,1.2.22,1.2.23,1.2.24,1.2.25,1.3.2,1.4.1 --json | jq -r '.Totals.total_fail')

if [[ "$total_fail" -ne 0 ]]; then
  echo "CIS Benchmark for 1.2.7, 1.2.8, 1.2.9, 1.2.20, 1.2.21, 1.2.22, 1.2.23, 1.2.24, 1.2.25, 1.3.2, 1.4.1 FAILED"
  exit 1;
else
  echo "CIS Benchmarking PASSED"
fi;