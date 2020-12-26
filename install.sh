#!/bin/bash

QUAKE_INSTALL_PATH=~/.q3a/baseq3
QUAKE_PAK=~/.q3a/baseq3/pak0.pk3
VAILD_CHECKSUM=7ce8b3910620cd50a09e4f1100f426e8c6180f68895d589f80e6bd95af54bcae


if [[ "$*" == "" ]]; then
    echo "ERROR - no arguments provided."
    echo ""
    echo "Quake III Arena Client Installer."
    echo ""
    echo "Usage: ./install.sh {path to pak0.pk3 file on local system | url to pak0.pk3 file that will be downloaded} [OPTION]"
    echo ""
    echo "Options:"
    echo "--no-check-sum - ignore sha256 checksum check of the pak0.pk3 file"
    echo ""
    echo "Help:"
    echo "-h, --help     - display this message"
    echo ""
    echo "Email bug reports, questions, discussions to <hi@exesse.org>"
    exit 1
elif [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Quake III Arena Client Installer."
    echo ""
    echo "Usage: ./install.sh {path to pak0.pk3 file on local system | url to pak0.pk3 file that will be downloaded} [OPTION]"
    echo ""
    echo "Options:"
    echo "--no-check-sum - ignore sha256 checksum check of the pak0.pk3 file"
    echo ""
    echo "Help:"
    echo "-h, --help     - display this message"
    echo ""
    echo "Email bug reports, questions, discussions to <hi@exesse.org>"
    exit 1
else
    QUAKE_PAK_ARCHIVE=$1
    sudo apt update
    sudo apt install wget quake3 game-data-packager innoextract
    mkdir -p ${QUAKE_INSTALL_PATH}
    if [[ -f "$QUAKE_PAK_ARCHIVE" ]]; then
        if [[ "$2" == "" ]];then
            LOADED_FILE_HASH=($(sha256sum ${QUAKE_PAK_ARCHIVE}))
            if [[ "$LOADED_FILE_HASH" != "$VAILD_CHECKSUM" ]]; then
                echo "ERROR - checksums does not match."
                exit 1
            fi
        fi
        cp ${QUAKE_PAK_ARCHIVE} ${QUAKE_PAK}
    else
        wget -O ${QUAKE_PAK} ${QUAKE_PAK_ARCHIVE}
            if [[ -f "$QUAKE_PAK" ]]; then
                if [[ "$2" == "" ]];then
                    LOADED_FILE_HASH=($(sha256sum ${QUAKE_PAK}))
                        if [[ "$LOADED_FILE_HASH" != "$VAILD_CHECKSUM" ]]; then
                            echo "ERROR - checksums does not match."
                            exit 1
                        fi
                fi
                echo "$QUAKE_PAK was successfully downloaded."
            else
                echo "Was not able to get Quake III source package."
                exit 1
            fi
    fi
    game-data-packager -i quake3 ${QUAKE_PAK}
fi
