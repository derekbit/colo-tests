#!/bin/bash

# Defaults
RAMP_TIME=30
RUNTIME=120
LOOPS=4
IODEPTH=64
SIZE="20G"
BLOCKSIZE="4K"
DIRECT=0

HOST_IP=0.0.0.0
STORAGE_IP=0.0.0.0

drop_cache()
{
    local IP=$1

    if [ -z "$IP" ]; then
        sync
        echo 3 > /proc/sys/vm/drop_caches
    else
        ssh root@$IP "sh -c \"sync; echo 3 > /proc/sys/vm/drop_caches\"";
    fi
}

print_info() {
    cat <<-FOE
    JOBNAME="$1"
    LOOP="$2"
    HOST_IP=${HOST_IP}
    STORAGE_IP=${STORAGE_IP}
    TEST_DIR=${TEST_DIR}
    RAMP_TIME=${RAMP_TIME}
    RUNTIME=${RUNTIME}
    LOOPS=${LOOPS}
    IODEPTH=${IODEPTH}
    SIZE=${SIZE}
    BLOCKSIZE=${BLOCKSIZE}
    DIRECT=${DIRECT}
FOE
}

run_test()
{
    local LOOP="$1"
    local JOB_FILE="$2"
    local BASENAME=$(basename ${JOB_FILE} | cut -f 1 -d '.')

    local OUTPUT="fio_ramptime_${RAMP_TIME}_runtime_${RUNTIME}_iodepth_${IODEPTH}_direct_${DIRECT}_bs_${BLOCKSIZE}_${BASENAME}.${LOOP}"

    fio --directory="$TEST_DIR" --ramp_time=$RAMP_TIME --runtime=$RUNTIME --iodepth=$IODEPTH --size="$SIZE" --direct=$DIRECT --blocksize="$BLOCKSIZE" --output "$TEST_DIR/$OUTPUT" --output-format json "$JOB_FILE"
}

usage()
{
    CMD=$1

    cat <<-FOE
Usage: $CMD: [OPTIONS] <test-directory> <fio-job> ....
Run fio tests
Options:
    -h | --help   Print help message
    --ramp_time   Time in seconds for ramp time. Default is 30 seconds.
    --runtime     Time in seconds for which each job should run. Default is 90 seconds.
    --loops       Number of times each job is run. Default is 3.
    --iodepth     Number of I/O units to keep in flight. Default is 64.
    --size        Total size of file. Default is 20G.
    --blocksize   Specify blocksize. Default is 4K.
    --direct      If set to 1, use non-buffered I/O. Default is 0.

    --host        Host IP.
    --storage     Storage IP.
FOE
}

# Main logic

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    usage
    exit 0
    ;;
    -r|--ramp_time)
    RAMP_TIME="$2"
    shift # past argument
    shift # past value
    ;;
    -t|--runtime)
    RUNTIME="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--loops)
    LOOPS="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--iodepth)
    IODEPTH="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--size)
    SIZE="$2"
    shift # past argument
    shift # past value
    ;;
    -b|--blocksize)
    BLOCKSIZE="$2"
    shift # past argument
    shift # past value
    ;;
    -t|--direct)
    DIRECT="$2"
    shift # past argument
    shift # past value
    ;;
    -i|--host)
    HOST_IP="$2"
    shift # past argument
    shift # past value
    ;;
    -g|--storage)
    STORAGE_IP="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

TEST_DIR="$1"

shift 1

JOB_FILES="$@"

for jobname in $JOB_FILES;do
    for i in `seq 1 $LOOPS`;do
        echo ">>>>>>>>>> $jobname #$i <<<<<<<<<<"
        print_info "$jobname" "$i"
        drop_cache
        drop_cache ${HOST_IP}
	drop_cache ${STORAGE_IP}

        run_test "$i" "$jobname"
    done
done
