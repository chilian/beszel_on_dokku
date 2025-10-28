#!/bin/bash
set -euo pipefail
trap 'exit 130' INT

readonly REPO_API="https://api.github.com/repos/henrygd/beszel/tags"
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_RESET='\033[0m'

log_info() {
  echo -e "${COLOR_GREEN}===>${COLOR_RESET} $1"
}

log_info "Pull origin..."
git pull

log_info "Initial check..."

CURRENT_RELEASE=$(git tag --sort=-version:refname | head -1)

RELEASE=$(curl -sf "$REPO_API" | jq -r '.[0].name // empty')

if [[ -z "$RELEASE" ]]; then
  echo "Error: Failed to fetch latest release" >&2
  exit 1
fi

if [[ "$RELEASE" == "$CURRENT_RELEASE" ]]; then
  log_info "No new Release available - already up to date..."
  exit 0
fi

if ! git diff-index --quiet HEAD --; then
  echo "Error: Uncommitted changes detected. Please commit or stash them first." >&2
  exit 1
fi

sed -i "s#ARG BESZEL_VERSION.*#ARG BESZEL_VERSION=\"${RELEASE}\"#" Dockerfile

BESZEL_BADGE="[![Beszel](https://img.shields.io/badge/Beszel-${RELEASE}-blue.svg)](https://github.com/henrygd/beszel/releases/tag/${RELEASE})"
sed -i "s#\[\!\[Beszel\].*#${BESZEL_BADGE}#" README.md

git add Dockerfile README.md
git commit -m "Update to Beszel version ${RELEASE}"
git push origin main

git tag "$RELEASE"
git push --tags

log_info "Successfully updated to ${RELEASE}"