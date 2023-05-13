#! /bin/bash

# NOTE: this script is configured to use redundant beacon chain nodes

lighthouse \
	vc \
	--graffiti .. \
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
	--monitoring-endpoint https://beaconcha.in/api/v1/client/metrics?apikey=.. \
	--monitoring-endpoint-period 100 \
	--beacon-nodes http://localhost:5052,http://localhost:6052 \
	--suggested-fee-recipient=..
