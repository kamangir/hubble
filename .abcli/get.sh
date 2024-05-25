#! /usr/bin/env bash

function abcli_hubble_get() {
    python3 -m hubble get \
        --what "$1" \
        --dataset_name "$2" \
        --object_name "$3" \
        "${@:4}"
}
