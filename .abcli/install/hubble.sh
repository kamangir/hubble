#! /usr/bin/env bash

function abcli_install_hubble() {
    abcli_git clone https://github.com/awslabs/open-data-registry.git
}

abcli_install_module hubble 104
