#! /bin/sh


(
	mkdir files
	cd files

	wget -q \
		"https://linux-libre.fsfla.org/pub/linux-libre/freesh/pool/main/l/linux-5.10.46-gnu/linux-headers-5.10.46-gnu_5.10.46-gnu-1.0_amd64.deb" \
		"https://linux-libre.fsfla.org/pub/linux-libre/freesh/pool/main/l/linux-5.10.46-gnu/linux-image-5.10.46-gnu_5.10.46-gnu-1.0_amd64.deb"
)
