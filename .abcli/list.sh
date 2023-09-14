#! /usr/bin/env bash
function abcli_hubble_ls() {
    abcli_hubble_list "$@"
}

function abcli_hubble_list() {
    local task=$1

    if [ "$task" == help ]; then
        abcli_show_usage "hubble list$ABCUL[<object-name>]" \
            "list hubble."
        return
    fi

    local object_name=$(abcli_clarify_object "$1" "" hubble)
    local s3_uri=s3://stpubdata/hst/$object_name
    abcli_log "🔗 $s3_uri"

    # https://registry.opendata.aws/hst/
    aws s3 ls \
        --no-sign-request \
        $s3_uri \
        "${@:2}"
}
