#!/bin/bash

set -ex
set -o pipefail

go_to_build_dir() {
    if [ ! -z $INPUT_SUBDIR ]; then
        cd $INPUT_SUBDIR
    fi
}

check_if_setup_file_exists() {
    if [ ! -f setup.py ]; then
        echo "setup.py must exist in the directory that is being packaged and published."
        exit 1
    fi
}

check_if_meta_yaml_file_exists() {
    if [ ! -f meta.yaml ]; then
        echo "meta.yaml must exist in the directory that is being packaged and published."
        exit 1
    fi
}

upload_and_build_package(){
    anaconda login --username $INPUT_ANACONDAUSERNAME --password $INPUT_ANACONDAPASSWORD
    conda build -c defaults -c tsdst --output-folder . .
    conda convert -p osx-64 linux-64/*.tar.bz2
    conda convert -p win-64 linux-64/*.tar.bz2
    anaconda upload --label main linux-64/*.tar.bz2
    anaconda upload --label main win-64/*.tar.bz2
    anaconda upload --label main osx-64/*.tar.bz2
    anaconda logout
}

check_if_setup_file_exists
go_to_build_dir
check_if_meta_yaml_file_exists
upload_and_build_package
