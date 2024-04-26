#! /usr/bin/env bash

function test_hubble_select_and_download() {
    local dataset
    local object
    for dataset in hst; do
        for object in "public/u4ge/u4ge0106r"; do
            test_internal_hubble_select_and_download \
                "dataset=$dataset,object=$object,filename=u4ge0106r_cgr.fits,$1" \
                "${@:2}"
        done
    done
}

function test_internal_hubble_select_and_download() {
    local options=$1
    local do_dryrun=$(abcli_option_int "$options" dryrun 0)

    local dataset=$(abcli_option "$options" dataset)
    local object=$(abcli_option "$options" object)
    local filename=$(abcli_option "$options" filename)

    hubble select dataset $dataset
    hubble select object $object

    abcli_select
    abcli_eval $options, \
        hubble download dryrun=$do_dryrun

    abcli_hr
    abcli_select
    abcli_eval $options, \
        hubble download dryrun=$do_dryrun,filename=$filename
}
