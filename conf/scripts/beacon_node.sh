#! /bin/bash

# proposer finalication epoch is based on grafana `epoch boundaries since finalization`
# profit threshold of 0.1 ETH

lighthouse \
	beacon_node \
	--target-peers 120 \
	--builder http://localhost:18550 \
	--builder-profit-threshold 100000000000000000 \
	--gui \
	--http-allow-origin "*" \
	--staking \
	--network mainnet \
	--debug-level info \
	--block-cache-size 20 \
	--prune-payloads false \
	--datadir /mnt/nvme_disk/lighthouse \
	--eth1 \
	--http \
	--http-allow-sync-stalled \
	--metrics \
	--metrics-allow-origin "*" \
	--metrics-port 5054 \
	--metrics-address 0.0.0.0 \
	--monitoring-endpoint ... \
	--execution-endpoints http://127.0.0.1:8551 \
	--checkpoint-sync-url "https://mainnet.checkpoint.sigp.io" \
	--enr-udp-port=9000 \
	--enr-tcp-port=9000 \
	--discovery-port=9000 \
	--suggested-fee-recipient=.. \
	--proposer-reorg-epochs-since-finalization 3 \
	--jwt-secrets=".."
