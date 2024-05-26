#! /usr/bin/env bash

function test_hubble_select_and_download() {
    local options=$1
    local do_dryrun=$(abcli_option_int "$options" dryrun 0)

    local dataset
    local object
    local filename=u4ge0106r_cgr.fits
    for dataset in hst; do
        for object in "public/u4ge/u4ge0106r"; do
            abcli_log "testing dataset=$dataset, object=$object ..."

            hubble select dataset $dataset
            hubble select object $object

            abcli_select
            abcli_eval ,$options \
                hubble download dryrun=$do_dryrun

            abcli_hr
            abcli_select
            abcli_eval ,$options \
                hubble download dryrun=$do_dryrun,filename=$filename
        done
    done
}
