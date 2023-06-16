#!/usr/bin/env bash

echo Running All Unit Tests
mkdir "${bats.dir}"
tar --extract --directory "${bats.dir}" --wildcards --strip-components=1 --file "${project.basedir}/target/${bats.zip.name}" */libexec */lib */bin
export LIB_PATH=${test.libDir}
EXIT_CODE=0;
for TEST in ./*.bats
do
	echo "*****************************************"
	echo "* Running Tests in $TEST"
	echo "*****************************************"
	${bats} $TEST
    [[ "$?" > "0" ]] && EXIT_CODE=1;
	echo status: $?
done
exit $EXIT_CODE
