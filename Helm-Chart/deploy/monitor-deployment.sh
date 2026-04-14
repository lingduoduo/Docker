#!/usr/bin/env bash
set -euo pipefail

# Deployment Status Monitor
# Provides real-time visibility into deployment health

KUBE_NAMESPACE="${KUBE_NAMESPACE:-model-serving}"
RELEASE_NAME="${RELEASE_NAME:-model-release}"
REFRESH_INTERVAL="${REFRESH_INTERVAL:-2}"

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear_screen() {
  clear
}

print_header() {
  echo -e "${BLUE}╔════════════════════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║${NC}                     ${BLUE}Helm Deployment Status Monitor${NC}                               ${BLUE}║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════════════════════════════════╝${NC}"
}

print_release_info() {
  echo ""
  echo -e "${BLUE}Release Information:${NC}"
  
  local release_info=$(helm list -n "${KUBE_NAMESPACE}" -o json 2>/dev/null | \
    jq -r ".[] | select(.name==\"${RELEASE_NAME}\") | \"\(.name)|\(.namespace)|\(.status)|\(.app_version)|\(.chart)|\(.revision)\"" 2>/dev/null || true)
  
  if [ -z "${release_info}" ]; then
    echo -e "${RED}✗ Release '${RELEASE_NAME}' not found${NC}"
    return 1
  fi
  
  IFS='|' read -r name namespace status app_version chart revision <<< "${release_info}"
  
  local status_color="${GREEN}"
  [ "${status}" != "deployed" ] && status_color="${RED}"
  
  printf "  %-20s %s\n" "Release:" "${name}"
  printf "  %-20s %s\n" "Namespace:" "${namespace}"
  printf "  %-20s ${status_color}%s${NC}\n" "Status:" "${status}"
  printf "  %-20s %s\n" "Chart:" "${chart}"
  printf "  %-20s %s\n" "App Version:" "${app_version}"
  printf "  %-20s %s\n" "Revision:" "${revision}"
  
  return 0
}

print_deployment_info() {
  echo ""
  echo -e "${BLUE}Deployment Status:${NC}"
  
  local deployment_info=$(kubectl get deployment \
    -n "${KUBE_NAMESPACE}" \
    -l "app.kubernetes.io/instance=${RELEASE_NAME}" \
    -o jsonpath='{range .items[*]}{.metadata.name}{"|"}{.spec.replicas}{"|"}{.status.readyReplicas}{"|"}{.status.updatedReplicas}{"|"}{.status.availableReplicas}{"\n"}{end}' 2>/dev/null || true)
  
  if [ -z "${deployment_info}" ]; then
    echo -e "${RED}✗ No deployments found${NC}"
    return
  fi
  
  while IFS='|' read -r name desired ready updated available; do
    local deploy_status="${GREEN}✓"
    [ "${ready}" != "${desired}" ] && deploy_status="${YELLOW}⚠"
    [ -z "${ready}" ] && deploy_status="${RED}✗"
    
    printf "  %s%-30s Desired: %d | Ready: %s%s${NC} | Updated: %d | Available: %d\n" \
      "${deploy_status}" "${name}" "${desired}" \
      "$([ "${ready}" = "${desired}" ] && echo -e "${GREEN}" || echo -e "${YELLOW}")${ready:-0}" \
      "${NC}" "${updated:-0}" "${available:-0}"
  done <<< "${deployment_info}"
}

print_pod_status() {
  echo ""
  echo -e "${BLUE}Pod Status:${NC}"
  
  local pods=$(kubectl get pods \
    -n "${KUBE_NAMESPACE}" \
    -l "app.kubernetes.io/instance=${RELEASE_NAME}" \
    -o jsonpath='{range .items[*]}{.metadata.name}{"|"}{.status.phase}{"|"}{.status.conditions[?(@.type=="Ready")].status}{"|"}{.status.containerStatuses[0].ready}{"\n"}{end}' 2>/dev/null || true)
  
  if [ -z "${pods}" ]; then
    echo -e "${RED}✗ No pods found${NC}"
    return
  fi
  
  while IFS='|' read -r pod_name phase ready container_ready; do
    local pod_status="${GREEN}✓"
    case "${phase}" in
      "Running") [ "${ready}" != "True" ] && pod_status="${YELLOW}⚠" ;;
      "Pending") pod_status="${YELLOW}⏳" ;;
      "Failed"|"Unknown") pod_status="${RED}✗" ;;
      *) pod_status="${YELLOW}⚠" ;;
    esac
    
    printf "  %s %-40s Phase: %-10s Ready: %s\n" \
      "${pod_status}" "${pod_name}" "${phase}" "${ready:-False}"
  done <<< "${pods}"
}

print_resource_usage() {
  echo ""
  echo -e "${BLUE}Resource Usage:${NC}"
  
  local usage=$(kubectl top pods \
    -n "${KUBE_NAMESPACE}" \
    -l "app.kubernetes.io/instance=${RELEASE_NAME}" \
    --no-headers 2>/dev/null || true)
  
  if [ -z "${usage}" ]; then
    echo -e "${YELLOW}⚠ Metrics not available (ensure metrics-server is installed)${NC}"
    return
  fi
  
  echo "  Pod Name                              CPU        Memory"
  echo "  ────────────────────────────────────  ─────────  ──────────"
  
  while read -r pod_name cpu memory; do
    printf "  %-37s  %-9s  %s\n" "${pod_name}" "${cpu}" "${memory}"
  done <<< "${usage}"
}

print_events() {
  echo ""
  echo -e "${BLUE}Recent Events (last 5 minutes):${NC}"
  
  local since="5m"
  local events=$(kubectl get events \
    -n "${KUBE_NAMESPACE}" \
    --field-selector involvedObject.kind=Pod \
    --sort-by='.lastTimestamp' \
    --no-headers 2>/dev/null | tail -10)
  
  if [ -z "${events}" ]; then
    echo -e "${GREEN}✓ No events${NC}"
    return
  fi
  
  echo "${events}" | while read -r line; do
    printf "  %s\n" "${line}"
  done
}

print_footer() {
  echo ""
  echo -e "${BLUE}────────────────────────────────────────────────────────────────────────────────────${NC}"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  printf "  Last updated: %s | Press Ctrl+C to exit | Refresh interval: %ds\n" "${timestamp}" "${REFRESH_INTERVAL}"
}

main() {
  while true; do
    clear_screen
    print_header
    
    if ! print_release_info; then
      print_footer
      sleep "${REFRESH_INTERVAL}"
      continue
    fi
    
    print_deployment_info
    print_pod_status
    print_resource_usage
    print_events
    print_footer
    
    sleep "${REFRESH_INTERVAL}"
  done
}

# Handle Ctrl+C gracefully
trap 'echo "" && echo -e "${GREEN}✓ Monitor stopped${NC}" && exit 0' SIGINT SIGTERM

main
