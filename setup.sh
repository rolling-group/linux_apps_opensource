#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./setup.sh <deb|rpm> <rw101> <lenovo> [--no-install]

What it does:
  - Prepares the build environment based on README.md (by default it tries to install deps via apt)
  - Builds a DEB/RPM by calling script/make_deb.sh
  - Outputs artifacts under binary_deb/

Arguments:
  1) deb|rpm    package type
  2) rw101      project (currently only rw101 is supported)
  3) lenovo     OEM (currently only lenovo is supported)

Optional:
  --no-install  do not install deps automatically; only check and build

Examples:
  ./setup.sh deb rw101 lenovo
  ./setup.sh rpm rw101 lenovo --no-install
EOF
}

die() { echo "ERROR: $*" >&2; exit 1; }
log() { echo "[setup] $*"; }

PKG_TYPE="${1:-}"
PROJECT_BUILD="${2:-}"
OEM_BUILD="${3:-}"
NO_INSTALL="no"
if [[ "${4:-}" == "--no-install" ]]; then
  NO_INSTALL="yes"
elif [[ -n "${4:-}" ]]; then
  usage
  die "Unknown option: ${4}"
fi

[[ -n "${PKG_TYPE}" && -n "${PROJECT_BUILD}" && -n "${OEM_BUILD}" ]] || { usage; exit 1; }
[[ "${PKG_TYPE}" == "deb" || "${PKG_TYPE}" == "rpm" ]] || die "Argument 1 must be 'deb' or 'rpm'"
[[ "${PROJECT_BUILD}" == "rw101" ]] || die "Argument 2 currently only supports 'rw101'"
[[ "${OEM_BUILD}" == "lenovo" ]] || die "Argument 3 currently only supports 'lenovo'"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAKE_SCRIPT="${SCRIPT_DIR}/script/make_deb.sh"

[[ -f "${MAKE_SCRIPT}" ]] || die "Script not found: ${MAKE_SCRIPT}"

need_cmds=(cmake make gcc pkg-config)
missing_cmds=()
for c in "${need_cmds[@]}"; do
  command -v "${c}" >/dev/null 2>&1 || missing_cmds+=("${c}")
done

if [[ "${NO_INSTALL}" == "no" ]]; then
  if [[ "${#missing_cmds[@]}" -gt 0 ]]; then
    log "Missing commands detected: ${missing_cmds[*]}"
  fi

  if command -v apt-get >/dev/null 2>&1; then
    if [[ "${EUID}" -ne 0 ]]; then
      die "Root is required to install dependencies automatically. Please run with sudo, or use --no-install."
    fi

    log "Installing dependencies (from README.md)..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y \
      cmake \
      build-essential \
      pkg-config \
      libglib2.0-dev \
      libxml2-dev \
      libudev-dev \
      libmbim-glib-dev \
      libdbus-1-dev \
      libmm-glib-dev \
      libfwupd-dev \
      fastboot
    log "Dependencies installed."
  else
    log "apt-get not found; skipping automatic dependency installation (use --no-install)."
  fi
else
  log "--no-install: skipping dependency installation; build only."
fi

log "Building package: ${PKG_TYPE} ${PROJECT_BUILD} ${OEM_BUILD}"
cd "${SCRIPT_DIR}"
bash "${MAKE_SCRIPT}" "${PKG_TYPE}" "${PROJECT_BUILD}" "${OEM_BUILD}"

log "Done. Artifacts directory: ${SCRIPT_DIR}/binary_deb/"

#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./setup.sh <deb|rpm> <rw101> <lenovo> [--no-install]

What it does:
  - Prepares the build environment based on linux-apps/README.md (by default it tries to install deps via apt)
  - Builds a DEB/RPM by calling linux-apps/script/make_deb.sh
  - Outputs artifacts under linux-apps/binary_deb/

Arguments:
  1) deb|rpm    package type
  2) rw101      project (currently only rw101 is supported)
  3) lenovo     OEM (currently only lenovo is supported)

Optional:
  --no-install  do not install deps automatically; only check and build

Examples:
  ./setup.sh deb rw101 lenovo
  ./setup.sh rpm rw101 lenovo --no-install
EOF
}

die() { echo "ERROR: $*" >&2; exit 1; }
log() { echo "[setup] $*"; }

PKG_TYPE="${1:-}"
PROJECT_BUILD="${2:-}"
OEM_BUILD="${3:-}"
NO_INSTALL="no"
if [[ "${4:-}" == "--no-install" ]]; then
  NO_INSTALL="yes"
elif [[ -n "${4:-}" ]]; then
  usage
  die "Unknown option: ${4}"
fi

[[ -n "${PKG_TYPE}" && -n "${PROJECT_BUILD}" && -n "${OEM_BUILD}" ]] || { usage; exit 1; }
[[ "${PKG_TYPE}" == "deb" || "${PKG_TYPE}" == "rpm" ]] || die "Argument 1 must be 'deb' or 'rpm'"
[[ "${PROJECT_BUILD}" == "rw101" ]] || die "Argument 2 currently only supports 'rw101'"
[[ "${OEM_BUILD}" == "lenovo" ]] || die "Argument 3 currently only supports 'lenovo'"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINUX_APPS_DIR="${SCRIPT_DIR}/linux-apps"
MAKE_SCRIPT="${LINUX_APPS_DIR}/script/make_deb.sh"

[[ -d "${LINUX_APPS_DIR}" ]] || die "Directory not found: ${LINUX_APPS_DIR}"
[[ -f "${MAKE_SCRIPT}" ]] || die "Script not found: ${MAKE_SCRIPT}"

need_cmds=(cmake make gcc pkg-config)
missing_cmds=()
for c in "${need_cmds[@]}"; do
  command -v "${c}" >/dev/null 2>&1 || missing_cmds+=("${c}")
done

if [[ "${NO_INSTALL}" == "no" ]]; then
  if [[ "${#missing_cmds[@]}" -gt 0 ]]; then
    log "Missing commands detected: ${missing_cmds[*]}"
  fi

  if command -v apt-get >/dev/null 2>&1; then
    if [[ "${EUID}" -ne 0 ]]; then
      die "Root is required to install dependencies automatically. Please run with sudo, or use --no-install."
    fi

    log "Installing dependencies (from linux-apps/README.md)..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y \
      cmake \
      build-essential \
      pkg-config \
      libglib2.0-dev \
      libxml2-dev \
      libudev-dev \
      libmbim-glib-dev \
      libdbus-1-dev \
      libmm-glib-dev \
      libfwupd-dev \
      fastboot
    log "Dependencies installed."
  else
    log "apt-get not found; skipping automatic dependency installation (use --no-install)."
  fi
else
  log "--no-install: skipping dependency installation; build only."
fi

log "Building package: ${PKG_TYPE} ${PROJECT_BUILD} ${OEM_BUILD}"
cd "${LINUX_APPS_DIR}"
bash "${MAKE_SCRIPT}" "${PKG_TYPE}" "${PROJECT_BUILD}" "${OEM_BUILD}"

log "Done. Artifacts directory: ${LINUX_APPS_DIR}/binary_deb/"
