#! /usr/bin/env bash

function hubble() {
    abcli_hubble "$@"
}

function abcli_hubble() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ]; then
        abcli_log "🔭 $(python3 -m hubble version --show_description 1)\n"

        abcli_hubble_download "$@"
        abcli_hubble_list "$@"
        abcli_hubble_select "$@"

        if [ "$(abcli_keyword_is $2 verbose)" == true ]; then
            python3 -m hubble --help
        fi
        return
    fi

    local function_name=abcli_hubble_$task
    if [[ $(type -t $function_name) == "function" ]]; then
        $function_name "${@:2}"
        return
    fi

    if [ "$task" == "init" ]; then
        abcli_init hubble "${@:2}"
        return
    fi

    python3 -m hubble \
        $task \
        "${@:2}"
}

function abcli_hubble_get() {
    python3 -m hubble get \
        --what "$1" \
        --dataset_name "$2" \
        --object_name "$3" \
        "${@:4}"
}
