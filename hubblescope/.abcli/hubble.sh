#! /usr/bin/env bash

function abcli_hubble() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ]; then
        abcli_hubble_download "$@"
        abcli_hubble_list "$@"
        abcli_hubble_select "$@"
        return
    fi

    abcli_generic_task \
        plugin=hubble,task=$task \
        "${@:2}"
}
