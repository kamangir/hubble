#! /usr/bin/env bash

function test_hubble_is_dataset() {
    local options=$1
    local do_dryrun=$(abcli_option_int "$options" dryrun 0)

    abcli_assert \
        $(hubble_is_dataset hst) \
        1

    abcli_assert \
        $(hubble_is_dataset nst) \
        0

    abcli_assert \
        $(hubble_is_dataset shopping-humor-generation) \
        1
}
