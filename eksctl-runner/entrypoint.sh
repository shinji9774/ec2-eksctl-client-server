#!/bin/bash
set -euo pipefail

MANIFEST_FILE="/tmp/cluster.yaml"

echo "Fetching cluster config from SSM: ${CLUSTER_CONFIG_PARAM}"
aws ssm get-parameter \
  --name "${CLUSTER_CONFIG_PARAM}" \
  --query "Parameter.Value" \
  --output text \
  --region "${AWS_REGION}" | tee "${MANIFEST_FILE}"

echo "Running: eksctl $* -f ${MANIFEST_FILE}"
exec eksctl "$@" -f "${MANIFEST_FILE}"
