#!/bin/bash

IODEPTH=64
FILESIZE="72G"

HOST_IP="10.20.91.101"
STORAGE_IP="10.20.91.103"

NAME=ft

mkdir $NAME

for BS in "4K" "16K" "64K"
do
	for DIRECT in 0 1
	do
		WORKING_DIR=`pwd`/${NAME}/${DIRECT}/${BS}

		[ ! -e ${WORKING_DIR} ] || rm -rf ${WORKING_DIR}
		mkdir -p ${WORKING_DIR}

		bash run-tests.sh --iodepth ${IODEPTH} --size ${FILESIZE} --blocksize ${BS} --direct ${DIRECT} --host ${HOST_IP} --storage ${STORAGE_IP} ${WORKING_DIR} fio-tests/*.fio
		[ ! -e ${WORKING_DIR}/testfile ] || rm -f ${WORKING_DIR}/testfile
	done
done
