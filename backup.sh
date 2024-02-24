#!/bin/bash
################################################################################
##    Bash script for file or directory compression                           ##
################################################################################

# CONFIGURATION VARIABLES
# $ArchName - Directory where the previous archives will be placed.
# $TimeStamp - Timestamp format.
#              [ default: "[%Y.%m.%d - %H:%M:%S]" ]
# $SrcFiles - Source, file or directory to compress.
# $PathToStore - Directory where the archive will be placed

echo "Starting script"

SrcFiles=$(ls /home/clouduser/*.txt)
PathToStore='/home/backup/archives/'
TimeStamp=$(date +'%d%m%Y')
ArchName='archive_'$TimeStamp'.tar'

tar -cf $PathToStore$ArchName $SrcFiles
echo "Files:"$SrcFiles
echo "Created archive:"$ArchName