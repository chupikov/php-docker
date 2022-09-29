#!/bin/bash
# Connect to PHP container

SELF_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_DIR="$(dirname ${SELF_DIR})"
ENV_FILE="${ROOT_DIR}/.env"

if [ ! -f "${ENV_FILE}" ]; then
  echo -e "\033[31;1;7m'.env' file not found!\033[0m"
  echo "First copy '.env.sample' to '.env' and fill with required values."
  echo
  exit 1
fi

set -a
source ${ENV_FILE}
set +a

docker exec -it ${CONTAINER_NAME_PHP} /bin/bash
