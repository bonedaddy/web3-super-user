#! /bin/bash
REPO_PATH="$1"
BACKUP_NAME="$2"
SOURCE_PATH="$3"
DEST_PATH="$4"
BORG_PASSPHRASE="$5"
export $BORG_PASSPHRASE

# example
# backup.sh /mnt/ssd_disk/nethermind_backup some_name  /mnt/nvme_disk/nethermind somepassword


/usr/bin/borg create --progress "$REPO_PATH::$BACKUP_NAME" "$SOURCE_PATH" "$DEST_PATH"