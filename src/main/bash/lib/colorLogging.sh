#!/bin/bash
#FILE
#AUTHOR Randy Blancett
#AUTHOR_EMAIL Randy.Blancett@gmail.com
#VERSION 1.1.0
# This library adds the ability to add color to your log messages
#VERSIONS
#V 1.1.0
#RELEASE 11NOV2021
# Updated code to use ShellCheck suggested conventions
#
#V 1.0.0
#RELEASE 01NOV2021
# Initial Release

if [[ " ${LOADED_LIB[*]} " != *" colorLogging.sh "* ]]; then
    LOADED_LIB+=('colorLogging.sh')

    # Allow the library to parse command line options
    source "$LIB_PATH"/cmdOptions.sh
    # Adds the base logging features
    source "$LIB_PATH"/logging.sh

    #VARIABLE
    #PROTECTED
    #GROUP colorLogging
    # This variable turns on/off color logging 1 = on 0 = off
    ENABLE_COLOR=1

    #CONSTANT
    #PUBLIC
    #GROUP Text Colors
    # Sets text to red.
    TEXT_RED=31

    #CONSTANT
    #PUBLIC
    #GROUP Text Colors
    # Sets text to green.
    TEXT_GREEN=32

    #CONSTANT
    #PUBLIC
    #GROUP Text Colors
    # Sets text to yellow.
    TEXT_YELLOW=33

    #CONSTANT
    #PUBLIC
    #GROUP Text Colors
    # Sets text to blue.
    TEXT_BLUE=34

    #CONSTANT
    #PUBLIC
    #GROUP Text Colors
    # Sets text to magenta.
    TEXT_MAGENTA=35

    #CONSTANT
    #PUBLIC
    #GROUP Text Colors
    # Sets text to cyan.
    TEXT_CYAN=36

    #CONSTANT
    #PUBLIC
    #GROUP Text Colors
    # Sets text to light blue.
    TEXT_LIGHT_BLUE=94

    #METHOD
    #PUBLIC
    # Log information to the screen if it is Equal to or less than the current verbosity level.
    #
    #PARAMETERS
    # $1 | Message | Message to display
    # $2 | Log Level | The Level of this message
    # $3 | Text Color | Color of the text (if enabled)
    #
    #EXAMPLES
    # log "This Message" $STANDARD $TEXT_RED
    function log() {
        if [ "$2" -le "$VERBOSE" ]; then
            if [[ "ENABLE_COLOR" -eq 1 ]] && [[ -n "$3" ]]; then
                echo -e "\e[${3}m${1}\e[0m"
            else
                echo -e "$1"
            fi
            if [ "$LOG2FILE" = "1" ]; then
                echo -e "$1" >>"${LOG_DIR}/${LOG_FILE}"
            fi
        fi
    }

    #METHOD
    #PRIVATE
    # this will parse command line options for this library
    #
    #PARAMETERS
    # $1 | option | The option to parse
    # $2 | data | The Data passed with the option | optional
    function optParserLoggingColor() {
        case $1 in
        --noColor)
            ENABLE_COLOR=0
            ;;
        esac
    }

    ##############################################################
    # Library Setup                                              #
    ##############################################################
    addVar2Dump "ENABLE_COLOR"

    addCommandLineArg "" "noColor" false "If this flag is set color logging will be disabled"

    addCommandLineParser "optParserLoggingColor"
fi
