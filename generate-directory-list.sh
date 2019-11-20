#!/usr/bin/bash

echo "Enter directory full path"
read DIR_HOME
echo "Enter config name"
read CONFIG_NAME

CONFIG_FILE=$( pwd )/dir_config/atl-data-"${CONFIG_NAME}"

find "${DIR_HOME}" -maxdepth 1 -type d >> $CONFIG_FILE

