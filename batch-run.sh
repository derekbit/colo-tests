#!/bin/bash

NAME=ft

IODEPTH=64
FILESIZE="24G"
LOOPS=3

WORKING_DIR=`pwd`/${NAME}
[ ! -e ${WORKING_DIR} ] || rm -rf ${WORKING_DIR}
mkdir -p ${WORKING_DIR}

for DIRECT in 0 1
do
	for BS in "4K" "16K" "32K" "64K" "512K" "1M"
	do
		OUTPUT_DIR=`pwd`/${NAME}/${DIRECT}/${BS}

		[ ! -e ${OUTPUT_DIR} ] || rm -rf ${OUTPUT_DIR}
		mkdir -p ${OUTPUT_DIR}

		bash fio-run.sh --iodepth ${IODEPTH} --size ${FILESIZE} --blocksize ${BS} --direct ${DIRECT} --loops ${LOOPS} --output ${OUTPUT_DIR} ${WORKING_DIR} fio-tests/*.fio
	done
done

rm -f ${WORKING_DIR}/testfile
