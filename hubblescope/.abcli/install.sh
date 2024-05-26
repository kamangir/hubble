#! /usr/bin/env bash

function abcli_install_open_data_registry() {
    abcli_git clone https://github.com/awslabs/open-data-registry.git
}

abcli_install_module open_data_registry 3.1.1
