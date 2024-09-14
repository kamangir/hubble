#! /usr/bin/env bash

[[ -z "$abcli_hubble_dataset_name" ]] && export abcli_hubble_dataset_name=hst

function hubble_select() {
    if [ "$1" == help ]; then
        abcli_show_usage "hubble select [dataset] <hubble-dataset-name>" \
            "select <hubble-dataset-name>, example: hst."
        abcli_show_usage "hubble select [object] <hubble-object-name>" \
            "select <hubble-object-name> in $abcli_hubble_dataset_name, example in hst: public/u4ge/u4ge0106r."
        return
    fi

    local thing_type=$1
    local thing_name=$2
    local args="${@:3}"

    if [[ -z "$thing_type" ]]; then
        abcli_log_error "-hubble: select: <object-name> not found."
        return 1
    elif [[ $(hubble_is_dataset $thing_type) == 1 ]]; then
        local thing_type=dataset
        local thing_name=$1
        local args="${@:2}"
    elif [[ "$thing_type" != dataset ]] && [[ "$thing_type" != object ]]; then
        local thing_type=object
        local thing_name=$1
        local args="${@:2}"
    fi

    if [[ "$thing_type" == dataset ]]; then
        [[ $thing_name == *.yaml ]] &&
            thing_name=${thing_name%.yaml}

        abcli_log "🔭 dataset :: $thing_name"

        abcli_log "🔗 https://registry.opendata.aws/$thing_name/"
        abcli_log "🔗 https://github.com/awslabs/open-data-registry/blob/main/datasets/$thing_name.yaml"
        abcli_cat $(hubble_dataset_metadata $thing_name)
    else
        abcli_log "🔭 $abcli_hubble_dataset_name :: $thing_name"

    fi

    abcli_select \
        $thing_name \
        $3,type=hubble_${thing_type} \
        "$args"
}

function hubble_dataset_metadata() {
    echo $abcli_path_git/open-data-registry/datasets/$1.yaml
}

function hubble_is_dataset() {
    if [[ -f $(hubble_dataset_metadata $1) ]]; then
        echo 1
        return
    fi

    echo 0
}
