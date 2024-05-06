#! /usr/bin/env bash
function abcli_hubble_ls() {
    abcli_hubble_list "$@"
}

function abcli_hubble_list() {
    local task=$1

    if [ "$task" == help ]; then
        abcli_show_usage "hubble list ${EOP}object$ABCUL.|<hubble-object-name>$EOPE" \
            "list <hubble-object-name> in $abcli_hubble_dataset_name, example in hst: public/u4ge/u4ge0106r."

        abcli_show_usage "hubble list dataset$ABCUL$EOP.|<hubble-dataset-name>$EOPE" \
            "list <hubble-dataset-name>, example: hst."
        return
    fi

    local thing_type=$1
    local thing_name=${2:-.}
    local args="${@:3}"

    if [[ -z "$thing_type" ]]; then
        local thing_type=object
        local thing_name=$abcli_hubble_object_name
        local args="${@:2}"
    elif [[ $(abcli_hubble_is_dataset $thing_type) == 1 ]]; then
        local thing_type=dataset
        local thing_name=${1:-.}
        local args="${@:2}"
    elif [[ "$thing_type" != dataset ]] && [[ "$thing_type" != object ]]; then
        local thing_type=object
        local thing_name=${1:-.}
        local args="${@:2}"
    fi

    local dataset_name=$abcli_hubble_dataset_name
    [[ "$thing_type" == dataset ]] &&
        local dataset_name=$(abcli_clarify_object "$thing_name" "" hubble_dataset)

    local object_name=""
    [[ "$thing_type" == object ]] &&
        local object_name=$(abcli_clarify_object "$thing_name" "" hubble_object)

    abcli_log "🔭 $dataset_name :: $object_name"

    local s3_uri=$(abcli_hubble_get s3_uri $dataset_name $object_name)
    abcli_log "🔗 $s3_uri"

    # https://registry.opendata.aws/hst/
    local command_line="aws s3 ls \
        $(abcli_hubble_get auth $dataset_name) \
        $s3_uri \
        $args"

    abcli_log "⚙️  $command_line"
    eval "$command_line"
}
