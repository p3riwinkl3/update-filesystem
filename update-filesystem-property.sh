#!/usr/bin/bash

function usage(){
    echo -e "Usage: $0 --config_name=<config file name> --action=chown|chmod" 
    echo -e "\t\t--username=<username value for chown action> --groupname=<groupname value for chown> \n\t\t--permission=<permission mode for chmod action>  --help"
    echo -e "\t-h --help\n"
    echo -e "\t--config_name=(repositories1|repositories2|repositories3)"
    echo -e "\t\t Name of the configuration file which contains the list of dir that will be updated; "
    echo -e "\t\t\t configuration file must exist in dir_config director\n"
    echo -e "\t--action=(chown|chmod)"
    echo -e "\t\t Action options that the script will perform; Options are:"
    echo -e "\t\t\t chown - change owner atlbitbucket default owner"
    echo -e "\t\t\t chmod - change permission 750 defaul permission\n"
    echo -e "\t--username=username which will be set as owner. Use this parameter if action is chown\n"
    echo -e "\t--groupname=groupname which will be set as owner. Use this parameter if action is chown\n"    
    echo -e "\t--permission=permission mode that will be set to the dir. Use this parameter if action is chmod"
    echo ""
    echo -e "Sample Usage:"
    echo -e "\t\tsh $0 --config_name=repositories --action=chown --username=atlbitbucket --groupname=users"
    echo -e "\t\tChanges the owner of all directories listed in atl-data-repositories file found on ./dir_config to atlbitbucket.\n\n"
    echo -e "\t\tsh $0 --config_name=repositories --action=chmod -permission=777"
    echo -e "\t\tSets the permissions of all files and directories listed in the configuration file to 777.\n\n"

}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        --config_name)
            CONFIGNAME=$VALUE
            ;;
        --action)
            ACTION=$VALUE
            ;;
        --username)
            USERNAME=$VALUE
            ;;
        --groupname)
            GROUPNAME=$VALUE
            ;;
        --permission)
            PERM_MODE=$VALUE
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

CONFIG_PATH="$( pwd )/dir_config"
LOG_PATH="$( pwd )/log"
readarray -t DIR_LIST < "$CONFIG_PATH/atl-data-${CONFIGNAME}"

# Set default values
if [[ -z $USERNAME ]]; then
    USERNAME="atlbitbucket"
fi    

if [[ -z $GROUPNAME ]]; then
    GROUPNAME=""
fi

if [[ -z PERM_MODE ]]; then
    PERM_MODE=750
fi

#Check if Action is valid
if [[ "$ACTION" == 'chown' || "$ACTION" == 'chmod' ]]; then
    echo "Valid action set..."
else
    echo "Invalid action. Exiting script."
    exit
fi


DIR_COUNT=${#DIR_LIST[@]}
COUNTER=1
SCRIPTSTART=$( date )

echo "Script ${0} excection start at ${SCRIPTSTART}" >> "$LOG_PATH/${ACTION}-${CONFIGNAME}-Status.log"

for SUBDIR in "${DIR_LIST[@]}"; do 
    echo "Processing ${COUNTER} out of ${DIR_COUNT}"

    if [ "$ACTION" = 'chown' ]; then
        echo "Changing ownership on ${SUBDIR}"
        # chown -R "${USERNAME}":"${GROUPNAME}" "${SUBDIR}"    
    elif [ "$ACTION" = 'chmod' ]; then
        echo "Setting file permission on ${SUBDIR} to ${PERM_MODE}"
        chmod -R "${PERM_MODE}" "${SUBDIR}"
    fi  

    let "COUNTER+=1"
done
SCRIPTEND=$( date )
echo "Script ${0} excection end at ${SCRIPTEND}" >> "$LOG_PATH/${ACTION}-${CONFIGNAME}-Status.log"
