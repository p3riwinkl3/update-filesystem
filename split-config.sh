#!/usr/bin/bash

function usage(){
    echo -e "Usage: $0 --configuration=<config file name> --config_name=<name of config file> --create_subdir=yes|no --config_num=" 
    echo -e "\t-h --help\n"
    echo -e "\t--configuration=config to split. Options are 'dir' or 'alt'"
    echo -e "\t--config_name=repositories|respositories2|repositories3"
    echo -e "\t\t Name of the configuration file which contains the list of dir that will be updated; "
    echo -e "\t\t\t configuration file must exist in dir_config director\n"
    echo -e "\t--create_subdir=yes|no"
    echo -e "\t\t If subdir is needed to be created where the config files will be generated"
    echo -e "\t--config_num=number of configuration files that will be generated"
}


while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        --configuration)
            CONFIG_SPLIT=$VALUE
            ;;
        --config_name)
            ENVIRONMENT=$VALUE
            ;;
        --create_subdir)
            TYPE=$VALUE
            ;;
        --config_num)
            DIV_BY=$VALUE
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


if [ "$CONFIG_SPLIT" = "dir" ]; then
    CONFIG_PATH="$( pwd )/dir_config"
    CONFIGNAME="atl-data"
elif [ "$CONFIG_SPLIT" = "alt" ]; then
    CONFIG_PATH="$( pwd )/config"
    CONFIGNAME="altfile"
else
    echo "Enter config directory in the next line: "
    read CONFIG_PATH
    echo "Enter config name in the next line: "
    read CONFIGNAME
fi


# CONFIG_PATH="$( pwd )/config"
NODE_PATH="${CONFIG_PATH}/${ENVIRONMENT}"
cd "${CONFIG_PATH}"
echo "$( pwd )"

readarray ALTERNATES < "$CONFIG_PATH/$CONFIGNAME-$ENVIRONMENT"

ARRAY_LENGTH=${#ALTERNATES[@]}
INTERVAL=$(( ARRAY_LENGTH / DIV_BY ))
let "INTERVAL+=5"

TMP_ALTERNATES_LENGTH=${#TEMP_ALTERNATES[@]}
echo "${TMP_ALTERNATES_LENGTH} ${INTERVAL}"


IND=0
COUNT=1
while [ "$IND" -lt $DIV_BY ]; do
    LOW_IND=$(( IND*INTERVAL ))
    TEMP_ALTERNATES=( "${ALTERNATES[@]:LOW_IND:INTERVAL}" )

    for ALTERNATE in "${TEMP_ALTERNATES[@]}"; do
        if [ "$TYPE" = "no" ]; then
            echo -n "${ALTERNATE}" >> "$CONFIG_PATH/$CONFIGNAME-$ENVIRONMENT$COUNT"
        elif [ "$TYPE" = "yes" ]; then
            if [ ! -d "$NODE_PATH" ]; then
                mkdir "${NODE_PATH}"
            fi
            echo -n "${ALTERNATE}" >> "$NODE_PATH/$CONFIGNAME-$ENVIRONMENT-$COUNT"
        fi

    done

    let "COUNT+=1"
    let "IND+=1"
done

