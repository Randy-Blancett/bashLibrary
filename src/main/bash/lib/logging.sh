#!/bin/bash
#FILE
#AUTHOR Randy Blancett
#AUTHOR_EMAIL Randy.Blancett@gmail.com
#VERSION 1.0.0
# This library handles Logging of data
#VERSIONS
#V 1.0.0
#RELEASE 01NOV2021
# Initial Release

if [[ " ${LOADED_LIB[*]} " != *" logging.sh "* ]]; then
    LOADED_LIB+=('logging.sh')
    
    # Allow the library to parse command line options
    source $LIB_PATH/cmdOptions.sh
    
    #VARIABLE
    #PROTECTED
    #GROUP logging 
    # This variable holds how verbose the logging will be
    VERBOSE=0
    
    #VARIABLE
    #PROTECTED
    #GROUP logging
    # This variable turns on/off file logging 1 = on 0 = off
    LOG2FILE=0
    
    #VARIABLE
    #PROTECTED
    #GROUP logging
    # Directory where the log will be stored
    LOG_DIR=/var/log/bash_lib
    
    #CONSTANT
    #PUBLIC
    #GROUP Log Level
    # This is used to filter Logging this is used for Errors
    ERROR=-1
    
    #CONSTANT
    #PUBLIC
    #GROUP Log Level
    # This is used to filter Logging this is used for Regular Information
    STANDARD=0
    
    #CONSTANT
    #PUBLIC
    #GROUP Log Level
    # This is used to filter Logging this is used for more detailed information
    INFO=1
    
    #CONSTANT
    #PUBLIC
    #GROUP Log Level
    # This is used to filter Logging this is used for Debug Information
    DEBUG=2
    
    #CONSTANT
    #PUBLIC
    #GROUP Log Level
    # This is used to filter Logging this is used for Traceing Path through the Program.
    TRACE=3
    
    #CONSTANT
    #PUBLIC
    #GROUP Log Level
    # This is used to filter Logging this is used for Minute detail that most users will not want
    OMG=4
        
    #VARIABLE
    #PRIVATE
    #GROUP logging
    # Holds names of variables to have their values dumped
    VAR_NAMES=()
    
    ##############################################################
    # Library Functions                                          #
    ##############################################################
    
	#METHOD
    #PUBLIC
    # Add the name of the variable to dump
    #
    #PARAMETERS
    # $1 | Variable Name | Name of the variable to dump (no dollarsign)
    #
    #EXAMPLES
    # addVar2Dump var2dump
    function addVar2Dump()
    {
    	VAR_NAMES+=("$1")
    }
    
	#METHOD
    #PUBLIC
    # Dump the variables added via addVar2Dump and dump loaded Libraries
    #
    #PARAMETERS
    # $1 | Log Level | The Level to log this data
    #
    #EXAMPLES
    # varDump $INFO
    function varDump()
    {
    	if [ $1 -le $VERBOSE ]
    	then
	    	libDump $1
	    	
	    	SORTED_VAR_NAMES=( $(
	    		for KEY in "${VAR_NAMES[@]}"
	    		do
	    			echo "$KEY"
	    		done | $CMD_SORT)    	)
	    		
			for VAR in "${SORTED_VAR_NAMES[@]}"
			do
				if [ -n "$VAR" ]
				then
					log "$(printf " %-30s %-55s \n" "$VAR:" "${!VAR}")" $1
				fi
			done
		fi
    }
    
	#METHOD
    #PUBLIC
    # Show the libraries loaded
    #
    #PARAMETERS
    # $1 | Log Level | The Level to log this data
    #
    #EXAMPLES
    # libDump $INFO
    function libDump()
    {
    	if [ $1 -le $VERBOSE ]
    	then
    		for LIB in "${LOADED_LIB[@]}"
    		do 
    			log "Loaded Library [$LIB]" $1 
    		done
    	fi    
    }
     
	#METHOD
    #PRIVATE
    # this will parse command line options for this library
    #
    #PARAMETERS
    # $1 | option | The option to parse
    # $2 | data | The Data passed with the option | optional
    function optParserLogging()
    {
    	case $1 in 
    		-v | --verbose)
    			VERBOSE=$2
    			;;
    		--logFileDir)
    			LOG_DIR=$2
    			;;
			--logFile)
				LOG_FILE=$2
				;;
			--log2File)
				LOG2FILE=1
				;;
		esac    			
    }
    
	#METHOD
    #PUBLIC
    # Log information to the screen if it is Equal to or less than the current verbosity level.
    #
    #PARAMETERS
    # $1 | Message | Message to display
    # $2 | Log Level | The Level of this message
    #
    #EXAMPLES
    # log "This Message" $STANDARD
    function log()
    {
    	if [ $2 -le $VERBOSE ]
    	then
    		echo -e "$1"
    		if [ "$LOG2FILE" = "1" ]
    		then
    			echo -e "$1" >> "${LOG_DIR}/${LOG_FILE}"
    		fi
    	fi    
    }
    
    ##############################################################
    # Library Setup                                              #
    ##############################################################    
    addVar2Dump "LOG_DIR"
    addVar2Dump "LOG_FILE"
    addVar2Dump "LOG2FILE"
    addVar2Dump "VERBOSE"
    
    addCommandLineArg "v" "verbose" true "Set the level of Logging ($STANDARD = STANDARD the higher the number the more data is output)"
    addCommandLineArg "" "logFileDir" true "Set the Directory where log files are stored. Default: $LOG_DIR"
    addCommandLineArg "" "logFile" true "Set the File where data is logged to. Default: $LOG_FILE"
    addCommandLineArg "" "log2File" false "If this flag is set data will be logged to a file"
    
    addCommandLineParser "optParserLogging"
fi