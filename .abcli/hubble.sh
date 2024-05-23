#! /usr/bin/env bash

function hubble() {
    abcli_hubble "$@"
}

function hubblescope() {
    abcli_hubble "$@"
}

function abcli_hubble() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ]; then
        abcli_hubble_download "$@"
        abcli_hubble_list "$@"
        abcli_hubble_select "$@"
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

    if [[ "|pylint|pytest|test|" == *"|$task|"* ]]; then
        abcli_${task} plugin=hubble,$2 \
            "${@:3}"
        return
    fi

    if [[ "|pypi|" == *"|$task|"* ]]; then
        abcli_${task} "$2" \
            plugin=hubble,$3 \
            "${@:4}"
        return
    fi

    python3 -m hubble "$@"
}

function abcli_hubble_get() {
    python3 -m hubble get \
        --what "$1" \
        --dataset_name "$2" \
        --object_name "$3" \
        "${@:4}"
}

abcli_source_path \
    $abcli_path_git/hubble/.abcli/tests
