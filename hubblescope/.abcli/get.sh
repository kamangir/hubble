#! /usr/bin/env bash

function hubble_get() {
    python3 -m hubblescope get \
        --what "$1" \
        --dataset_name "$2" \
        --object_name "$3" \
        "${@:4}"
}
