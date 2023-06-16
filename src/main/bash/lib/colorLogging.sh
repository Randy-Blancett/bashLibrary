#!/bin/bash
#FILE
#AUTHOR Randy Blancett
#AUTHOR_EMAIL Randy.Blancett@gmail.com
#VERSION 1.3.0
# This library adds the ability to add color to your log messages
#VERSIONS
#V 1.3.0
#RELEASE ???
# Add Default Color to logging
#
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

    #VARIABLE
    #PROTECTED
    #GROUP DefautlColors
    # This variable sets the default color for Log Statements at the Error Level
    LOG_DEFAULT_COLOR_ERROR=${TEXT_RED}

    #VARIABLE
    #PROTECTED
    #GROUP DefautlColors
    # This variable sets the default color for Log Statements at the Standard Level
    LOG_DEFAULT_COLOR_STANDARD=${TEXT_GREEN}

    #VARIABLE
    #PROTECTED
    #GROUP DefautlColors
    # This variable sets the default color for Log Statements at the Info Level
    LOG_DEFAULT_COLOR_INFO=${TEXT_BLUE}

    #VARIABLE
    #PROTECTED
    #GROUP DefautlColors
    # This variable sets the default color for Log Statements at the Debug Level
    LOG_DEFAULT_COLOR_DEBUG=${TEXT_CYAN}

    #VARIABLE
    #PROTECTED
    #GROUP DefautlColors
    # This variable sets the default color for Log Statements at the Trace Level
    LOG_DEFAULT_COLOR_TRACE=${TEXT_YELLOW}

    #VARIABLE
    #PROTECTED
    #GROUP DefautlColors
    # This variable sets the default color for Log Statements at the OMG Level
    LOG_DEFAULT_COLOR_OMG=${TEXT_MAGENTA}

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
    # log "This Message" "${STANDARD}" "${TEXT_RED}"
    function log() {
        if [ "$2" -le "$VERBOSE" ]; then
            if [[ "ENABLE_COLOR" -eq 1 ]] ; then
                local COLOR="${3}"
                if [[ -z "${COLOR}" ]];
                then
                    case "$2" in
                    "${ERROR}")
                        COLOR="${LOG_DEFAULT_COLOR_ERROR}"
                        ;;

                    "${STANDARD}")
                        COLOR="${LOG_DEFAULT_COLOR_STANDARD}"
                        ;;

                    "${INFO}")
                        COLOR="${LOG_DEFAULT_COLOR_INFO}"
                        ;;

                    "${DEBUG}")
                        COLOR="${LOG_DEFAULT_COLOR_DEBUG}"
                        ;;

                    "${TRACE}")
                        COLOR="${LOG_DEFAULT_COLOR_TRACE}"
                        ;;

                    "${OMG}")
                        COLOR="${LOG_DEFAULT_COLOR_OMG}"
                        ;;

                    *)
                        COLOR=$TEXT_MAGENTA
                        ;;
                    esac
                fi
                echo -e "\e[${COLOR}m${1}\e[0m"
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
    addVar2Dump "LOG_DEFAULT_COLOR_ERROR"
    addVar2Dump "LOG_DEFAULT_COLOR_STANDARD"
    addVar2Dump "LOG_DEFAULT_COLOR_INFO"
    addVar2Dump "LOG_DEFAULT_COLOR_DEBUG"
    addVar2Dump "LOG_DEFAULT_COLOR_TRACE"
    addVar2Dump "LOG_DEFAULT_COLOR_OMG"

    addCommandLineArg "" "noColor" false "If this flag is set color logging will be disabled"

    addCommandLineParser "optParserLoggingColor"
fi
