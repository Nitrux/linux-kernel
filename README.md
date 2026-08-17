# Linux Kernel for Nitrux

[![Generic badge](https://img.shields.io/badge/Arch-x64-yellowgreen.svg)](https://shields.io/)

<p align="center">
  <img width="128" height="128" src="https://raw.githubusercontent.com/Nitrux/luv-icon-theme/master/Luv/places/96/start-here.svg">
</p>

# Introduction

This repository builds a full patched Linux kernel package set and the matching meta package.

## Building

The build uses the CachyOS kernel source version in `VERSION`, applies the patch list in `patches/series`, and produces Debian packages in `output/`.

On Debian or Ubuntu, run:

```sh
./gh-build.sh
```

ThinLTO is the local-build default. Set `KERNEL_DEBUG_COMPRESSION=zstd` to reduce build-disk usage while retaining BTF. Set `KERNEL_LTO=none` for a faster, less resource-intensive build, or `KERNEL_LTO=full` for Full LTO.

# Licensing

This repository contains files under multiple licenses.

- Repository build and packaging automation is licensed under **BSD-3-Clause** (see `LICENSE`).
- Debian package metadata licensing is documented in `meta-package/debian/copyright`.
- Kernel source and patch content keep their respective upstream licensing.

# Issues

If you find problems with the contents of this repository, please create an issue and use the **🐞 Bug report** template.

## Submitting a bug report

Before submitting a bug, you should look at the [existing bug reports](https://github.com/Nitrux/linux-kernel/issues) to verify that no one has reported the bug already.

©2026 Nitrux Latinoamericana S.C.
