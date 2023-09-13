#! /usr/bin/env bash

function abcli_install_blue_plugin() {
    # https://docs.astropy.org/en/stable/install.html
    pip3 install astropy[recommended]
}

abcli_install_module blue_plugin 102
