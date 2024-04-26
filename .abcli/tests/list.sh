#! /usr/bin/env bash

function test_hubble_list() {
    local dataset
    local object
    for dataset in hst; do
        for object in "public/u4ge/u4ge0106r"; do
            test_internal_hubble_list \
                "dataset=$dataset,object=$object,$1" \
                "${@:2}"
        done
    done
}

function test_internal_hubble_list() {
    local options=$1
    local do_dryrun=$(abcli_option_int "$options" dryrun 0)

    local dataset=$(abcli_option "$options" dataset)
    local object=$(abcli_option "$options" object)

    hubble select dataset $dataset
    hubble select object $object

    abcli_eval $options, \
        hubble list

    abcli_hr
    abcli_eval $options, \
        hubble list dataset

    abcli_hr
    abcli_eval $options, \
        hubble list object
}
