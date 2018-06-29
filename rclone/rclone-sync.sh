#!/bin/bash

# A list of actions to push changes to Google Drive


# Where to move deleted files in destination.
trashbin="--backup-dir gdrive:Backup/Thrash"

# Uncomment to test with dry tun (does not perform actual sync)
test=""
test="--dry-run -v"

# Global uptions
options="--update"              # Implements a very crude bidirectional sync

# Global filters
global_filter="--filter-from $HOME/.dotfiles/rclone/global-filter"


# Backup all Zotero managed files and associeted notes.
source="$HOME/Documents/Library/ZoteroPDFs/"
dest="gdrive:Backup/Documents/Library/ZoteroPDFs/"
rclone sync "$source" "$dest" $trashbin $test $options $global_filter
