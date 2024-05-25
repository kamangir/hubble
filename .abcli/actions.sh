#! /usr/bin/env bash

function hubble_action_git_before_push() {
    hubble pypi build
}
