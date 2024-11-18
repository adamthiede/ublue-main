#!/usr/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
KERNEL_SUFFIX=""
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"

#curl -Lo /etc/yum.repos.d/_copr_ublue-os_staging.repo https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-"${RELEASE}"/ublue-os-staging-fedora-"${RELEASE}".repo
#curl -Lo /etc/yum.repos.d/_copr_kylegospo_oversteer.repo https://copr.fedorainfracloud.org/coprs/kylegospo/oversteer/repo/fedora-"${RELEASE}"/kylegospo-oversteer-fedora-"${RELEASE}".repo

rpm-ostree install \
    fedora-repos-archive

# use negativo17 for 3rd party packages with higher priority than default
curl -Lo /etc/yum.repos.d/negativo17-fedora-multimedia.repo https://negativo17.org/repos/fedora-multimedia.repo
sed -i '0,/enabled=1/{s/enabled=1/enabled=1\npriority=90/}' /etc/yum.repos.d/negativo17-fedora-multimedia.repo

# use override to replace mesa and others with less crippled versions
rpm-ostree override replace \
  --experimental \
  --from repo='fedora-multimedia' \
    libheif \
    libva \
    libva-intel-media-driver \
    mesa-dri-drivers \
    mesa-filesystem \
    mesa-libEGL \
    mesa-libGL \
    mesa-libgbm \
    mesa-libglapi \
    mesa-libxatracker \
    mesa-va-drivers \
    mesa-vulkan-drivers

if [[ "$FEDORA_MAJOR_VERSION" -ne "41" ]]; then
    rpm-ostree override replace \
        --experimental \
        --from repo='fedora-multimedia' \
        libvdpau
fi

# run common packages script
/ctx/packages.sh
/ctx/my.sh

## install packages direct from github
/ctx/github-release-install.sh sigstore/cosign x86_64

# use CoreOS' generator for emergency/rescue boot
# see detail: https://github.com/ublue-os/main/issues/653
CSFG=/usr/lib/systemd/system-generators/coreos-sulogin-force-generator
curl -sSLo ${CSFG} https://raw.githubusercontent.com/coreos/fedora-coreos-config/refs/heads/stable/overlay.d/05core/usr/lib/systemd/system-generators/coreos-sulogin-force-generator
chmod +x ${CSFG}

if [[ "${KERNEL_VERSION}" == "${QUALIFIED_KERNEL}" ]]; then
    /ctx/initramfs.sh
fi
