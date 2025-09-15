#!/bin/bash
DEST_IP="$1"
DEBUG_PORT="$2"
SRC_DIR="$3"
BINARY="$4"
DEST_DIR="$5"
BINARY_LIB="$6"
DEST_DIR_LIB="$7"
USER="$8"
PASS="$9"
BINARY_ARG="$10"

# kill gdbserver on target and delete old binary, if directory .ssh contains file config, then command sshpass is not needed.
#sshpass -p ${PASS} ssh ${USER}@${DEST_IP} "sh -c 'pkill -f gdbserver; rm -rf ${DEST_DIR}/${BINARY} || exit 0'"
ssh ${USER}@${DEST_IP} "sh -c 'pkill -f gdbserver; rm -rf ${DEST_DIR}/${BINARY} || exit 0'"

# send binary to target
#sshpass -p ${PASS} scp ${SRC_DIR}/${BINARY} ${USER}@${DEST_IP}:${DEST_DIR}/${BINARY}
scp ${SRC_DIR}/${BINARY} ${USER}@${DEST_IP}:${DEST_DIR}/${BINARY}
scp ${SRC_DIR}/${BINARY_LIB} ${USER}@${DEST_IP}:${DEST_DIR_LIB}/${BINARY_LIB}

# start gdbserver on target
#sshpass -p ${PASS} ssh -t ${USER}@${DEST_IP} "sh -c 'cd ${DEST_DIR}; gdbserver ${DEST_IP}:${DEBUG_PORT} ${BINARY}'"
# If you need to run the binary with root privileges, instead of above line you can uncomment the alternative command:
# sshpass -p ${PASS} ssh -t ${USER}@${DEST_IP} "cd "$DEST_DIR"; echo "$PASS" | sudo -S gdbserver localhost:$DEBUG_PORT $BINARY"
ssh -t ${USER}@${DEST_IP} "sh -c 'cd ${DEST_DIR}; gdbserver ${DEST_IP}:${DEBUG_PORT} ${BINARY} ${BINARY_ARG}'"