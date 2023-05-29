#! /bin/bash

REPO_PATH="$1"
SAVE_PATH="$2"
BORG_PASSPHRASE="$3"
export $BORG_PASSPHRASE
borg key export --paper "$REPO_PATH" > "$SAVE_PATH"