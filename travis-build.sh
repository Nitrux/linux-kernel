#! /bin/sh

apt-get --yes update
apt-get --yes install wget equivs curl git

deps=$(sed -e '/^#.*$/d; /^$/d; /^\s*$/d' package/dependencies | paste -sd ,)
git_commit=$(git rev-parse --short HEAD)

> configuration printf "%s\n" \
	"Section: misc" \
	"Priority: optional" \
	"Homepage: https://nxos.org" \
	"Package: linux-image-mainline-lts" \
	"Version: 0.0.6-$git_commit" \
	"Maintainer: Uri Herrera <uri_herrera@nxos.org>" \
	"Depends: $deps" \
	"Conflicts: linux-image-mainline-current" \
	"Architecture: amd64" \
	"Description: Meta package to install mainline Linux kernel (LTS)."

equivs-build configuration
