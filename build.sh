#!/usr/bin/env bash
# Offline fallback rebuild for this base image. Normal path is GitHub Actions
# -> GHCR (see README.md); use this only when GHCR is unreachable or you need
# a rebuild without waiting on CI. Tags to the same name GHCR publishes so it
# satisfies a consuming app's `FROM ghcr.io/.../fastapi-base:latest` with no
# Dockerfile edit.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

docker build --network=host -t ghcr.io/paolonarvaez/fastapi-base:latest .
