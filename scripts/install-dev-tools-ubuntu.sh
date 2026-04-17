#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    exec sudo bash "$0" "$@"
fi

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
    lua5.2 \
    liblua5.2-dev

cat <<'EOF'
Installed:
  - lua5.2
  - luac5.2
  - liblua5.2-dev

Notes:
  - These tools are only useful for basic Lua 5.2 syntax checks and local scripting.
  - They do not validate Factorio-specific globals, APIs, events, storage semantics, or runtime behavior.
  - For this mod, real validation still requires running inside Factorio 2.x.

Example syntax check:
  for f in *.lua; do luac5.2 -p "$f"; done
EOF
