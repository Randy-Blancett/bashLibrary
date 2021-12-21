#!/bin/bash
#FILE
#AUTHOR Randy Blancett
#AUTHOR_EMAIL Randy.Blancett@gmail.com
#VERSION 1.0.0
# This Library adds the ability to load variables from a file on disk
#VERSIONS
#V 1.0.0
#RELEASE ???
# Initial Release


if [[ " ${LOADED_LIB[*]} " != *" properties.sh "* ]]; then
    LOADED_LIB+=('properties.sh')
    
    [[ "${BASH_SOURCE[0]}" == "${0}" ]] && LIB_PATH="$( dirname "$0" )" && LIB_PATH=$(readlink -e "$LIB_PATH")
    
    # Allow the library to parse command line options
    source "$LIB_PATH/cmdOptions.sh"
    # Adds the base logging features
	source "$LIB_PATH/colorLogging.sh"
	
	#VARIABLE
    #PROTECTED
    # File that stores the property information
    PROPERTY_FILE="info.prop"
    
    #VARIABLE
    #PROTECTED
    # Directory where property file is stored
    PROPERTY_DIR="."
    
    #METHOD
    #PRIVATE
    # this will parse command line options for this library
    #
    #PARAMETERS
    # $1 | option | The option to parse
    # $2 | data | The Data passed with the option | optional
    function optParserProperties() {
        case $1 in
        --propertyFile)
            PROPERTY_FILE=$2
            ;;
        --propertyDir)
            PROPERTY_DIR=$2
            ;;
        esac
    }
    
    #METHOD
    #PUBLIC
    # This will process the properties in a given file
    function processProperties(){
    	log "Loading Properties from $PROPERTY_DIR/$PROPERTY_FILE" "$INFO" "$TEXT_GREEN"
    	while IFS= read -r LINE || [[ -n "$LINE" ]]
    	do 
    		log "Processing: [$LINE]" "$DEBUG" "$TEXT_YELLOW"    		
			local DATA_SPLIT			
 			readarray -t -d "=" DATA_SPLIT <<<"$LINE"
 			if [ -z "${DATA_SPLIT[0]}" ] || [ -z "${DATA_SPLIT[1]}" ]
 			then
 				log "Failed to process Line [$LINE]" "$ERROR" "$TEXT_RED" 
 			 	continue
 			else 	
 			 	eval "${DATA_SPLIT[0]}"="${DATA_SPLIT[1]}"		
 			fi
    	done < "$PROPERTY_DIR/$PROPERTY_FILE"
    }
	
	##############################################################
    # Library Setup                                              #
    ##############################################################
    addVar2Dump "PROPERTY_FILE"
    addVar2Dump "PROPERTY_DIR"

    addCommandLineArg "" "propertyFile" true "The name of the property file to load. Default: $PROPERTY_FILE"
    addCommandLineArg "" "propertyDir" true "Set the Directory where property files can be found. Default: $PROPERTY_DIR"

    addCommandLineParser "optParserProperties"
    
    ##############################################################
    # Testing Process                                            #
    ##############################################################
    
    if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
    then
     log "${BASH_SOURCE[0]} is being run directly, this is only intened for Testing" "$STANDARD" "$TEXT_BLUE"
     parseCmdLine "$@"
	 varDump "$DEBUG"
	 processProperties;
    fi
    
fi