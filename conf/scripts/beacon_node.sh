#! /bin/bash

lighthouse \
        beacon_node \
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
          --execution-endpoints http://127.0.0.1:8551 \
          --checkpoint-sync-url "https://mainnet.checkpoint.sigp.io" \
          --enr-udp-port=9000 \
          --enr-tcp-port=9000 \
          --discovery-port=9000 \
          --suggested-fee-recipient=.... \
          --jwt-secrets="/home/lighthouse/jwtsecret"
