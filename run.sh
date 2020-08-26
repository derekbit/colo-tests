#!/bin/bash

IODEPTH=64
FILESIZE="72G"
BS="16K"

HOST_IP="10.20.91.101"
STORAGE_IP="10.20.91.103"
WORKING_DIR=`pwd`/working

[ ! -e ${WORKING_DIR} ] || rm -rf ${WORKING_DIR}
mkdir -p ${WORKING_DIR}

DIRECT=0

for DIRECT in 0 1
do
	bash run-tests.sh --iodepth ${IODEPTH} --size ${FILESIZE} --blocksize ${BS} --direct ${DIRECT} --host ${HOST_IP} --storage ${STORAGE_IP} ${WORKING_DIR} fio-tests/*.fio
done
