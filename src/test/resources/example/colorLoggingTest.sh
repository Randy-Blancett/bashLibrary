#!/bin/bash
LIB_PATH=../../../main/resources/bash/lib
LIB_PATH=$(readlink -e $BL_PATH)

source $BL_PATH/colorLogging.sh

parseCmdLine "$@"


varDump $STANDARD
log "hello World" $STANDARD $TEXT_RED
log "hello World" $STANDARD 
log "hello World" $STANDARD $TEXT_BLUE