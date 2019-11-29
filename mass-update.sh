#!/usr/bin/bash

#Accept parameter for parallel execution
readonly SCRIPTDIR=/app/atlassian/alt_cleanup/mass-permission-update
readonly WEBHOOK_URL='<slack webhook URL>'
readonly WEBHOOK_URL_TEAMS='<teams webhook URL>'


function usage(){
    echo -e "Usage: $0 --conf_val=odd|even --conf_name=<name of the config that will be created " 
    echo -e "\t-h --help\n"
    echo -e "\t\t--conf_value=enter odd|even"
    echo -e "\t--conf_name=configuration file name value"
    
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        --conf_val)
            CONFVAL=$VALUE
            ;;
        --conf_name)
            CONFNAME=$VALUE
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

SERVERNAME=$( hostname )
SCRIPTSTART=$( date )

curl -X POST -H 'Content-type: application/json' --data '{"text": "'"$0 Script Execution on ${SERVERNAME} started at ${SCRIPTSTART}."'"}' ${WEBHOOK_URL}
curl -X POST -H 'Content-type: application/json' --data '{"text": "'"$0 Script Execution on ${SERVERNAME} started at ${SCRIPTSTART}."'"}' ${WEBHOOK_URL_TEAMS}

echo "Script running on ${SERVERNAME}"

    case "${SERVERNAME,,}" in 
        *001v )
        CONFIGNAME="${CONFNAME}1"
        ;;
        *002v )
        CONFIGNAME="${CONFNAME}2"
        ;;
        *003v )
        CONFIGNAME="${CONFNAME}3"
        ;;
        *)
        echo "Invalid hostname"
        ;;
    esac

echo $CONFIGNAME

if [ "${CONFVAL}" = "odd" ]; then
#Generate List

sh ${SCRIPTDIR}/generate-directory-list.sh --dir_path=/app/atlassian/application-data/shared/data/repositories --config_name=${CONFNAME}

#Split configuration file

sh ${SCRIPTDIR}/split-config.sh --configuration=dir --config_name=${CONFNAME} --create_subdir=no --config_num=3

sh ${SCRIPTDIR}/split-config.sh --configuration=dir --config_name=${CONFIGNAME} --create_subdir=no --config_num=6
fi 

#Run Update
sh ${SCRIPTDIR}/run-update-fsproperty.sh --conf_val=${CONFVAL} --config_name=${CONFIGNAME}

SCRIPTEND=$( date )
#Send Notification on script completion
curl -X POST -H 'Content-type: application/json' --data '{"text": "'"$0 Script Execution on ${SERVERNAME} completed at ${SCRIPTEND}."'"}' ${WEBHOOK_URL}
curl -X POST -H 'Content-type: application/json' --data '{"text": "'"$0 Script Execution on ${SERVERNAME} completed at ${SCRIPTEND}."'"}' ${WEBHOOK_URL_TEAMS}

