#! /bin/bash

lighthouse \
	vc \
	--enable-doppelganger-protection \
	--network mainnet \
	--debug-level info \
	--datadir /mnt/nvme_disk/lighthouse \
	--http \
	--metrics \
	--suggested-fee-recipient=...
