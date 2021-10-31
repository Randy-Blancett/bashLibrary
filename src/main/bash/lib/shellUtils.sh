#!/bin/bash
#FILE
#AUTHOR Randy Blancett
#AUTHOR_EMAIL Randy.Blancett@gmail.com
#VERSION 0.0.1
# This Library will add functions commonly used in shell scripts
#VERSIONS
#V 0.0.1
# ensureDir: ensure that a given directory exists (create if needed)
# copyDir: copy a directory to a new location
# copyFile: Copy a file to a new location
# ensureRoot: Ensure that running user is root
# askUser: Ask user for input

if [[ " ${LOADED_LIB[*]} " != *" shellUtils.sh "* ]]; then
    LOADED_LIB+=('shellUtils.sh')
    
    # Adds the base logging features
    source $LIB_PATH/colorLogging.sh
   
	#METHOD
	#PUBLIC
	# Check if a given directory exists, if not it will create it
	#
	#PARAMETERS
	# $1 | Directory | Directory to Check
	function ensureDir
	{
		log "Ensure that Directory $1 exists" $INFO $TEXT_GREEN
		[ ! -d "$1" ] && \
			log "$1 does not exist atempting to create." $DEBUG $TEXT_YELLOW && \
	  		mkdir -p "$1"
	}	
   
	#METHOD
	#PUBLIC
	# Copy a given directory to a new location
	#
	#PARAMETERS
	# $1 | Source | Directory to copy from
	# $2 | Destination | Directory to copy to
	function copyDir
	{
		log "Copying Directory [$1] to [$2]" $INFO $TEXT_GREEN
		[ ! -d "$1" ] && \
			log "$1 does not exist or is not a directory so we can not copy it." $ERROR $TEXT_RED && \
	  		return 1
	  	cp -r "$1" "$2"
	}
	
	#METHOD
	#PUBLIC
	# Copy a given directory to a new location
	#
	#PARAMETERS
	# $1 | Source | Directory to copy from
	# $2 | Destination | Directory to copy to
	function copyFile
	{
		log "Copying Directory [$1] to [$2]" $INFO $TEXT_GREEN
		[ ! -f "$1" ] && \
			log "$1 does not exist or is not a file so we can not copy it." $ERROR $TEXT_RED && \
	  		return 1
	  	cp "$1" "$2"
	}
	
	
	
	#METHOD
	#PUBLIC
	# Ask User for input
	#
	#PARAMETERS
	# $1 | Prompt | The prompt to place on the screen
	# $2 | Variable | The name of the variable to store the response
	function askUser
	{
		log "Asking the user [$1] and storeing it in [$2]" $INFO $TEXT_YELLOW
		read -p "$1: " "$2"
	}
		
	
	#METHOD
	#PUBLIC
	# Ensure user is root or exit program
	function ensureRoot
	{
		[ "$EUID" -ne 0 ] && \
		  log "This script requires root privleges please rerun as root" "$ERROR" "$TEXT_RED" && \
		  exit 1
	}
fi