#!/bin/bash

NAME=ft_with_write_throttle

IODEPTH=64
FILESIZE="72G"
LOOPS=4

HOST_IP="10.20.91.101"
STORAGE_IP="10.20.91.103"

WORKING_DIR=`pwd`/${NAME}
[ ! -e ${WORKING_DIR} ] || rm -rf ${WORKING_DIR}
mkdir -p ${WORKING_DIR}

for BS in "4K" "16K" "64K" "512K" "1M"
do
	for DIRECT in 0
	do
		OUTPUT_DIR=`pwd`/${NAME}/${DIRECT}/${BS}

		[ ! -e ${OUTPUT_DIR} ] || rm -rf ${OUTPUT_DIR}
		mkdir -p ${OUTPUT_DIR}

		bash fio-run.sh --iodepth ${IODEPTH} --size ${FILESIZE} --blocksize ${BS} --direct ${DIRECT} --loops ${LOOPS} --host ${HOST_IP} --storage ${STORAGE_IP} --output ${OUTPUT_DIR} ${WORKING_DIR} fio-tests/*.fio
	done
done

rm -f ${WORKING_DIR}/testfile

