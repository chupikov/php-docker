#!/bin/bash

SELF_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_DIR="$(dirname ${SELF_DIR})"

echo "User directory: `pwd`"
echo "Self directory: ${SELF_DIR}"
echo "Root directory: ${ROOT_DIR}"

