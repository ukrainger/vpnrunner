#!/bin/bash

function osType {

    INSTALL_OS="unknown"

    case "$OSTYPE" in
        solaris*) INSTALL_OS="solaris" ;;
        darwin*)  INSTALL_OS="darwin" ;;
        linux*)   INSTALL_OS="linux" ;;
        bsd*)     INSTALL_OS="bsd" ;;
        msys*)    INSTALL_OS="windows" ;;
        cygwin*)  INSTALL_OS="windows" ;;
        *)        echo "unknown: $OSTYPE"; exit 1 ;;
    esac

    echo $INSTALL_OS;

}

function osArch {

    if [ -z "${OSARCH+x}" ];
    then
        OSARCH=$(uname -m);
    fi

    INSTALL_ARCH="unknown"
    case "$OSARCH" in
        x86_64*)  INSTALL_ARCH="x86_64" ;;
        amd64*)  INSTALL_ARCH="amd64" ;;
        i386*)    INSTALL_ARCH="386" ;;
        i686*)    INSTALL_ARCH="686" ;;
        armv6l)   INSTALL_ARCH="arm" ;;
        armv7l)   INSTALL_ARCH="arm" ;;
        arm*)     INSTALL_ARCH="arm64" ;;
        aarch64*) INSTALL_ARCH="aarch64" ;;
        *)        echo "unknown: $OSARCH"; exit 1 ;;
    esac

    echo $INSTALL_ARCH;

}

echo "OS type: $(osType)"
echo "OS Architecture: $(osArch)"
