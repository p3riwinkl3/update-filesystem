#!/usr/bin/bash

# echo "Enter directory full path"
# read DIR_HOME
# echo "Enter config name"
# read CONFIG_NAME

function usage(){
    echo -e "Usage: $0 --dir_path=<dir path to extract list> --config_name=<repo|dev|prod>" 
    echo -e "\t-h --help\n"
    echo -e "\t--dir_path=Path where the list will be extracted"
    echo -e "\t--config_name=repositories|respositories2|repositories3"
}


while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        --dir_path)
            DIR_HOME=$VALUE
            ;;
        --config_name)
            CONFIG_NAME=$VALUE
            ;;
        
        -h | --help)
            usage
            exit
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

CONFIG_DIR=$( pwd )/dir_config


 if [ ! -d "$CONFIG_DIR" ]; then
    mkdir "${CONFIG_DIR}"
fi

CONFIG_FILE="${CONFIG_DIR}"/atl-data-"${CONFIG_NAME}"

if [ -f "$CONFIG_FILE" ]; then
    mv ${CONFIG_FILE} ${CONFIG_FILE}.old
fi

find "${DIR_HOME}" -maxdepth 1 -type d >> $CONFIG_FILE