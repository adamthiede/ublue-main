#!/bin/bash

set -ouex pipefail

if [[ "$IMAGE_NAME" == "base" ]]; then
    systemctl enable getty@tty1
fi

systemctl enable rpm-ostreed-automatic.timer
#systemctl enable flatpak-system-update.timer

#systemctl --global enable flatpak-user-update.timer

ln -s "/usr/share/fonts/google-noto-sans-cjk-fonts" "/usr/share/fonts/noto-cjk"

