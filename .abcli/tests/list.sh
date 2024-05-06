#! /usr/bin/env bash

function test_hubble_list() {
    local options=$1

    abcli_eval ,$options \
        hubble list datasets
    abcli_hr

    abcli_eval ,$options \
        hubble list datasets keyword=space
    abcli_hr

    local dataset
    local object
    for dataset in hst; do
        for object in "public/u4ge/u4ge0106r"; do
            abcli_log "testing dataset=$dataset, object=$object ..."

            hubble select dataset $dataset
            hubble select object $object

            abcli_eval ,$options \
                hubble list

            abcli_hr
            abcli_eval ,$options \
                hubble list dataset

            abcli_hr
            abcli_eval ,$options \
                hubble list object
        done
    done
}
