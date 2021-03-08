#!/bin/bash
pacman -Sy
# use all possible cores for subsequent package builds
sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j$(nproc)",g' /etc/makepkg.conf
sed -i 's,!ccache,ccache,g' /etc/makepkg.conf
cp patch-for-spflashtool.patch Allow-Disable-MSR-Lockdown.patch remove-plus-char-from-localversion.patch PKGBUILD .config .SRCINFO linux-zen-wulan17.conf linux-zen-wulan17.install linux-zen-wulan17.preset /home/wulan17/
cp makepkg.conf /etc/
chmod 0644 /etc/makepkg.conf
chown -R wulan17 /home/wulan17
cd /home/wulan17
su wulan17 -c 'mkdir src'
su wulan17 -c 'mkdir src/build'
su wulan17 -c 'mkdir pkg'
su wulan17 -c 'cp .config src/build/'
export BUILD_START=$(date +"%s")
su wulan17 -c 'makepkg -s --noconfirm'
export BUILD_END=$(date +"%s")
su wulan17 -c "git clone https://wulan17:$token@github.com/wulan17/credentials.git -b up2 upload"
pacman --noconfirm -S python python-pip glibc 
su wulan17 -c 'pip install telethon tgcrypto'
su wulan17 -c 'pip install -r upload/requirements.txt'
export build_time=$((BUILD_END - BUILD_START))
su wulan17 -c 'bash upload/up.sh $(pwd)/linux-zen-git-5.11*.pkg.* $(pwd)/linux-zen-git-headers-5.11*.pkg.*'
