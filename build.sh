#!/bin/bash
pacman -Syu
pacman -S --noconfirm --needed base-devel git curl wget ccache xmlto kmod inetutils bc libelf git cpio perl tar xz zstd python python-pip pahole
# use all possible cores for subsequent package builds
sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j$(nproc)",g' /etc/makepkg.conf
sed -i 's,!ccache,ccache,g' /etc/makepkg.conf
useradd --create-home wulan17
usermod --append --groups wheel wulan17
echo "wulan17 ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers
cp 5.10.9.patch allow-disable-msr-lockdown.patch warn-when-having-multiple-ids-for-single-type.patch PKGBUILD .config .SRCINFO  linux-zen-wulan17.conf linux-zen-wulan17.install linux-zen-wulan17.preset /home/wulan17/
chown -R wulan17 /home/wulan17
cd /home/wulan17
su wulan17 -c 'mkdir src'
su wulan17 -c 'mkdir src/build'
su wulan17 -c 'mkdir pkg'
su wulan17 -c 'cp .config src/build/'
su wulan17 -c 'makepkg'
ls -lah
su wulan17 -c "git clone https://wulan17:$token@github.com/wulan17/credentials.git -b up upload" 
su wulan17 -c 'pip install telethon tgcrypto'
su wulan17 -c 'pip install -r upload/requirements.txt'
su wulan17 -c 'bash upload/up.sh $(pwd)/linux-zen-git-5.10*.pkg.*'
su wulan17 -c 'bash upload/up.sh $(pwd)/linux-zen-git-headers-5.10*.pkg.*'
