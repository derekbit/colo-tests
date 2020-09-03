#!/bin/bash

IODEPTH=64
FILESIZE="72G"
BS="16K"

HOST_IP="10.20.91.101"
STORAGE_IP="10.20.91.103"
WORKING_DIR=`pwd`/working
OUTPUT_DIR=`pwd`/working

[ ! -e ${WORKING_DIR} ] || rm -rf ${WORKING_DIR}
mkdir -p ${WORKING_DIR}

[ ! -e ${OUTPUT_DIR} ] || rm -rf ${OUTPUT_DIR}
mkdir -p ${OUTPUT_DIR}


DIRECT=0

for DIRECT in 0 1
do
	bash fio-run.sh --iodepth ${IODEPTH} --size ${FILESIZE} --blocksize ${BS} --direct ${DIRECT} --host ${HOST_IP} --storage ${STORAGE_IP} --output ${OUTPUT_DIR} ${WORKING_DIR} fio-tests/*.fio
done
