#!/usr/bin/env bash

echo Running All Unit Tests
BATS_ASSERT_DIR="${bats.dir}/TestHelper/bats-assert"
BATS_SUPPORT_DIR="${bats.dir}/TestHelper/bats-support"
mkdir  -p "${bats.dir}"
tar --extract --directory "${bats.dir}" --wildcards --strip-components=1 --file "${project.basedir}/target/${bats.core.zip.name}" */libexec */lib */bin
mkdir -p "$BATS_ASSERT_DIR"
tar --extract --directory "$BATS_ASSERT_DIR" --wildcards --strip-components=1 --file "${project.basedir}/target/${bats.assert.zip.name}" */src */load.bash
mkdir -p "$BATS_SUPPORT_DIR"
tar --extract --directory "$BATS_SUPPORT_DIR" --wildcards --strip-components=1 --file "${project.basedir}/target/${bats.support.zip.name}" */src */load.bash
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
