#!/bin/bash
# Creates required directories if not exist


SELF_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_DIR="$(dirname ${SELF_DIR})"
ENV_FILE="${ROOT_DIR}/.env"

if [ ! -f "${ENV_FILE}" ]; then
  echo -e "\033[31;1;7m'.env' file not found!\033[0m"
  echo "First copy '.env.sample' to '.env' and fill with required values."
  echo
  exit 1
fi


source "${ENV_FILE}"

DATA_DIR="${ROOT_DIR}/${PROJECT_DIR}/docker/database"


# Directories to create

directories=(
  "${ROOT_DIR}/logs"
  "${DATA_DIR}"
  "${DATA_DIR}/data-mysql"
  "${DATA_DIR}/data-mariadb"
)


# Root directories where need to create files from samples

roots=(
  "${ROOT_DIR}/${WEB_ROOT_DIR}"
  "${ROOT_DIR}/${PROJECT_DIR}/apache"
  "${ROOT_DIR}/${PROJECT_DIR}/php"
)



sys=$(uname)

if [[ $sys =~ [Ll]inux ]] || [[ $sys =~ [Dd]arwin ]]; then
  IS_NIX=true
else
  IS_NIX=false
fi


echo "User directory: `pwd`"
echo "Self directory: ${SELF_DIR}"
echo "Root directory: ${ROOT_DIR}"
echo


for dir in "${directories[@]}"; do
  if [ ! -d "${dir}" ]; then
    echo "Create directory: '${dir}'..."
    mkdir "${dir}"
  else
    echo "Directory already exists: '${dir}'"
  fi
  if [ $IS_NIX = true ]; then
    sudo chown -R :www-data "${dir}"
    sudo find "${dir}" -type f -exec chmod 664 {} \;
    sudo find "${dir}" -type d -exec chmod 775 {} \;
  fi
done
echo


for dir in "${roots[@]}"; do
  echo "Search samples in the directory: ${dir}"

  command eval 'samples=($(find ${WEB_ROOT_DIR} -type f -name "*.sample"))'

  for sample in "${samples[@]}"; do

    [[ ${sample} =~ \.env\.sample ]] && continue

    file=`echo ${sample} | sed -e "s/\.sample$//"`

    if [ ! -f "$file" ]
    then
      echo "Copy ${sample} --> ${file}"
      cp "${sample}" "${file}"
    else
      echo "File exists: ${file}"
    fi
  done
done
