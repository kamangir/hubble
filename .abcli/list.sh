#! /usr/bin/env bash
function abcli_hubble_ls() {
    abcli_hubble_list "$@"
}

function abcli_hubble_list() {
    local task=$1

    if [ "$task" == help ]; then
        abcli_show_usage "hubble list$ABCUL[<dataset-name>|<object-name>]" \
            "list."
        return
    fi

    local dataset_name=$(abcli_clarify_object "$1" "" hubble_dataset)
    local object_name=""
    if [[ $(abcli_hubble_is_dataset $dataset_name) == 0 ]]; then
        local dataset_name=$abcli_hubble_dataset_object_name

        local object_name=$(abcli_clarify_object "$1" "" hubble_object)
    fi
    abcli_log "🔭 $dataset_name :: $object_name"

    local s3_uri=$(abcli_hubble_get s3_uri $dataset_name $object_name)
    abcli_log "🔗 $s3_uri"

    # https://registry.opendata.aws/hst/
    local command_line="aws s3 ls \
        $(abcli_hubble_get auth $dataset_name) \
        $s3_uri \
        ${@:2}"

    abcli_log "⚙️  $command_line"
    eval "$command_line"
}
