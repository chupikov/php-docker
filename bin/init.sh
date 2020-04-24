#!/bin/bash
# Creates required directories if not exist


PROJ_DIR="etc"
SELF_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_DIR="$(dirname ${SELF_DIR})"
LOGS_DIR="${ROOT_DIR}/logs"
DATA_DIR="${ROOT_DIR}/${PROJ_DIR}/docker/database"
MYSQL_DIR="${MSQL_DIR}/data-mysql"
MARIA_DIR="${MSQL_DIR}/data-mariadb"

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

if [ ! -d $DATA_DIR ]
then
    echo "Create $DATA_DIR..."
    mkdir $DATA_DIR
else
    echo "Directory exists: $DATA_DIR..."
fi

if [ ! -d $MYSQL_DIR ]
then
    echo "Create $MYSQL_DIR..."
    mkdir $MYSQL_DIR
else
    echo "Directory exists: $MYSQL_DIR..."
fi

if [ ! -d $MARIA_DIR ]
then
    echo "Create $MARIA_DIR..."
    mkdir $MARIA_DIR
else
    echo "Directory exists: $MARIA_DIR..."
fi

