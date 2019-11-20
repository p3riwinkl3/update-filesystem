#!/usr/bin/bash

# One configuration

echo "Which config to split? Type 'dir' or 'alt'"
read CONFIG_SPLIT
echo "Which environment are you working on? Type 'prod' or 'test'"
read ENVIRONMENT

echo "Which configuration will you split. Type 'shared' or 'node'"
read TYPE

echo "Number of configuration files to be generated? "
read DIV_BY

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
        if [ "$TYPE" = "shared" ]; then
            echo -n "${ALTERNATE}" >> "$CONFIG_PATH/$CONFIGNAME-$ENVIRONMENT$COUNT"
        elif [ "$TYPE" = "node" ]; then
            if [ ! -d "$NODE_PATH" ]; then
                mkdir "${NODE_PATH}"
            fi
            echo -n "${ALTERNATE}" >> "$NODE_PATH/$CONFIGNAME-$ENVIRONMENT-$COUNT"
        fi

    done

    let "COUNT+=1"
    let "IND+=1"
done

