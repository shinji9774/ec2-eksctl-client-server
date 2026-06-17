#!/bin/bash
set -euo pipefail

MANIFEST_FILE="/tmp/cluster.yaml"

echo "Fetching cluster config from SSM: ${CLUSTER_CONFIG_PARAM}"
aws ssm get-parameter \
  --name "${CLUSTER_CONFIG_PARAM}" \
  --query "Parameter.Value" \
  --output text \
  --region "${AWS_REGION}" | tee "${MANIFEST_FILE}"

CLUSTER_NAME=$(yq -r '.metadata.name' "${MANIFEST_FILE}")
echo "Cluster name: ${CLUSTER_NAME}"

OPERATION="${1:-}"

if aws eks describe-cluster --name "${CLUSTER_NAME}" --region "${AWS_REGION}" > /dev/null 2>&1; then
  CLUSTER_EXISTS='true'
else
  CLUSTER_EXISTS='false'
fi
echo "Cluster exists: ${CLUSTER_EXISTS}"

if [ "${OPERATION}" = "create" ] && [ "${CLUSTER_EXISTS}" = "true" ]; then
  echo "Cluster '${CLUSTER_NAME}' already exists. Skipping create."
  exit 0
fi

if [ "${OPERATION}" = "delete" ] && [ "${CLUSTER_EXISTS}" = "false" ]; then
  echo "Cluster '${CLUSTER_NAME}' does not exist. Skipping delete."
  exit 0
fi

echo "Running: eksctl $* -f ${MANIFEST_FILE}"
exec eksctl "$@" -f "${MANIFEST_FILE}"
