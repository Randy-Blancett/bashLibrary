#!/bin/bash
BL_PATH=$( dirname $0 )
BL_PATH=$( readlink -e $BL_PATH )
echo $BL_PATH
LIB_PATH=$( dirname $( dirname $( dirname $BL_PATH ) ) )/main/bash/lib
echo $LIB_PATH

source $LIB_PATH/shellUtils.sh

parseCmdLine "$@"

isRoot && echo "Am Root" || echo "Not Root"

ensureRoot