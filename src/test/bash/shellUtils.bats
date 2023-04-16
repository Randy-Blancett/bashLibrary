setup() {
	TMP_TEST_DIR=$(mktemp -d "/tmp/ShellUtils.XXXXXXXXX")
	source "$LIB_PATH/shellUtils.sh"
}

teardown() {
    rm -rf "$TMP_TEST_DIR"
    [ ! -e "$TMP_TEST_DIR" ]
}

@test "ensureDir" {
    [ ! -e "$TMP_TEST_DIR/dir1" ]
    ensureDir "$TMP_TEST_DIR/dir1"
    [ -d "$TMP_TEST_DIR/dir1" ]
}

@test "copyDir Success" {
    ensureDir "$TMP_TEST_DIR/dir1"
    touch "$TMP_TEST_DIR/dir1/file1.txt"
    
    copyDir "$TMP_TEST_DIR/dir1" "$TMP_TEST_DIR/dir2"    
    [ -d "$TMP_TEST_DIR/dir2" ]  
    [ -f "$TMP_TEST_DIR/dir2/file1.txt" ]
}

@test "copyDir No Source" {
     run -1 copyDir "$TMP_TEST_DIR/dir1" "$TMP_TEST_DIR/dir2"    
    [ ! -d "$TMP_TEST_DIR/dir2" ]  
}

@test "userExists" {
    userExists "NoGoodUser" && data=1 || data=0
    [ "$data" = "0" ]   

    userExists "$USER" && data=1 || data=0
    [ "$data" = "1" ]   
}

@test "askUser" {
    local USER_INPUT=""
    askUser "testPrompt" "USER_INPUT" <<< "hello"
    [ "$USER_INPUT" = "hello" ]
    USER_INPUT=""
    askUser "testPrompt" "USER_INPUT" "GoodBye" <<< ""
    [ "$USER_INPUT" = "GoodBye" ]
}

@test "groupExists" {
    run groupExists noGroup
    [ "$status" = "1" ] 
    [ "$output" = "" ] 
    run groupExists root
    [ "$status" = "0" ] 
    [ "$output" = "" ] 
}

@test "User in Group" {
    run userInGroup root root
    [ "$status" = "0" ] 
    [ "$output" = "" ] 
    run userInGroup root "NotaGroup"
    [ "$status" = "1" ] 
    [ "$output" = "" ] 
    run userInGroup "Notauser" root
    [ "$status" = "1" ] 
    echo $output
    [ "$output" = "" ] 
}

@test "Ensure User In Group" {
    run ensureUserInGroup root root
    [ "$status" = "0" ] 
    [ "$output" = "" ] 
}