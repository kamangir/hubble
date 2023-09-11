#! /usr/bin/env bash

function hubble() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        abcli_log "🪐 $(python3 -m hubble version)\n"

        local options="~dryrun,filename=<filename>|all,upload"
        abcli_show_usage "hubble download$ABCUL[$options]$ABCUL[<hubble-object-name>]$ABCUL[<object-name>]" \
            "<hubble-object-name> -> <object-name>."

        abcli_show_usage "hubble list$ABCUL[<object-name>]" \
            "list hubble."
        abcli_show_usage "hubble select$ABCUL<object-name>" \
            "select a hubble object."

        if [ "$(abcli_keyword_is $2 verbose)" == true ] ; then
            python3 -m hubble --help
        fi

        abcli_log "\nexample object: public/u4ge/u4ge0106r/"
        return
    fi

    local function_name=hubble_$task
    if [[ $(type -t $function_name) == "function" ]] ; then
        $function_name "${@:2}"
        return
    fi

    if [ "$task" == download ] ; then
        local options=$2
        local filename=$(abcli_option "$options" filename all)
        local do_dryrun=$(abcli_option_int "$options" dryrun 1)
        local do_upload=$(abcli_option_int "$options" upload 0)

        local hubble_object_name=$(abcli_clarify_object "$3" . hubble)
        local object_name=$(abcli_clarify_object "$4" .)

        if [ "$filename" == all ] ; then
            local command_line="aws s3 sync --no-sign-request \
                s3://stpubdata/hst/$hubble_object_name \
                $abcli_object_root/$object_name/"
        else
            local command_line="aws s3 cp --no-sign-request \
                s3://stpubdata/hst/$hubble_object_name$filename \
                $abcli_object_root/$object_name/"
        fi

        abcli_log "⚙️  $command_line"
        if [ "$do_dryrun" == 0 ] ; then
            eval "$command_line"

            abcli_tag set \
                $object_name hubble \
                validate
            abcli_relation set \
                $object_name $hubble_object_name \
                is-download-of validate
        fi

        [[ "$do_upload" == 1 ]] && \
            abcli_upload - $object_name

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