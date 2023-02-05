#!/bin/sh
# Entrypoint for idrive
#/work/IDriveForLinux/scripts/check_for_update.pl silent

service idrivecron start

# Keep container up
tail -f /dev/null
