#! /bin/bash

# borg is an encrypted, deduplicated, compressable backup program


# for the purposes of quickly recovering from corrupted databases 

BORG_PASSPHRASE="$1"
PATH="$2"
export $BORG_PASSPHRASE

borg init --encryption=repokey "$PATH"