#!/bin/bash
#FILE
#AUTHOR Randy Blancett
#AUTHOR_EMAIL Randy.Blancett@gmail.com
#VERSION 1.1.0
# This library handles command line options
#VERSIONS
#V 1.1.0
#RELEASE 11NOV2021
# Updated code to use ShellCheck suggested conventions
#
#V 1.0.0
#RELEASE 01NOV2021
# Handles ability to add command line arguments
# Adds ability to output Help Menu
#

if [[ " ${LOADED_LIB[*]} " != *" cmdOptions.sh "* ]]; then
    LOADED_LIB+=('cmdOptions.sh')

    #VARIABLE
    #PRIVATE
    #AUTHOR Randy Blancett
    # Holds a list of command line command help to look for
    COMMANDS_HELP=()

    #VARIABLE
    #PRIVATE
    # Holds a list of command line flags to look for
    FLAGS=()

    #VARIABLE
    #PRIVATE
    # Holds a list of command line options to look for
    LONG_ARGS=()

    #VARIABLE
    #PRIVATE
    # Holds the description of the application to output in help
    DESC="Default Description"

    #VARIABLE
    #PRIVATE
    # Holds an array of functions to use to parse command line data
    OPT_PARSERS=()

    #VARIABLE
    #PRIVATE
    # Holds an array of functions to use to validate input
    OPT_VALIDATORS=()

    CMD_GETOPT=getopt

    CMD_SORT="sort"

    #METHOD
    #PUBLIC
    # This Function will add an argument to look for on the command line
    #
    #PARAMETERS
    # $1 | Flag | This is the one character flag the parser will look for if there is no flag enter ""
    # $2 | Long Command | This is the multi-character flag it will look for if you do not want a long option pass ""
    # $3 | Has Arguments | if true the flag will look for data to be passed
    # $4 | Help | This is the help message that will be displayed for the option
    #
    #EXAMPLES
    # addCommandLineArg "h" "help" "false" "This will show the Help Menu."
    # addCommandLineArg "" "help" "false" "This will show the Help Menu."
    # addCommandLineArg "h" "" "false" "This will show the Help Menu."
    function addCommandLineArg() {
        if [ "$3" = true ]; then
            # shellcheck disable=SC2179
            [ -n "$1" ] && FLAGS+="$1:"
            # shellcheck disable=SC2179
            [ -n "$2" ] && LONG_ARGS+="$2:,"
        else
            # shellcheck disable=SC2179
            [ -n "$1" ] && FLAGS+="$1"
            # shellcheck disable=SC2179
            [ -n "$2" ] && LONG_ARGS+="$2,"
        fi
        COMMANDS_HELP+=("$1|$2|$4")
    }

    #METHOD
    #PUBLIC
    # This function will add a function to parse command options "Command" the name of the command to run (Needs to be Globaly Unique)
    #
    #PARAMETERS
    # $1 | Parser Command | This is the name of the function that will parse the command (Needs to be Globaly Unique)
    #
    #EXAMPLES
    # addCommandLineParser "ParserFunctionName"
    function addCommandLineParser() {
        OPT_PARSERS+=("$1")
    }

    #METHOD
    #PUBLIC
    # This will add a function used to validate options
    #
    #PARAMETERS
    # $1 | Validator Command | This is the name of the function that will parse the command (Needs to be Globaly Unique)
    #
    #EXAMPLES
    # addOptionValidator "ValidatorFunctionName"
    function addOptionValidator() {
        OPT_VALIDATORS+=("$1")
    }

    function getOptsFlag() {
        local OUTPUT
        for FLAG in "${COMMANDS[@]}"; do
            IFS='|' read -ra CMD <<<"$FLAG"
            OUTPUT+="${CMD[0]}"
            [ "${CMD[1]}" = true ] && OUTPUT+=":"
        done
        echo "$OUTPUT"
    }

    #METHOD
    #PRIVATE
    # This function will parse the command line options but should not be called directly
    #PARAMETERS
    # $1 | Command | This is the command that you would like to parse
    # $2 | Option | This is the option that was passed for the parameter if applicable
    function optParserCmdOptions() {
        case $1 in
        -h | --help)
            showCommandLineHelp
            exit 0
            ;;
        esac
    }

    #METHOD
    #PUBLIC
    # This function will parse the parameters passed in and call the parser functions
    #
    #EXAMPLES
    # parseCmdLine
    function parseCmdLine() {
        OPTS=$($CMD_GETOPT -o "${FLAGS[@]}" --long "${LONG_ARGS[@]}" -n 'parse-options' -- "$@") ||
            validateFail "There is a problem with the Commands you passed in"

        NO_FLAG=0

        eval set -- "$OPTS"

        while true; do
            if [ "$1" = "--" ]; then
                NO_FLAG=1
                shift
                continue
            fi
            if [ -z "$1" ]; then
                break
            fi
            for PARSER in "${OPT_PARSERS[@]}"; do
                if [ -n "$PARSER" ]; then
                    $PARSER "$1" "$2"
                fi
            done
            if [[ "$2" == *"-"* ]] || [ "$NO_FLAG" = "1" ]; then
                shift
            else
                shift
                shift
            fi
        done
    }

    #METHOD
    #PUBLIC
    # This function will set the description of the Script to be displayed in the help
    #
    #PARAMETERS
    # $1 | Description | This is description of the application
    #
    #EXAMPLES
    # setDescription "This is the description"
    function setDescription() {
        DESC=$1
    }

    #METHOD
    #PUBLIC
    # This function will set the usage to be displayed on the help menu
    #
    #PARAMETERS
    # $1 | Usage | The usage info for the application
    #
    #EXAMPLES
    # setUsage "USAGE [-l]"
    function setUsage() {
        USAGE=$1
    }

    #METHOD
    #PROTECTED
    # This function will sort the help command into all commands with one letter flag then multi letter flags in alphabetic order
    function organizeHelpCommands() {
        declare -A SHORT_FLAGS
        declare -A LONG_FLAGS
        for FLAG in "${COMMANDS_HELP[@]}"; do
            IFS='|' read -ra CMD <<<"$FLAG"
            if [ -n "${CMD[0]}" ]; then
                SHORT_FLAGS[${CMD[0]}]="$FLAG"
            else
                if [ -n "${CMD[1]}" ]; then
                    LONG_FLAGS[${CMD[1]}]="$FLAG"
                fi
            fi
        done
        COMMANDS_HELP=()

        mapfile -t SORTED_LONG_FLAGS < <(
            for KEY in "${!LONG_FLAGS[@]}"; do
                echo "$KEY"
            done | $CMD_SORT
        )

        for KEY in "${!SHORT_FLAGS[@]}"; do
            COMMANDS_HELP+=("${SHORT_FLAGS[$KEY]}")
        done

        for KEY in "${SORTED_LONG_FLAGS[@]}"; do
            COMMANDS_HELP+=("${LONG_FLAGS[$KEY]}")
        done
    }

    #METHOD
    #PROTECTED
    # This function will output the help menu, but should not be called directly
    function showCommandLineHelp() {
        organizeHelpCommands
        printf " %s\n" "$DESC"
        printf " Usage: %s\n" "$USAGE"
        printf " OPTIONS:\n"
        for FLAG in "${COMMANDS_HELP[@]}"; do
            local SHORT=""
            local LONG=""
            IFS='|' read -ra CMD <<<"$FLAG"
            if [ -n "${CMD[0]}" ]; then
                SHORT="-${CMD[0]}"
            fi
            if [ -n "${CMD[1]}" ]; then
                LONG="--${CMD[1]}"
            fi
            printf " %-3s %-25s %-50s\n" "${SHORT}" "${LONG}" "${CMD[2]}"
        done
    }

    #METHOD
    #PUBLIC
    # This method should be called from the validateOptions function if it does not pass
    #
    #EXAMPLES
    # validateFail
    #
    #PARAMETERS
    # $1 | Message | The exit message
    function validateFail() {
        echo "$1"
        showCommandLineHelp
        exit 1
    }

    #METHOD
    #PUBLIC
    # This function will run all the validation functions
    #
    #EXAMPLES
    # validateOptions
    function validateOptions() {
        for VALIDATOR in "${OPT_VALIDATORS[@]}"; do
            if [ -n "$VALIDATOR" ]; then
                $VALIDATOR
            fi
        done
    }

    ##############################################################
    # Library Setup                                              #
    ##############################################################

    addCommandLineArg "h" "help" false "Shows this help menu"
    addCommandLineParser "optParserCmdOptions"
fi
