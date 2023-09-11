#! /usr/bin/env bash

function hubble() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        abcli_log "🪐 $(python3 -m hubble version)\n"

        abcli_show_usage "hubble list [<object-name>]" \
            "list hubble."
        abcli_show_usage "hubble select <object-name>" \
            "select a hubble object."

        if [ "$(abcli_keyword_is $2 verbose)" == true ] ; then
            python3 -m hubble --help
        fi

        abcli_log "\nexample object: public/u4ge/u4ge0106r"
        return
    fi

    local function_name=hubble_$task
    if [[ $(type -t $function_name) == "function" ]] ; then
        $function_name "${@:2}"
        return
    fi

    if [[ ",list,ls," == *",$task,"* ]] ; then
        local object_name=$(abcli_clarify_object "$2" "" hubble)
        local s3_uri=s3://stpubdata/hst/$object_name
        abcli_log "🔗 $s3_uri"

        # https://registry.opendata.aws/hst/
        aws s3 ls \
            --no-sign-request \
            $s3_uri \
            "${@:3}"
        return
    fi

    if [ "$task" == select ] ; then
        local object_name=$2
        if [ -z "$object_name" ] ; then
            abcli_log_error "-hubble: select: object-name not found."
            return 1
        fi

        abcli_select \
            $object_name \
            $(abcli_option_update "$3" plugin hubble) \
            "${@:4}"
        return
    fi

    python3 -m hubble \
        $task \
        ${@:2}
}