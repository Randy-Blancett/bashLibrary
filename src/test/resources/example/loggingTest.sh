#!/bin/bash
LIB_PATH=../../../main/resources/bash/lib
LIB_PATH=$(readlink -e $BL_PATH)

source $BL_PATH/logging.sh

parseCmdLine "$@"


varDump $STANDARD