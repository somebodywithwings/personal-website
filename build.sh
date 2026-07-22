#!/usr/bin/env bash
set -euo pipefail

HUGO_VERSION="0.139.4"

curl -sL "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-amd64.tar.gz" -o /tmp/hugo.tar.gz
mkdir -p /tmp/hugo-bin
tar -xzf /tmp/hugo.tar.gz -C /tmp/hugo-bin hugo
export PATH="/tmp/hugo-bin:$PATH"

hugo --minify
