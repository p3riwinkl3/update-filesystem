#!/usr/bin/bash

readonly WEBHOOK_URL='https://hooks.slack.com/services/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'
readonly WEBHOOK_URL_TEAMS='https://outlook.office.com/webhook/1eb8b78e-dcd4-478a-ac0d-33124d089615@64e5ad32-cb04-44df-8896-bed5d7792429/IncomingWebhook/14d265e36351405ca811c011d02d3a3f/805027c5-deca-4159-8b80-2ee44c6e4af3'

echo "Enter configuration value. Type 'odd' or 'even' or 'test'..."
read CONFVAL
    if [ "$CONFVAL" = "odd" ]; then
        CONFIGS=( '1' '3' '5' )
    elif [ "$CONFVAL" = "even" ]; then
        CONFIGS=( '2' '4' '6' )
    elif [ "$CONFVAL" = "test" ]; then
        CONFIGS=( 'test' 'test2' )
    else
        "Invalid configuration value. Exiting script"
        exit 
    fi 

SERVERNAME=$( hostname )

echo $SERVERNAME

case $SERVERNAME in 
    "LPRNEDCOBUC001V")
    CONFIGNAME='repositories1'
    ;;
    "LPRNEDCOBUC002V")
    CONFIGNAME='repositories2'
    ;;
    "LPRNEDCOBUC003V")
    CONFIGNAME='repositories3'
    ;;
    *)
    echo "Invalid hostname"
    ;;
esac


for CONFIG in "${CONFIGS[@]}"; do
    echo -e "sh $0 --config_name=$CONFIGNAME$CONFIG --action=chmod --permission=700"
    sh /app/atlassian/alt_cleanup/update-filesystem-property.sh --config_name=${CONFIGNAME}${CONFIG} --action=chmod --permission=700
    curl -X POST -H 'Content-type: application/json' --data '{"text": "'"Config ${CONFIG} alternates file cleanup complete in node ${NODE}."'"}' ${WEBHOOK_URL}
    curl -X POST -H 'Content-type: application/json' --data '{"text": "'"Config ${CONFIG} alternates file cleanup complete in node ${NODE}."'"}' ${WEBHOOK_URL_TEAMS}
    done

# sh /app/atlassian/bitbucket/bin/start-bitbucket.sh --no-search
