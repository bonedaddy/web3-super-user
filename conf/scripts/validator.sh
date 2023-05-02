#! /bin/bash

lighthouse \
	vc \
	--builder-proposals \
	--enable-doppelganger-protection \
	--network mainnet \
	--debug-level debug \
	--init-slashing-protection \
	--datadir /mnt/nvme_disk/rocketpool/data/validators/lighthouse \
	--http \
	--http-allow-origin "*" \
	--metrics \
	--metrics-address "0.0.0.0" \
	--metrics-allow-origin "*" \
	--monitoring-endpoint ... \
	--suggested-fee-recipient=..
