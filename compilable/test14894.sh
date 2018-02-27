#!/usr/bin/env bash

dir=${RESULTS_DIR}/compilable
src=compilable/extra-files

$DMD -c -m${MODEL} -of${dir}/${TEST_NAME}a${OBJ} -I${src} ${src}/${TEST_NAME}a.d || exit 1

$DMD -unittest -m${MODEL} -od${dir} -I${src} ${src}/${TEST_NAME}main.d ${dir}/${TEST_NAME}a${OBJ} || exit 1

rm -f ${dir}/{${TEST_NAME}a${OBJ} ${TEST_NAME}main${EXE} ${TEST_NAME}main${OBJ}}

echo Success
