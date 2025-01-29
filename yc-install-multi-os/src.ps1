#
# This script is a part of main script src.sh that handles setup Yandex.Cloud for Windows
#

Invoke-WebRequest -Uri "https://storage.yandexcloud.net/yandexcloud-yc/install.ps1" -OutFile "install.ps1"
.\install.ps1
