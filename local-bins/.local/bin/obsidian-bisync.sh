#!/bin/env bash

OBSIDIAN_VAULT_DIR='/home/lucas/Vaults/'
LOCAL_VAULT_BACKUP='/home/lucas/.vaults-backup/'
REMOTE_NAME=gdrive
REMOTE_VAULT_DIR='/Vaults/'

set -e

echo "--- Starting Local Sync: $(date) ---"

rclone bisync "$OBSIDIAN_VAULT_DIR" "$LOCAL_VAULT_BACKUP" --verbose

echo "--- Local Sync Complete: $(date) ---"
echo "--- Starting Remote Vault Bisync: $(date) ---"

rclone bisync "$LOCAL_VAULT_BACKUP" "$REMOTE_NAME:$REMOTE_VAULT_DIR" --verbose

echo "--- Sync complete: $(date) ---"
