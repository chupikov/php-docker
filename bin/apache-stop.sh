#!/bin/bash

SELF_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
${SELF_DIR}/apache.sh stop
