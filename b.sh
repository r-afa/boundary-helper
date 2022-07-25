#! /bin/bash

#########################################################
# Helper created to make it easier to use Boundary CLI  #
#                                                       #
# Author: github.com/rafa-o                             #
#########################################################

if [ -z "$1" ]; then
  echo "No command passed."
  exit 2
fi

BOUNDARY_TOOLS_HOME=~
TARGET_RESOURCE=$1
authenticate() {
  echo "Authenticating.."
  boundary authenticate oidc --auth-method-id $(boundary scopes list -recursive -filter '"gorillas" in "/item/name"' -format=json | jq -r '.items[0].primary_auth_method_id')
}

reload-targets() {
  echo "Reloading target list."
  boundary targets list -recursive -filter '"authorize-session" in "/item/authorized_actions"' -format json | python -c "import sys, json; targets = [entry['name'] for entry in json.load(sys.stdin)['items']]; print(' '.join(map(str, targets)))" >| ~/.boundary_targets
  echo "Done."
}

case $TARGET_RESOURCE in
  authenticate)
    authenticate
    return
    ;;
  switch-environment-to-prod)
    export BOUNDARY_ADDR=https://boundary.gorillas-production.services
    echo "PROD" >| ~/.boundary_env
    echo "Switched env to PRODUCTION."
    authenticate
    reload-targets
    return
    ;;
  switch-environment-to-staging)
    export BOUNDARY_ADDR=https://boundary.gorillas-staging.services
    echo "STAGING" >| ~/.boundary_env
    echo "Switched env to STAGING."
    authenticate
    reload-targets
    return
    ;;
  reload-target-list)
    reload-targets
    return
    ;;
  *)
    ;;
esac

CURRENT_CONNECTION_DETAILS_FILE=$BOUNDARY_TOOLS_HOME/.boundary_current_connection_details
# at this point, check which kind of resource we should connect to and fetch credentials with boundary
if [[ $TARGET_RESOURCE == mongo* ]] ; then
export BOUNDARY_CONNECTED_RESOURCE_TYPE=mongodb
  (. $BOUNDARY_TOOLS_HOME/.boundary_credential_helper.sh &)
  boundary connect -target-name $TARGET_RESOURCE -target-scope-name platform -listen-addr=127.0.0.1 -listen-port=27018 -format json | tee $CURRENT_CONNECTION_DETAILS_FILE
elif [[ $TARGET_RESOURCE == postgresql* ]] ; then
  DB_NAME=$(echo $TARGET_RESOURCE | cut -d '-' -f2)
  export BOUNDARY_CONNECTED_RESOURCE_TYPE=postgresql
  export POSTGRES_DB_NAME=$DB_NAME
  echo "POSTGRES_DB_NAME>> $POSTGRES_DB_NAME"
  (. $BOUNDARY_TOOLS_HOME/.boundary_credential_helper.sh &)
  boundary connect -target-name $TARGET_RESOURCE -target-scope-name platform -listen-addr=127.0.0.1 -listen-port=12345 -format json | tee $CURRENT_CONNECTION_DETAILS_FILE
elif [[ $TARGET_RESOURCE == mysql* ]] ; then
  export BOUNDARY_CONNECTED_RESOURCE_TYPE=mysql
  (. $BOUNDARY_TOOLS_HOME/.boundary_credential_helper.sh &)
  boundary connect -target-name $TARGET_RESOURCE -target-scope-name platform -listen-addr=127.0.0.1 -listen-port=12345 -format json | tee $CURRENT_CONNECTION_DETAILS_FILE
fi

export BOUNDARY_CONNECTED_RESOURCE_TYPE=

# clear connection details when boundary command gets interrupted
echo "" >| $CURRENT_CONNECTION_DETAILS_FILE