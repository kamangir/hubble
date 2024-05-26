#! /usr/bin/env bash
function hubble_ls() {
    hubble_list "$@"
}

function hubble_list() {
    local task=$1

    if [ "$task" == help ]; then
        abcli_show_usage "hubble list dataset$ABCUL$EOP.|<hubble-dataset-name>$ABCUL<suffix>$EOPE" \
            "list <hubble-dataset-name>/<suffix>, example: hst."

        local options="keyword=<keyword>"
        abcli_show_usage "hubble list datasets$ABCUL$EOP$options$EOPE" \
            "list hubble datasets."

        abcli_show_usage "hubble list ${EOP}object$ABCUL.|<hubble-object-name>$ABCUL<suffix>$EOPE" \
            "list <hubble-object-name> in $abcli_hubble_dataset_name, example in hst: public/u4ge/u4ge0106r."
        return
    fi

    local thing_type=$1
    local thing_name=${2:-.}
    local suffix="${@:3}"

    if [[ "$thing_type" == datasets ]]; then
        local options=$2
        local keyword=$(abcli_option "$options" keyword)

        local path=$abcli_path_git/open-data-registry/datasets
        if [[ -z "$keyword" ]]; then
            abcli_list "$path"
        else
            grep -r "$keyword" "$path"
        fi
        return 0
    fi

    if [[ -z "$thing_type" ]]; then
        thing_type=object
        thing_name=$abcli_hubble_object_name
        suffix="${@:2}"
    elif [[ $(hubble_is_dataset $thing_type) == 1 ]]; then
        thing_type=dataset
        thing_name=${1:-.}
        suffix="${@:2}"
    elif [[ "$thing_type" != dataset ]] && [[ "$thing_type" != object ]]; then
        thing_type=object
        thing_name=${1:-.}
        suffix="${@:2}"
    fi

    local dataset_name=$abcli_hubble_dataset_name
    [[ "$thing_type" == dataset ]] &&
        dataset_name=$(abcli_clarify_object "$thing_name" "" hubble_dataset)

    local object_name=""
    [[ "$thing_type" == object ]] &&
        object_name=$(abcli_clarify_object "$thing_name" "" hubble_object)

    abcli_log "🔭 $dataset_name :: $object_name"

    local s3_uri=$(hubble_get s3_uri $dataset_name $object_name)
    [[ ! -z "$suffix" ]] && s3_uri=$s3_uri$suffix
    abcli_log "🔗 $s3_uri"

    # https://registry.opendata.aws/hst/
    abcli_eval - \
        "aws s3 ls \
        $(hubble_get auth $dataset_name) \
        $s3_uri"
}
