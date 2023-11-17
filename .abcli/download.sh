#! /usr/bin/env bash

function abcli_hubble_download() {
    local options=$1

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        local options="~dryrun,filename=<filename>|all,~ingest,upload"
        abcli_show_usage "hubble download$ABCUL[$options]$ABCUL[<hubble-object-name>]$ABCUL[<object-name>]" \
            "$abcli_hubble_dataset_object_name/<hubble-object-name> -> <object-name>."
        return
    fi

    local dataset_name=$abcli_hubble_dataset_object_name

    local filename=$(abcli_option "$options" filename all)
    local do_dryrun=$(abcli_option_int "$options" dryrun 1)
    local do_upload=$(abcli_option_int "$options" upload 0)
    local do_ingest=$(abcli_option_int "$options" ingest 1)

    local hubble_object_name=$(abcli_clarify_object "$2" . abcli_hubble_object)
    local object_name=$(abcli_clarify_object "$3" .)

    local auth=$(abcli_hubble_get auth $dataset_name)
    local s3_uri=$(abcli_hubble_get s3_uri $dataset_name $hubble_object_name)

    if [ "$filename" == all ]; then
        local command_line="aws s3 sync \
            $auth \
            $s3_uri \
            $abcli_object_root/$object_name/"
    else
        local command_line="aws s3 cp \
            $auth \
            $s3_uri$filename \
            $abcli_object_root/$object_name/"
    fi

    abcli_log "⚙️  $command_line"
    if [ "$do_dryrun" == 0 ]; then
        eval "$command_line"

        abcli_tag set \
            $object_name hubble \
            validate
        abcli_relation set \
            $object_name $hubble_object_name \
            is-download-of validate
    fi

    if [ "$do_ingest" == 1 ]; then
        python3 -m hubble ingest \
            --dataset_name $dataset_name \
            --hubble_object_name $hubble_object_name \
            --object_name $object_name
    fi

    [[ "$do_upload" == 1 ]] &&
        abcli_upload - $object_name
}
