#!/bin/bash
#FILE
#AUTHOR Randy Blancett
#AUTHOR_EMAIL Randy.Blancett@gmail.com
#VERSION 1.1.0
# This Library will add functions commonly used in shell scripts
#VERSIONS
#V 1.3.0
# Added function to select how to install a system package
#VERSIONS
#V 1.2.0
#RELEASE 15JUN2023
# Added Ability to check if username exists
# Added Ability to check if Group Exists
# Added Ability to check for root with out exiting program
# Added ability to have a default value when asking a user for input
# Added Ability to check if a given group exists
# Added Ability to ensure that a given group exists
# Added Ability to Check if a user is a member of a given group
# Added Ability to Ensure user is a member of a given Group
#
#V 1.1.0
#RELEASE 11NOV2021
# Updated code to use ShellCheck suggested conventions
#
#V 1.0.0
#RELEASE 01NOV2021
# ensureDir: ensure that a given directory exists (create if needed)
# copyDir: copy a directory to a new location
# copyFile: Copy a file to a new location
# ensureRoot: Ensure that running user is root
# askUser: Ask user for input

if [[ " ${LOADED_LIB[*]} " != *" shellUtils.sh "* ]]; then
	LOADED_LIB+=('shellUtils.sh')

	# Adds the base logging features
	source "$LIB_PATH/colorLogging.sh"

	#METHOD
	#PUBLIC
	# Check if a given directory exists, if not it will create it
	#
	#PARAMETERS
	# $1 | Directory | Directory to Check
	function ensureDir {
		log "Ensure that Directory $1 exists" "$INFO" "$TEXT_GREEN"
		[ ! -d "$1" ] &&
			log "$1 does not exist atempting to create." "$DEBUG" "$TEXT_YELLOW" &&
			mkdir -p "$1"
	}

	#METHOD
	#PUBLIC
	# Copy a given directory to a new location
	#
	#PARAMETERS
	# $1 | Source | Directory to copy from
	# $2 | Destination | Directory to copy to
	#
	#EXIT_CODES
	# 0 | Executed successfully
	# 1 | The input directory does not exist
	function copyDir {
		log "Copying Directory [$1] to [$2]" "$INFO" "$TEXT_GREEN"
		[ ! -d "$1" ] &&
			log "$1 does not exist or is not a directory so we can not copy it." "$ERROR" "$TEXT_RED" &&
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
	#
	#EXIT_CODES
	# 0 | Executed successfully
	# 1 | The input file does not exist
	function copyFile {
		log "Copying Directory [$1] to [$2]" "$INFO" "$TEXT_GREEN"
		[ ! -f "$1" ] &&
			log "$1 does not exist or is not a file so we can not copy it." "$ERROR" "$TEXT_RED" &&
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
	# $3 | Default | The default response if none is provided | optional
	function askUser {
		local PROMPT
		if [ -z "$3" ]; then
			PROMPT="$1"
		else
			PROMPT="$1 [$3]"
		fi
		
		log "Asking the user [$PROMPT] and storing it in [$2]" "$INFO" "$TEXT_YELLOW"
		local RESPONSE
		read -r -p "$PROMPT: " "RESPONSE"
		printf -v "$2" '%s' "${RESPONSE:-$3}"
	}

	#METHOD
	#PUBLIC
	# Ask User for secret input this will not show what the user is typeing
	#
	#PARAMETERS
	# $1 | Prompt | The prompt to place on the screen
	# $2 | Variable | The name of the variable to store the response
	function askUserSecret {
		local PROMPT
		PROMPT="$1"
		
		log "Asking the user [$PROMPT] as a secret and storing it in [$2]" "$INFO" "$TEXT_YELLOW"
		local RESPONSE
		read -s -r -p "$PROMPT: " "RESPONSE"
		printf -v "$2" '%s' "${RESPONSE:-$3}"
	}

	#METHOD
	#PUBLIC
	# Check if user Exists
	#
	#PARAMETERS
	# $1 | Username | The Name of the user to check
	#
	#EXIT_CODES
	# 0 | User Exists
	# 1 | User does not Exist
	function userExists {
		log "Check if $1 exists" "$DEBUG" 
		id "$1" &>/dev/null && return 0 || return 1
	}

	#METHOD
	#PUBLIC
	# Install a system Package depending on what package manager is available
	#
	#PARAMETERS
	# $1 | Package | Name of the package to install
	#
	#EXIT_CODES
	# 0 | Install ran
	# 1 | Unable to find package manager
	function installPackage {
		local PACKAGE=${1}
		log "Atempting to install ${PACKAGE}" "$INFO" 

		if command -v apt-get >/dev/null; then
			log " - Using apt for install" "$DEBUG" 
			apt install "${PACKAGE}"
		elif command -v dnf >/dev/null; then
			log " - Using dnf for install" "$DEBUG" 
			dnf install "${PACKAGE}"
		elif command -v yum >/dev/null; then
			log " - Using yum for install" "$DEBUG" 
			yum install "${PACKAGE}"
		else
			log " - Using apt for install" "$ERROR" 
			return 1
		fi
		return 0
	}

	#METHOD
	#PUBLIC
	# Check if a Group Exists on the machine
	#
	#PARAMETERS
	# $1 | Group | The Name of the group to check
	#
	#EXIT_CODES
	# 0 | Group Exists
	# 1 | Group does not Exist
	function groupExists {
		log "Check if $1 exists" "$DEBUG" 
		getent group "$1" &>/dev/null && return 0 ||return 1 
	}

	#METHOD
	#PUBLIC
	# Ensure the given Group exists
	#
	#PARAMETERS
	# $1 | Group | The Name of the group to check
	function ensureGroup {
		log "Ensureing $1 Exists" "$DEBUG" 
		# shellcheck disable=SC2015
		groupExists "$1" && 
		    log "$1 Exists" "${TRACE}" || \
			( log "$1 Does not Exist trying to create it." "${TRACE}" && \
			groupadd "$1" )
	}

	#METHOD
	#PUBLIC
	# Make sure a given user exists and is a member of group.
	# This makes sure user exists if not it will create it.
	# This makes suer Group exists if not it will create it.
	#
	#PARAMETERS
	# $1 | Username | The name of the user to add to the group.
	# $2 | Group | The name of the group to add to the user to.
	function ensureUserInGroup {
		log "Ensure $1 is a member of group $2" "$DEBUG" 
		ensureGroup "$2"
		ensureUser "$1"
		if userInGroup "$1" "$2"
		then
			log "$1 is a member of Group $2" "$TRACE" 
		else
			usermod -a -G "$2" "$1"
		fi
	}

	#METHOD
	#PUBLIC
	# Check if a user is a member of the given group
	#
	#PARAMETERS
	# $1 | Username | The name of the user to add to the group.
	# $2 | Group | The name of the group to add to the user to.
	#
	#EXIT_CODES
	# 0 | User is a member of a given group.
	# 1 | User is not a member of a given group.
	function userInGroup {
		log "Checking if $1 is a member of group $2" "$DEBUG" 
		if userExists "$1"
		then
			log "$1 is a valid User" "$DEBUG" 
		else
			log "$1 is not a valid User" "$DEBUG" 
			return 1
		fi
		if id -nGz "$1" | grep -qzxF "$2"
		then
			log "$1 is a member of group $2" "$DEBUG" 
			return 0
		else
			log "$1 is not a member of group $2" "$DEBUG" 
			return 1
		fi
	}

	#METHOD
	#PUBLIC
	# Ensure the given user exists
	#
	#PARAMETERS
	# $1 | Username | The Name of the user to check
	function ensureUser {
		log "Ensureing $1 Exists" "$DEBUG" 
		# shellcheck disable=SC2015
		userExists "$1" && 
		    log "$1 Exists" "${TRACE}" ||
			( log "$1 Does not Exist trying to create it." "${TRACE}" &&
			useradd "$1" )
	}

	#METHOD
	#PUBLIC
	# Ensure user is root or exit program
	#
	#EXIT_CODES
	# 0 | User Has Root Privileges
	# 1 | User does not have root privileges
	function ensureRoot {
		if ! isRoot 
		then
			log "This script requires root privleges please rerun as root" "$ERROR" "$TEXT_RED"
			exit 1
		fi
	}

	#METHOD
	#PUBLIC
	# Check if user is root
	#
	#RETURN
	# 0 | User Has Root Privileges
	# 1 | User does not have root privileges
	function isRoot {
		[ "$EUID" -ne 0 ] && return 1 || return 0
	}


fi
