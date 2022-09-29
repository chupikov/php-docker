#!/bin/bash
# 

SELF_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_DIR="$( dirname ${SELF_DIR} )"
ENV_FILE="${ROOT_DIR}/.env"

if [ ! -f ${ENV_FILE} ]
then
    echo -e "\033[31mFILE NOT EXISTS\033[0m: ${ENV_FILE}"
    exit
fi

set -a
source ${ENV_FILE}
set +a

docker $@ ${CONTAINER_NAME_APACHE}
