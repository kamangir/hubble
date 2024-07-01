#! /usr/bin/env bash

function hubble() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ]; then
        hubble_download "$@"
        hubble_list "$@"
        hubble_select "$@"
        return
    fi

    abcli_generic_task \
        plugin=hubble,task=$task \
        "${@:2}"
}

abcli_log $(hubble version --show_icon 1)
