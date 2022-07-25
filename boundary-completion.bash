#/usr/bin/env bash
# reference: https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial

BOUNDARY_ENV_FILE=~/.boundary_env
BOUNDARY_TARGETS_FILE=~/.boundary_targets
# if .boundary_env file does not exist, create it
# and set env variable to point to staging
if [[ ! -a "$BOUNDARY_ENV_FILE" ]]; then
  echo "STAGING" >| $BOUNDARY_ENV_FILE
  export BOUNDARY_ADDR=https://boundary.gorillas-staging.services
else
  ENV=`cat $BOUNDARY_ENV_FILE`
  if [[ $ENV == 'STAGING' ]]; then
    export BOUNDARY_ADDR=https://boundary.gorillas-staging.services
  else
    export BOUNDARY_ADDR=https://boundary.gorillas-production.services
  fi
fi

# if .boundary_targets file does not exist, create it
if [ ! -a $BOUNDARY_TARGETS_FILE ]; then
  touch $BOUNDARY_TARGETS_FILE
fi

_boundary_completions()
{
  COMPREPLY=($(compgen -W "authenticate reload-target-list switch-environment-to-prod switch-environment-to-staging $(cat $BOUNDARY_TARGETS_FILE)" -- "${COMP_WORDS[1]}"))
}

complete -F _boundary_completions b