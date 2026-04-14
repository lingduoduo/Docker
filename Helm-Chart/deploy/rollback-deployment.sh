#!/usr/bin/env bash
set -euo pipefail

# Helm Rollback Helper Script
# Safely rollback Helm deployments with verification

RELEASE_NAME="${RELEASE_NAME:-model-release}"
KUBE_NAMESPACE="${KUBE_NAMESPACE:-model-serving}"
REVISION="${1:-}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Helm Rollback Helper ===${NC}\n"

# Check if release exists
if ! helm list -n "${KUBE_NAMESPACE}" | grep -q "${RELEASE_NAME}"; then
  echo -e "${RED}✗ Release '${RELEASE_NAME}' not found in namespace '${KUBE_NAMESPACE}'${NC}"
  exit 1
fi

# Show release history
echo -e "${BLUE}Release History for ${RELEASE_NAME}:${NC}"
helm history "${RELEASE_NAME}" -n "${KUBE_NAMESPACE}" -o table

echo ""

if [ -z "${REVISION}" ]; then
  # Interactive mode
  echo -e "${YELLOW}Enter revision number to rollback to (from list above):${NC}"
  read -r REVISION
  
  if [ -z "${REVISION}" ]; then
    echo -e "${RED}✗ No revision specified${NC}"
    exit 1
  fi
fi

# Validate revision is a number
if ! [[ "${REVISION}" =~ ^[0-9]+$ ]]; then
  echo -e "${RED}✗ Invalid revision: must be a number${NC}"
  exit 1
fi

# Get current revision
CURRENT_REVISION=$(helm list -n "${KUBE_NAMESPACE}" -o json | jq -r ".[] | select(.name==\"${RELEASE_NAME}\") | .revision")

if [ "${REVISION}" = "${CURRENT_REVISION}" ]; then
  echo -e "${YELLOW}⚠ Revision ${REVISION} is already active${NC}"
  exit 0
fi

# Get details about target revision
TARGET_INFO=$(helm history "${RELEASE_NAME}" -n "${KUBE_NAMESPACE}" -o json | jq ".[] | select(.revision==${REVISION})")

if [ -z "${TARGET_INFO}" ]; then
  echo -e "${RED}✗ Revision ${REVISION} not found in history${NC}"
  exit 1
fi

TARGET_VERSION=$(echo "${TARGET_INFO}" | jq -r '.chart')
TARGET_DATE=$(echo "${TARGET_INFO}" | jq -r '.released')
TARGET_STATUS=$(echo "${TARGET_INFO}" | jq -r '.status')

echo -e "${YELLOW}Rolling back to revision ${REVISION}:${NC}"
echo "  Chart: ${TARGET_VERSION}"
echo "  Released: ${TARGET_DATE}"
echo "  Status: ${TARGET_STATUS}"
echo ""
echo -e "${YELLOW}Confirm rollback? (yes/no)${NC}"
read -r CONFIRM

if [ "${CONFIRM}" != "yes" ]; then
  echo -e "${RED}✗ Rollback cancelled${NC}"
  exit 0
fi

# Perform rollback
echo -e "\n${BLUE}Performing rollback...${NC}"
helm rollback "${RELEASE_NAME}" "${REVISION}" -n "${KUBE_NAMESPACE}" --wait --wait-for-jobs

echo ""

# Verify rollback
echo -e "${BLUE}Verifying rollback...${NC}"
NEW_REVISION=$(helm list -n "${KUBE_NAMESPACE}" -o json | jq -r ".[] | select(.name==\"${RELEASE_NAME}\") | .revision")

if [ "${NEW_REVISION}" -gt "${CURRENT_REVISION}" ]; then
  echo -e "${GREEN}✓ Rollback successful (revision ${NEW_REVISION})${NC}"
  
  # Monitor pods
  echo ""
  echo -e "${BLUE}Monitoring rolled-back pods...${NC}"
  echo "Press Ctrl+C to stop monitoring"
  kubectl get pods -n "${KUBE_NAMESPACE}" -l "app.kubernetes.io/instance=${RELEASE_NAME}" -w
else
  echo -e "${RED}✗ Rollback verification failed${NC}"
  exit 1
fi
