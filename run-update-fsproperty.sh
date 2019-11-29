#!/usr/bin/bash

readonly WEBHOOK_URL='<slack webhook URL>'
readonly WEBHOOK_URL_TEAMS='<teams webhook URL>'

echo "$0 is now running"

function usage(){
    echo -e "Usage: $0 --conf_val=odd|even" 
    echo -e "\t-h --help\n"
    echo -e "\t--conf_val=enter odd| even"
    
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        --conf_val)
            CONFVAL=$VALUE
            ;;
        --config_name)
            CONFIGNAME=$VALUE
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

    if [ "$CONFVAL" = "odd" ]; then
        CONFIGS=( '1' '3' '5' )
    elif [ "$CONFVAL" = "even" ]; then
        CONFIGS=( '2' '4' '6' )
    elif [ "$CONFVAL" = "test" ]; then
        CONFIGS=( '7' '8' '9' )
    elif [ "$CONFVAL" = "test2" ]; then
        CONFIGS=( '10' '11' '12' )
    else
        "Invalid configuration value. Exiting script"
        exit 
    fi 

SERVERNAME=$( hostname )


echo -e "Updating repositories directory"
for CONFIG in "${CONFIGS[@]}"; do
    echo -e "sh $0 --config_name=$CONFIGNAME$CONFIG --action=chmod --permission=700"
    sh /app/atlassian/alt_cleanup/mass-permission-update/update-filesystem-property.sh --config_name=${CONFIGNAME}${CONFIG} --action=chmod --permission=700
    echo -e "\n\n"
    curl -X POST -H 'Content-type: application/json' --data '{"text": "'"${CONFIGNAME}${CONFIG} Update Permission Mode for ${SERVERNAME} Complete."'"}' ${WEBHOOK_URL}
    curl -X POST -H 'Content-type: application/json' --data '{"text": "'"${CONFIGNAME}${CONFIG} Update Permission Mode for ${SERVERNAME} Complete."'"}' ${WEBHOOK_URL_TEAMS}
 
done

if [[ "${SERVERNAME,,}" == *001v ]]; then
    echo -e "Updating permission mode on shared directories excluding repositories"
    CONFIGNAME="shareddata"
    sh /app/atlassian/alt_cleanup/mass-permission-update/update-filesystem-property.sh --config_name=${CONFIGNAME} --action=chmod --permission=700
    echo -e "\n\n"
    curl -X POST -H 'Content-type: application/json' --data '{"text": "'"${CONFIGNAME} Update Permission Mode for ${SERVERNAME} Complete."'"}' ${WEBHOOK_URL}
    curl -X POST -H 'Content-type: application/json' --data '{"text": "'"${CONFIGNAME} Update Permission Mode for ${SERVERNAME} Complete."'"}' ${WEBHOOK_URL_TEAMS}
fi

