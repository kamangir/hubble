#! /usr/bin/env bash

function hubble_download() {
    local options=$1

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        local options="~dryrun,filename=<filename>|all,~ingest,upload,verbose"
        abcli_show_usage "hubble download$ABCUL[$options]$ABCUL[.|<hubble-object-name>]$ABCUL[.|<object-name>]" \
            "$abcli_hubble_dataset_name/<hubble-object-name> -> <object-name>."
        return
    fi

    local dataset_name=$abcli_hubble_dataset_name

    local filename=$(abcli_option "$options" filename all)
    local do_dryrun=$(abcli_option_int "$options" dryrun 1)
    local do_upload=$(abcli_option_int "$options" upload 0)
    local do_ingest=$(abcli_option_int "$options" ingest 1)
    local do_verbose=$(abcli_option_int "$options" verbose 0)

    local hubble_object_name=$(abcli_clarify_object "$2" . hubble_object)
    local object_name=$(abcli_clarify_object "$3" .)

    local auth=$(hubble_get auth $dataset_name)
    local s3_uri=$(hubble_get s3_uri $dataset_name $hubble_object_name)

    local command_line
    if [ "$filename" == all ]; then
        command_line="aws s3 sync \
            $auth \
            $s3_uri \
            $ABCLI_OBJECT_ROOT/$object_name/"
    else
        command_line="aws s3 cp \
            $auth \
            $s3_uri$filename \
            $ABCLI_OBJECT_ROOT/$object_name/"
    fi

    [[ "$do_verbose" == 0 ]] &&
        command_line="$command_line --only-show-errors"

    abcli_eval dryrun=$do_dryrun \
        "$command_line"

    [[ "$do_dryrun" == 0 ]] &&
        abcli_tags set \
            $object_name \
            hubble,is-download-of.$hubble_object_name

    [[ "$do_ingest" == 1 ]] &&
        abcli_eval dryrun=$do_dryrun \
            python3 -m hubblescope ingest \
            --dataset_name $dataset_name \
            --hubble_object_name $hubble_object_name \
            --object_name $object_name
    [[ $? -ne 0 ]] && return 1

    [[ "$do_upload" == 1 ]] &&
        abcli_upload - $object_name

    return 0
}
