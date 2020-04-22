#!/bin/bash
# Creates required directories if not exist


PROJ_DIR="etc"
SELF_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_DIR="$(dirname ${SELF_DIR})"
LOGS_DIR="${ROOT_DIR}/logs"
MSQL_DIR="${ROOT_DIR}/${PROJ_DIR}/docker/mysql"
DATA_DIR="${MSQL_DIR}/data"

echo "User directory: `pwd`"
echo "Self directory: ${SELF_DIR}"
echo "Root directory: ${ROOT_DIR}"

if [ ! -d $LOGS_DIR ]
then
    echo "Create $LOGS_DIR..."
    mkdir $LOGS_DIR
else
    echo "Directory exists: $LOGS_DIR..."
fi

if [ ! -d $MSQL_DIR ]
then
    echo "Create $MSQL_DIR..."
    mkdir $MSQL_DIR
else
    echo "Directory exists: $MSQL_DIR..."
fi

if [ ! -d $DATA_DIR ]
then
    echo "Create $DATA_DIR..."
    mkdir $DATA_DIR
else
    echo "Directory exists: $DATA_DIR..."
fi

