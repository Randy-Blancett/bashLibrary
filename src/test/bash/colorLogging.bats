setup() {
    load '../bats/TestHelper/bats-support/load'
    load '../bats/TestHelper/bats-assert/load'
	source "$LIB_PATH/colorLogging.sh"
}

@test "Test Log Levels" {
    VERBOSE=-2
    for LEVEL in $ERROR $STANDARD $INFO $DEBUG $TRACE $OMG
    do
        run log "$LEVEL" $LEVEL
        [ "$output" = "" ]
        VERBOSE=$LEVEL
        run log "$LEVEL" $LEVEL
        [ "$output" = "$LEVEL" ]
    done

    [ "$VERBOSE" = "$OMG" ]
    run log "ERROR" $ERROR
    [ "$output" = "ERROR" ]
    run log "STANDARD" $STANDARD
    [ "$output" = "STANDARD" ]
    run log "INFO" $INFO
    [ "$output" = "INFO" ]
    run log "DEBUG" $DEBUG
    [ "$output" = "DEBUG" ]
    run log "TRACE" $TRACE
    [ "$output" = "TRACE" ]
}

@test "Test Log Levels With Color" {
    VERBOSE=-2
    for LEVEL in $ERROR $STANDARD $INFO $DEBUG $TRACE $OMG
    do
        run log "$LEVEL" $LEVEL "$TEXT_GREEN"
        [ "$output" = "" ]
        VERBOSE=$LEVEL
        run log "$LEVEL" "$LEVEL" "$TEXT_RED"
        assert_output --partial "$LEVEL"
        assert_output --partial "0m"
    done

    [ "$VERBOSE" = "$OMG" ]
    run log "ERROR" $ERROR
    assert_output --partial "ERROR"
    run log "STANDARD" $STANDARD
    assert_output --partial "STANDARD"
    run log "INFO" $INFO
    assert_output --partial "INFO"
    run log "DEBUG" $DEBUG
    assert_output --partial "DEBUG"
    run log "TRACE" $TRACE
    assert_output --partial "TRACE"
}

@test "Test Log Levels With Color Disabled" {
    VERBOSE=-2
    ENABLE_COLOR=0
    for LEVEL in $ERROR $STANDARD $INFO $DEBUG $TRACE $OMG
    do
        run log "$LEVEL" $LEVEL "$TEXT_GREEN"
        [ "$output" = "" ]
        VERBOSE=$LEVEL
        run log "$LEVEL" "$LEVEL" "$TEXT_RED"
        assert_output "$LEVEL"
    done

    [ "$VERBOSE" = "$OMG" ]
    run log "ERROR" $ERROR
    assert_output  "ERROR"
    run log "STANDARD" $STANDARD
    assert_output "STANDARD"
    run log "INFO" $INFO
    assert_output  "INFO"
    run log "DEBUG" $DEBUG
    assert_output "DEBUG"
    run log "TRACE" $TRACE
    assert_output "TRACE"
}