#! /bin/bash
# sleep to give time for the creds to be populated on temp file
sleep 3

BOUNDARY_TOOLS_HOME=~
CURRENT_CONNECTION_DETAILS_FILE=$BOUNDARY_TOOLS_HOME/.boundary_current_connection_details
CREDENTIALS=$(cat $CURRENT_CONNECTION_DETAILS_FILE | python -c "import sys, json; credentials = json.load(sys.stdin)['credentials'][0]['secret']['decoded']; print(','.join([credentials['username'], credentials['password']]))")

PARSED_CREDENTIALS=(`echo $CREDENTIALS | tr ',' ' '`)
USER=${PARSED_CREDENTIALS[1]}
PASSWORD=${PARSED_CREDENTIALS[2]}

case $BOUNDARY_CONNECTED_RESOURCE_TYPE in
  mysql)
    CONNECTION_STRING="mysql -h 127.0.0.1 -P 12345 --protocol=tcp -u$USER -p$PASSWORD"
    ;;
  postgresql)
    CONNECTION_STRING="psql postgresql://$USER:$PASSWORD@localhost:12345/$POSTGRES_DB_NAME"
    ;;
  mongodb)
    CONNECTION_STRING="mongo --authenticationDatabase admin --tls --tlsAllowInvalidCertificates --username $USER --password $PASSWORD 127.0.0.1:27018"
    ;;
  *)
    CONNECTION_STRING=""
    ;;
esac

echo $CONNECTION_STRING | pbcopy
printf "\nConnection string has been copied to the clipboard.\n"