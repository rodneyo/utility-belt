#!/bin/bash
#########################
# Backup specific folers
# to network share
#########################

MAILTO='roliv@stonemor.com'
INCLUDE_FILES_LIST=$HOME"/rsync_included_files"
NETWORK_BACKUP_LOCATION='/network_shares/programmer/zBackups/ROLIV'
NETWORK_BACKUP_SHARE='//hercules/programmer'
LAPTOP_MOUNT_POINT='/network_shares/programmer'
RSYNC=$(which rsync)
MUTT=$(which mutt)
RC=0

if [[ ! -e $INCLUDE_FILES_LIST ]]; then
  echo "Can't locate a included file list, aborting..."
  exit
fi

# Sometimes the cifs share can get foo barred, so try to cd to the
# backup directory, if not then try mounting it
if [[ ! -d $NETWORK_BACKUP_LOCATION ]]; then
  $(umount $LAPTOP_MOUNT_POINT)
  $(mount $LAPTOP_MOUNT_POINT)
fi

RC=$?

if [[ $RC -eq 0 ]]; then
  RSYNC_OUT=$($RSYNC -rvuc --files-from=$INCLUDE_FILES_LIST --delete / $NETWORK_BACKUP_LOCATION)
  RC=$?
else
  echo "Possibly a problem mount or remounting the windows share" |$MUTT -s "Problem with laptop backup" $MAILTO
  $RC=1
  exit
fi

if [[ $RC -eq 0 ]]; then
  echo $RSYNC_OUT |$MUTT -s "Laptop backup completed" $MAILTO
else
  echo $RSYNC_OUT |$MUTT -s "Problem with laptop backup" $MAILTO
fi


