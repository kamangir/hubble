#! /usr/bin/env bash

function hubble_action_git_before_push() {
    [[ "$(abcli_git get_branch)" == "main" ]] &&
        hubble pypi build
}
