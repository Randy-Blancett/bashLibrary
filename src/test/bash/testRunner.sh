#!/usr/bin/env bash

echo Running All Unit Tests
mkdir "${bats.dir}"
tar --extract --directory "${bats.dir}" --wildcards --strip-components=1 --file "${project.basedir}/target/${bats.zip.name}" */libexec */lib */bin
export LIB_PATH=${test.libDir}
for TEST in ./*.bats
do
	echo "*****************************************"
	echo "* Running Tests in $TEST"
	echo "*****************************************"
	${bats} $TEST
done
