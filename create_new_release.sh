#!/bin/bash
set -euo pipefail
trap 'echo "Error on line $LINENO. Exit code: $?" >&2; exit 1' ERR
trap 'echo "Script interrupted by user" >&2; exit 130' INT

readonly REPO_API="https://api.github.com/repos/henrygd/beszel/tags"
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_BOLD_WHITE='\033[1;37m'
readonly COLOR_RESET='\033[0m'

log_info() {
  echo -e "${COLOR_GREEN}===>${COLOR_RESET} $1"
}

log_debug() {
  #if [[ "${DEBUG:-0}" == "1" ]]; then
    echo -e "${COLOR_BOLD_WHITE}[👉]${COLOR_RESET} $1" >&2
  #fi
}

log_info "Pull origin..."
git pull

log_info "Initial check..."

CURRENT_RELEASE=$(git tag --sort=-version:refname | head -1)
log_debug "Current release: ${CURRENT_RELEASE:-none}"

CURL_OPTS=(-sf)

# if GITHUB_TOKEN present
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  log_debug "Using GitHub token for API authentication"
  CURL_OPTS+=(-H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN")
else
  log_debug "No GitHub token found, using unauthenticated API request"
fi

log_debug "Fetching latest release from: $REPO_API"
RELEASE=$(curl "${CURL_OPTS[@]}" "$REPO_API" | jq -r '.[0].name // empty')

if [[ -z "$RELEASE" ]]; then
  echo "Error: Failed to fetch latest release from $REPO_API" >&2
  exit 1
fi

log_debug "Latest release: $RELEASE"

if [[ "$RELEASE" == "$CURRENT_RELEASE" ]]; then
  log_info "No new Release available - already up to date..."
  exit 0
fi

log_info "New release found: ${CURRENT_RELEASE} -> ${RELEASE}"

if ! git diff-index --quiet HEAD --; then
  echo "Error: Uncommitted changes detected. Please commit or stash them first." >&2
  git status --short >&2
  exit 1
fi

log_debug "Updating Dockerfile..."
sed -i "s#ARG BESZEL_VERSION.*#ARG BESZEL_VERSION=\"${RELEASE}\"#" Dockerfile

BESZEL_BADGE="[![Beszel](https://img.shields.io/badge/Beszel-${RELEASE}-blue.svg)](https://github.com/henrygd/beszel/releases/tag/${RELEASE})"
log_debug "Updating README.md badge..."
sed -i "s#\[\!\[Beszel\].*#${BESZEL_BADGE}#" README.md

log_debug "Committing changes..."
git add Dockerfile README.md
git commit -m "Update to Beszel version ${RELEASE}"

log_debug "Pushing to origin main..."
git push origin main

log_debug "Creating tag: $RELEASE"
git tag "$RELEASE"

log_debug "Pushing tags..."
git push --tags

log_info "Successfully updated to ${RELEASE}"