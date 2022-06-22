#! /bin/sh

apt-get --yes update
apt-get --yes install wget equivs curl git

git config --global --add safe.directory /home/travis/build/Nitrux/linux-image

deps=$(sed -e '/^#.*$/d; /^$/d; /^\s*$/d' package/dependencies | paste -sd ,)
git_commit=$(git rev-parse --short HEAD)

> configuration printf "%s\n" \
	"Section: misc" \
	"Priority: optional" \
	"Homepage: https://nxos.org" \
	"Package: linux-image-xanmod-edge" \
	"Version: 0.0.6-$git_commit" \
	"Maintainer: Uri Herrera <uri_herrera@nxos.org>" \
	"Depends: $deps" \
	"Conflicts: " \
	"Architecture: amd64" \
	"Description: Meta package to install xanmod Linux kernel."

equivs-build configuration
