#!/usr/bin/env bash

# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2026 <Nitrux Latinoamericana S.C. <hello@nxos.org>>


# -- Build kernel and Debian packages.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export DEBIAN_FRONTEND="${DEBIAN_FRONTEND:-noninteractive}"
export UPSTREAM_FLAVOR="${UPSTREAM_FLAVOR:-cachyos}"
export UPSTREAM_SUFFIX="${UPSTREAM_SUFFIX:--1}"
export UPSTREAM_BASE_URL="${UPSTREAM_BASE_URL:-https://github.com/CachyOS/linux/releases/download}"
export KERNEL_LOCALVERSION="${KERNEL_LOCALVERSION:--nitrux}"
export KERNEL_PKG_RELEASE="${KERNEL_PKG_RELEASE:-1nitrux1}"
export KERNEL_MAKE_JOBS="${KERNEL_MAKE_JOBS:-$(nproc)}"
export KERNEL_LTO="${KERNEL_LTO:-thin}"
export KERNEL_DEBUG_COMPRESSION="${KERNEL_DEBUG_COMPRESSION:-none}"

cd "$ROOT_DIR"


# -- Reset build workspace.

rm -rf "$ROOT_DIR/work" "$ROOT_DIR/output"
mkdir -p "$ROOT_DIR/cache" "$ROOT_DIR/output" "$ROOT_DIR/work"

if [ "$(dpkg --print-architecture)" != "amd64" ]; then
    echo "This build pipeline only supports amd64."
    exit 1
fi


# -- Install build dependencies.

if [ "${SKIP_BUILD_DEPS:-0}" != "1" ] && command -v apt-get >/dev/null 2>&1; then
    if [ "$(id -u)" -eq 0 ]; then
        APT=(apt-get)
    elif command -v sudo >/dev/null 2>&1; then
        APT=(sudo apt-get)
    else
        echo "Error: installing build dependencies requires root or sudo."
        echo "Install them manually, then rerun with SKIP_BUILD_DEPS=1."
        exit 1
    fi

    "${APT[@]}" update -y
    "${APT[@]}" install -y \
        bc \
        bison \
        build-essential \
        clang \
        cpio \
        debhelper-compat \
        devscripts \
        dh-make \
        dwarves \
        fakeroot \
        flex \
        kmod \
        libdw-dev \
        libelf-dev \
        libssl-dev \
        lld \
        llvm \
        patch \
        rsync \
        wget \
        zstd \
        xz-utils
fi


# -- Run bootstrap stages.

"$ROOT_DIR/stages/01-fetch-source"
"$ROOT_DIR/stages/02-apply-patches"
"$ROOT_DIR/stages/03-configure-kernel"
"$ROOT_DIR/stages/04-build-kernel"
"$ROOT_DIR/stages/05-stage-kernel-outputs"
"$ROOT_DIR/stages/06-prepare-meta-package"
"$ROOT_DIR/stages/07-build-meta-package"
"$ROOT_DIR/stages/08-stage-meta-outputs"

echo "Build completed. Artifacts are in: $ROOT_DIR/output"
