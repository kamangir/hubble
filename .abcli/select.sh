#! /usr/bin/env bash

[[ -z "$abcli_hubble_dataset_object_name" ]] && export abcli_hubble_dataset_object_name=hst

function abcli_hubble_select() {
    local object_name=$1

    if [ "$object_name" == help ]; then
        abcli_show_usage "hubble select$ABCUL<dataset-name>" \
            "select <dataset-name>, example: hst."
        abcli_show_usage "hubble select$ABCUL<object-name>" \
            "select <object-name> in $abcli_hubble_dataset_object_name, example in hst: public/u4ge/u4ge0106r."
        return
    fi

    if [ -z "$object_name" ]; then
        abcli_log_error "-hubble: select: object-name not found."
        return 1
    fi

    local object_type=abcli_hubble_object
    if [[ $(abcli_hubble_is_dataset $object_name) == 1 ]]; then
        local object_type=abcli_hubble_dataset

        abcli_log "🔗 https://registry.opendata.aws/$object_name/"
        abcli_log "🔗 https://github.com/awslabs/open-data-registry/blob/main/datasets/$object_name.yaml"
        abcli_log_file $(abcli_hubble_dataset_metadata $object_name)
    fi

    abcli_select \
        $object_name \
        $(abcli_option_update "$3" plugin $object_type) \
        "${@:4}"
}

function abcli_hubble_dataset_metadata() {
    echo $abcli_path_git/open-data-registry/datasets/$1.yaml
}

function abcli_hubble_is_dataset() {
    if [[ -f $(abcli_hubble_dataset_metadata $1) ]]; then
        echo 1
        return
    fi

    echo 0
}
