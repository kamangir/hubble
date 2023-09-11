#! /usr/bin/env bash

function hubble() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        abcli_log "🪐 $(python3 -m hubble version)\n"

        abcli_show_usage "hubble list [<suffix>]" \
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
        local s3_uri=s3://stpubdata/hst/$2
        abcli_log "🔗 $s3_uri"

        # https://registry.opendata.aws/hst/
        aws s3 ls \
            --no-sign-request \
            $s3_uri \
            "${@:3}"
        return
    fi

    python3 -m hubble \
        $task \
        ${@:2}
}