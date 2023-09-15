#! /usr/bin/env bash

function abcli_install_blue_plugin() {
    # https://docs.astropy.org/en/stable/install.html
    pip3 install astropy[recommended]

    abcli_git clone git@github.com:awslabs/open-data-registry.git
}

abcli_install_module blue_plugin 103
