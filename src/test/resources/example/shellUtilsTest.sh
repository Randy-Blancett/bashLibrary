#!/bin/bash
BL_PATH=$( dirname $0 )
BL_PATH=$( readlink -e $BL_PATH )
LIB_PATH=$( dirname $( dirname $( dirname $BL_PATH ) ) )/main/bash/lib

source $LIB_PATH/shellUtils.sh

parseCmdLine "$@"

USER_INPUT=""
askUser "Test Prompt" "USER_INPUT"
log "User Said: ${USER_INPUT}" "${STANDARD}"

USER_INPUT=""
askUser "Test Prompt" "USER_INPUT" "Default Data"
log "User Said: ${USER_INPUT}" "${STANDARD}"

USER_INPUT=""
askUserSecret "Tell Me a Secret" "USER_INPUT" 
log "User Said: ${USER_INPUT}" "${STANDARD}"


isRoot && echo "Am Root" || echo "Not Root"
ensureUser "darkowl1234"

groupExists noGroup && echo Group exists || echo group not exist

ensureGroup "root"
echo ""
userInGroup "root" "root" && echo "Is a member" || echo " Is not a member"
userInGroup "darkowl" "root" && echo "Is a member" || echo " Is not a member"
echo ""
ensureUserInGroup "root" "root"
echo Ensure Root
ensureRoot