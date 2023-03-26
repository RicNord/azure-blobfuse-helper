#!/bin/bash

# Requirements blobfuse2, [dmenu]

# Fail on any non-zero exit code
set -eo pipefail

[[ "$USER" = "root" ]] || echo -e "EXIT: Run command as root \nsudo $0\n" && exit 1

# Default config
CONFIG_FILE="default.config.yaml"

function usage() {
    cat <<EOF
    Usage: $0 [ -c CONFIG_FILE ] [ -a ] [ ENV_FILE ]

    -c    path to configuration file
    -a    mount all containers in the storage account

EOF
    exit 1
}

# Parse args
while getopts ":ac:" opt; do
    case "${opt}" in
        a) MOUNT_ALL_CONTAINERS=true ;;
        c) CONFIG_FILE=$OPTARG ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

function set_mount_path() {
    if [[ $MOUNT_ALL_CONTAINERS = true ]]; then
        MOUNT_PATH=$AZURE_STORAGE_ACCOUNT
    else
        MOUNT_PATH=$AZURE_STORAGE_ACCOUNT/$AZURE_STORAGE_ACCOUNT_CONTAINER
    fi
}

# Check if env is set else pick from dmenu
if [[ "$1" == "" ]]; then
    BLOBFUSE_ENV=$(find ./ -maxdepth 1 -type f -name '[A-Za-z]*\.env' -printf "%P\n" \
        | sed 's/\.env$//' \
        | sort \
        | dmenu -l 10)
    source "./${BLOBFUSE_ENV}.env"

    set_mount_path
    echo ------ Mounting "$MOUNT_PATH"
else
    source ./"$1"
    set_mount_path
    echo ------ Mounting "$MOUNT_PATH"
fi

FULL_MOUNT_PATH=/mnt/$MOUNT_PATH
FULL_MOUNT_CACHE_PATH=/tmp/blobfuse/tempcache/$MOUNT_PATH
mkdir -p "$FULL_MOUNT_PATH"
mkdir -p "$FULL_MOUNT_CACHE_PATH"

# Define mount funcs
function mount_all() {
    blobfuse2 mount all \
        "$FULL_MOUNT_PATH" \
        --config-file=./"$CONFIG_FILE" \
        --tmp-path "$FULL_MOUNT_CACHE_PATH"
}

function mount_container() {
    blobfuse2 mount \
        "$FULL_MOUNT_PATH" \
        --config-file=./"$CONFIG_FILE" \
        --tmp-path "$FULL_MOUNT_CACHE_PATH"
}

# Main
if [[ $MOUNT_ALL_CONTAINERS = true ]]; then
    mount_all
else
    mount_container
fi
