#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >>feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small' >>feeds.conf.default

# fix yt8521
rm -rf ./target/linux/rockchip/patches-5.4/600-net-phy-Add-driver-for-Motorcomm-YT85xx-PHYs.patch
cp -f $GITHUB_WORKSPACE/patches/600-net-phy-Add-driver-for-Motorcomm-YT85xx-PHYs.patch target/linux/rockchip/patches-5.4/600-net-phy-Add-driver-for-Motorcomm-YT85xx-PHYs.patch

# Add extra wireless drivers
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06-k5.4/package/kernel/rtl8812au-ac
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06-k5.4/package/kernel/rtl8821cu
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06-k5.4/package/kernel/rtl8188eu
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06-k5.4/package/kernel/rtl8192du
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06-k5.4/package/kernel/rtl88x2bu


# Fix mt76 wireless driver
pushd package/kernel/mt76
sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
popd

# 更新固件信息
sed -i "s/by TSUIWAI /$(date +%Y.%m.%d) by TSUIWAI /g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/OpenWrt /$(date +%Y.%m.%d) by TSUIWAI /g" package/lean/default-settings/files/zzz-default-settings
