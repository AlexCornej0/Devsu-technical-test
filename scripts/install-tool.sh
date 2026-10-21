#!/usr/bin/env bash
# Installs a pinned CLI tool from its GitHub release and verifies the SHA-256
set -euo pipefail

tool=${1:?usage: install-tool.sh <hadolint|kubeconform|trivy> [dest_dir]}
dest=${2:-"${RUNNER_TEMP:-/tmp}/bin"}

case "$tool" in
  hadolint)
    version=v2.15.1
    url="https://github.com/hadolint/hadolint/releases/download/${version}/hadolint-linux-x86_64"
    sha256=c7187db94eeeeca956519a6af171adc31453941a1e777961f6e680f697c8c507
    archive=false
    ;;
  kubeconform)
    version=v0.8.0
    url="https://github.com/yannh/kubeconform/releases/download/${version}/kubeconform-linux-amd64.tar.gz"
    sha256=9bc2bffbf71f261128533edaf912153948b7ff238f9a531ae6d34466ec287883
    archive=true
    ;;
  trivy)
    version=0.76.0
    url="https://github.com/aquasecurity/trivy/releases/download/v${version}/trivy_${version}_Linux-64bit.tar.gz"
    sha256=e24b1c51293c1b15e4ba8d45bbc7891ba053f90278ec2698f3562c993e145fe7
    archive=true
    ;;
  *)
    echo "Unknown tool: $tool" >&2
    exit 2
    ;;
esac

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

curl -fsSL --retry 3 -o "$tmp/download" "$url"
echo "${sha256}  $tmp/download" | sha256sum --check --quiet -

mkdir -p "$dest"
if [ "$archive" = true ]; then
  tar -xzf "$tmp/download" -C "$tmp" "$tool"
  install -m 0755 "$tmp/$tool" "$dest/$tool"
else
  install -m 0755 "$tmp/download" "$dest/$tool"
fi

# Make it available to the next steps of the same job
if [ -n "${GITHUB_PATH:-}" ]; then
  echo "$dest" >> "$GITHUB_PATH"
fi
echo "Installed $tool $version in $dest (sha256 verified)"