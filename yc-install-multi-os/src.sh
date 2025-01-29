#!/bin/bash

#
# This script installs Yandex.Cloud CLI application to your machine.
# Installation script is based on type of yours OS
#
# USAGE: bash <path_to_this_script>
#
# UNDO: remove yc application via yours package manager
#

get_distro_str()
{
    if command -v yum &>/dev/null
    then
        echo "redhat"
        return 0
    elif command -v apt-get &>/dev/null
    then
        echo "debian"
        return 0
    fi
    
    return 1
}

install_linux()
{
    distro=$(get_distro_str)
    
    if [[ $? -ne 0 ]]
    then
        echo "Failed to determine Linux distr. Installation is cancelled"
        exit 1
    fi
    
    if [[ "$distro" == "redhat" ]]
    then
        sudo yum install -y bash-completion
    fi
    
    basic_install_yc
}

install_windows()
{
    if [[ ! ("$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32") ]]
    then
        return 1
    fi
    
    if ! powershell.exe -ExecutionPolicy Bypass -File "./src.ps1";
    then
        return 1
    fi
}

basic_install_yc() {
    curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
}

if yc version &>/dev/null;
then
    echo "Yandex.Cloud CLI is already installed"
    echo "No need to install. Goodbye"
    exit 0
fi

install()
{
    os=$(uname)
    
    case "$os" in
        Linux)
            install_linux
        ;;
        Darwin) # macOS
            basic_install_yc
        ;;
        *)
            if ! install_windows
            then
                echo "Failed to install Ynadex.Cloud CLI for Windows: $os"
                return 0
            fi
            
            echo "Unsupported Operation System: $os"
            return 1
        ;;
    esac
}

if ! install && yc version &>/dev/null
then
    echo "Yandex.Cloud CLI successfully installed"
    echo "Have a nice day"
else
    echo "Yandex.Cloud CLI didn't installed"
    echo "Please check requirements"
    exit 1
fi
