#! /usr/bin/env bash

function abcli_install_hubble() {
    # https://docs.astropy.org/en/stable/install.html
    pip3 install astropy[recommended]

    abcli_git clone git@github.com:awslabs/open-data-registry.git
}

abcli_install_module hubble 104
