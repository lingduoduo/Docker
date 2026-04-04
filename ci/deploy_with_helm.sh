#!/usr/bin/env bash
set -euo pipefail

DEPLOY_ENVIRONMENT="${DEPLOY_ENVIRONMENT:-staging}"
DEPLOY_STRATEGY="${DEPLOY_STRATEGY:-standard}"
IMAGE_TAG="${IMAGE_TAG:?IMAGE_TAG must be set}"
IMAGE_REPOSITORY="${IMAGE_REPOSITORY:?IMAGE_REPOSITORY must be set}"
CHART_PATH="${CHART_PATH:-Helm-Chart/mychart}"
RELEASE_NAME="${RELEASE_NAME:-model-release}"
KUBE_NAMESPACE="${KUBE_NAMESPACE:-model-serving}"
IMAGE_PULL_POLICY="${IMAGE_PULL_POLICY:-}"
CONTAINER_PORT="${CONTAINER_PORT:-}"
SERVICE_PORT="${SERVICE_PORT:-}"
LIVENESS_PATH="${LIVENESS_PATH:-}"
READINESS_PATH="${READINESS_PATH:-}"

VALUES_FILE="${CHART_PATH}/values-${DEPLOY_ENVIRONMENT}.yaml"

if [ ! -f "${VALUES_FILE}" ]; then
  echo "Values file ${VALUES_FILE} does not exist"
  exit 1
fi

HELM_ARGS=(
  upgrade
  --install
  "${RELEASE_NAME}"
  "${CHART_PATH}"
  --namespace
  "${KUBE_NAMESPACE}"
  --create-namespace
  -f
  "${VALUES_FILE}"
  --set
  "image.repository=${IMAGE_REPOSITORY}"
  --set
  "image.tag=${IMAGE_TAG}"
)

if [ -n "${IMAGE_PULL_POLICY}" ]; then
  HELM_ARGS+=(--set "image.pullPolicy=${IMAGE_PULL_POLICY}")
fi

if [ -n "${CONTAINER_PORT}" ]; then
  HELM_ARGS+=(--set "container.port=${CONTAINER_PORT}")
fi

if [ -n "${SERVICE_PORT}" ]; then
  HELM_ARGS+=(--set "service.port=${SERVICE_PORT}")
fi

if [ -n "${LIVENESS_PATH}" ]; then
  HELM_ARGS+=(--set "livenessProbe.httpGet.path=${LIVENESS_PATH}")
fi

if [ -n "${READINESS_PATH}" ]; then
  HELM_ARGS+=(--set "readinessProbe.httpGet.path=${READINESS_PATH}")
fi

helm "${HELM_ARGS[@]}"

if [ "${DEPLOY_ENVIRONMENT}" = "production" ] && [ "${DEPLOY_STRATEGY}" = "canary" ]; then
  CANARY_VALUES_FILE="${CHART_PATH}/values-production-canary.yaml"

  if [ ! -f "${CANARY_VALUES_FILE}" ]; then
    echo "Canary values file ${CANARY_VALUES_FILE} does not exist"
    exit 1
  fi

  CANARY_HELM_ARGS=(
    upgrade
    --install
    "${RELEASE_NAME}-canary"
    "${CHART_PATH}"
    --namespace
    "${KUBE_NAMESPACE}"
    --create-namespace
    -f
    "${CANARY_VALUES_FILE}"
    --set
    "image.repository=${IMAGE_REPOSITORY}"
    --set
    "image.tag=${IMAGE_TAG}"
  )

  if [ -n "${IMAGE_PULL_POLICY}" ]; then
    CANARY_HELM_ARGS+=(--set "image.pullPolicy=${IMAGE_PULL_POLICY}")
  fi

  if [ -n "${CONTAINER_PORT}" ]; then
    CANARY_HELM_ARGS+=(--set "container.port=${CONTAINER_PORT}")
  fi

  if [ -n "${SERVICE_PORT}" ]; then
    CANARY_HELM_ARGS+=(--set "service.port=${SERVICE_PORT}")
  fi

  if [ -n "${LIVENESS_PATH}" ]; then
    CANARY_HELM_ARGS+=(--set "livenessProbe.httpGet.path=${LIVENESS_PATH}")
  fi

  if [ -n "${READINESS_PATH}" ]; then
    CANARY_HELM_ARGS+=(--set "readinessProbe.httpGet.path=${READINESS_PATH}")
  fi

  helm "${CANARY_HELM_ARGS[@]}"
fi
