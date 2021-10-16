#!/bin/bash
LIB_PATH=../../../main/resources/bash/lib
LIB_PATH=$(readlink -e $BL_PATH)

source $BL_PATH/cmdOptions.sh

echo $BL_PATH

parseCmdLine "$@"