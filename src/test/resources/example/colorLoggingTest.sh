#!/bin/bash
BL_PATH=$( dirname $0 )
BL_PATH=$( readlink -e $BL_PATH )
LIB_PATH=$( dirname $( dirname $( dirname $BL_PATH ) ) )/main/bash/lib

source $LIB_PATH/colorLogging.sh

parseCmdLine "$@"


varDump $STANDARD
log "hello World" $STANDARD $TEXT_RED
log "hello World" $STANDARD 
log "hello World" $STANDARD $TEXT_BLUE
log "Default Error" $ERROR
log "Default Standard" $STANDARD
log "Default Info" $INFO
log "Default Debug" $DEBUG
log "Default Trace" $TRACE
log "Default OMG" $OMG