#!/bin/bash
set -euo pipefail

echo "Fetching cluster config from SSM: ${CLUSTER_CONFIG_PARAM}"
aws ssm get-parameter \
  --name "${CLUSTER_CONFIG_PARAM}" \
  --query "Parameter.Value" \
  --output text \
  --region "${AWS_REGION}" | tee /tmp/cluster.yaml

echo "Running: eksctl $*"
exec eksctl "$@"
