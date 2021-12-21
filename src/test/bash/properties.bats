setup() {
	source "$LIB_PATH/properties.sh"
}

@test "Check Command Line Reader" {
	[ "info.prop" = "$PROPERTY_FILE" ]
	[ "." = "$PROPERTY_DIR" ]
	parseCmdLine --propertyFile propfile1 --propertyDir "dir1/dir2"	
	[ "propfile1" = "$PROPERTY_FILE" ]
	[ "dir1/dir2" = "$PROPERTY_DIR" ]
}

@test "Read Properties" {
	TMP_TEST_DIR=$(mktemp -d "/tmp/Properties.XXXXXXXXX")	
	parseCmdLine --propertyFile testPropFile.prop --propertyDir "$TMP_TEST_DIR"	
	
	echo "Prop1=Hello">$PROPERTY_DIR/$PROPERTY_FILE
	echo "Prop2=Goodbye">>$PROPERTY_DIR/$PROPERTY_FILE
	echo "Prop3">>$PROPERTY_DIR/$PROPERTY_FILE
	echo "Prop4=">>$PROPERTY_DIR/$PROPERTY_FILE
	echo "=Value">>$PROPERTY_DIR/$PROPERTY_FILE
		
	processProperties
	
	[ "Hello" = "$Prop1" ]
	[ "Goodbye" = "$Prop2" ]
	[ -z "$Prop3" ]
	[ -z "$Prop4" ]	
	
    rm -rf "$TMP_TEST_DIR"
    [ ! -e "$TMP_TEST_DIR" ]
	
}