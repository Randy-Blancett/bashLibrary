#!/bin/bash
BL_PATH=$( dirname $0 )
BL_PATH=$( readlink -e $BL_PATH )
LIB_PATH=$( dirname $( dirname $( dirname $BL_PATH ) ) )/main/bash/lib

source $LIB_PATH/shellUtils.sh
VERBOSE=5

parseCmdLine "$@"

isRoot && echo "Am Root" || echo "Not Root"

ensureUser "darkowl1234"

ensureRoot