#! /usr/bin/env bash

function hubble() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        abcli_show_usage "hubble list" \
            "list hubble."

        # hubble_task $@

        if [ "$(abcli_keyword_is $2 verbose)" == true ] ; then
            python3 -m hubble --help
        fi
        return
    fi

    local function_name=hubble_$task
    if [[ $(type -t $function_name) == "function" ]] ; then
        $function_name "${@:2}"
        return
    fi

    if [[ ",list,ls," == *",$task,"* ]] ; then
        echo "wip"
        return
    fi

    python3 -m hubble \
        $task \
        ${@:2}
}