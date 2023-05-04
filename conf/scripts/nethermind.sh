#! /bin/bash

# used to star a nethermind node, performing a check before startup to see if an updated binary is available locally
# if an updated binary is available locally, copy that to the execution directory before starting up

GOT_HASH=$(sha256sum /home/nethermind/nethermind-build/Nethermind.Runner)
WANT_HASH=$(sha256sum /var/lib/nethermind-build/Nethermind.Runner)

if [[ "$GOT_HASH" != "$WANT_HASH" ]]; then
    echo "[WARN] detected new nethermind binary, copying before running"
    cp -r /var/lib/nethermind-build /home/nethermind
fi

/home/nethermind/nethermind-build/Nethermind.Runner --datadir /mnt/nvme_disk/nethermind --baseDbPath /mnt/nvme_disk/nethermind --config /home/nethermind/config.json