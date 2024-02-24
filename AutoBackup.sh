#!/bin/bash

# Check that we are receiving 2 arguments (Directory to backup and directory to store the backup)
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 SOURCE_DIRECTORY BACKUP_DIRECTORY"
    exit 1
fi

# Save the parameters in variables
source_directory=$1
backup_directory=$2

# Create the backup directory if it does not exist
if [ ! -d "$backup_directory" ]; then
    mkdir -p $backup_directory
fi

# Get the name of the source directory
base_name=$(basename $source_directory)

# Delete daily backups that are older than 7 days
find $backup_directory -type f -mtime +7 -name "${base_name}_Daily_Backup.tar.gz" -exec rm -f {} \;

# Delete weekly backups that are older than 30 days
find $backup_directory -type f -mtime +30 -name "${base_name}_Weekly_Backup.tar.gz" -exec rm -f {} \;

# Delete monthly backups that are older than 365 days
find $backup_directory -type f -mtime +365 -name "${base_name}_Monthly_Backup.tar.gz" -exec rm -f {} \;

# Create the name of the file to backup
file="$backup_directory/${base_name}_Backup_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

# Compress and backup
tar -czvf "$file" "$source_directory"

# Verify
if [ $? -eq 0 ]; then
  echo "Backup successful in $file"
else
  echo "ERROR CREATING THE BACKUP"
fi

