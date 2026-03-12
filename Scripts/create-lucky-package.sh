#!/bin/bash
# Scripts/create-lucky-package.sh
set -e

cd ./wrt/package/

PKG_DIR="my-lucky"
mkdir -p "$PKG_DIR"

# 创建 Makefile（修正 PKG_BUILD_DIR）
cat > "$PKG_DIR/Makefile" << 'EOF'
include $(TOPDIR)/rules.mk

PKG_NAME:=my-lucky
PKG_VERSION:=20260312
PKG_RELEASE:=1

# 不要将 PKG_BUILD_DIR 设为 /dev/null，使用默认值即可
# PKG_BUILD_DIR := /dev/null

include $(INCLUDE_DIR)/package.mk

define Package/my-lucky
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Custom lucky binary
  DEPENDS:=
  PKGARCH:=all
endef

define Package/my-lucky/description
  This package provides a pre-built lucky binary.
  It will override the version from luci-app-lucky.
endef

# 所有构建步骤都定义为空
define Build/Prepare
	@true
endef

define Build/Configure
	@true
endef

define Build/Compile
	@true
endef

define Package/my-lucky/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/lucky $(1)/usr/bin/
endef

$(eval $(call BuildPackage,my-lucky))
EOF

# 下载 lucky 并放入 files 目录
mkdir -p "$PKG_DIR/files/usr/bin"
LUCKY_URL="http://alistlc.v6.army:13666/d/guset/open/lucky?sign=SiEmUmzQb_m9833knrv72EvyvQ3sEQmil0Hr-zfI92M=:0"
curl -L --retry 3 --progress-bar -o "$PKG_DIR/files/usr/bin/lucky" "$LUCKY_URL"
chmod 755 "$PKG_DIR/files/usr/bin/lucky"

echo "✅ 自定义 lucky 包创建成功"
cd ../../
