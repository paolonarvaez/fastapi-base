# fastapi-base

A general-purpose base image for FastAPI apps (`ghcr.io/paolonarvaez/fastapi-base`).
Bundles a common set of pinned dependencies (see `requirements.txt`) plus a
`curl` step for apps that vendor frontend assets at build time, so those
pip-install and apt-get layers are shared on disk instead of duplicated per app.

Public repo: consuming apps can pin this image by digest with no
`registries:` credentials needed for Dependabot to read it, and stay
buildable by anyone even if they're public themselves.

## Built by GitHub Actions, not on any host

This is source for a CI-built image, not a runtime stack.
`.github/workflows/build-fastapi-base.yml` builds and pushes it to GHCR:

- on push to `master`
- weekly (Monday 03:00 UTC) with `pull: true`, to pick up upstream
  Debian/Python security patches for whatever `python:*-slim` tag the
  Dockerfile currently pins
- on Dependabot PRs bumping `requirements.txt` or the base image, so the
  build's checked before merge
- on `workflow_dispatch`

Each build publishes `latest`, an immutable `sha-<short>`, and a datestamped
tag. Consuming apps pin `FROM` to this image by digest and let Dependabot
bump the digest.

## Dependabot auto-merge

This repo is public, so GitHub's auto-merge is available and enabled for
Dependabot PRs against `requirements.txt`/the Dockerfile: once
`build-fastapi-base` passes, the PR merges unattended.

## Rolling back a bad rebuild

Find the last good `sha-` or datestamped tag on the GHCR package page, point
the affected app's `FROM` line at it, then rebuild that app.

## Offline fallback: `build.sh`

If GHCR is unreachable, `build.sh` builds the same image locally under the
`:latest` tag, satisfying an app's `FROM` line without editing it.

### Why `--network=host` for the local build

Some Docker daemon configs (e.g. `"bridge": "none"`) leave BuildKit's own
default bridge network unavailable, breaking plain `docker build` for any
`RUN` step that needs the network (`apt-get`, `pip install`) with `network
bridge not found`. `build.sh` passes `--network=host` explicitly to work
around this.
