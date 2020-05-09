################################################################################
#
# mupen64plus video gles2rice
#
################################################################################
ifeq ($(BR2_PACKAGE_RECALBOX_TARGETGROUP_ROCKCHIP),y)
MUPEN64PLUS_GLES2RICE_VERSION = cc26180a209e62cec4870e51ebb005e1d39106bf
MUPEN64PLUS_GLES2RICE_SITE = $(call github,mupen64plus,mupen64plus-video-rice,$(MUPEN64PLUS_GLES2RICE_VERSION))
else
MUPEN64PLUS_GLES2RICE_VERSION = 03189cb54a5b8f19d0680715f05e1bd76e9149ab
MUPEN64PLUS_GLES2RICE_SITE = $(call github,ricrpi,mupen64plus-video-gles2rice,$(MUPEN64PLUS_GLES2RICE_VERSION))
endif
MUPEN64PLUS_GLES2RICE_LICENSE = MIT
MUPEN64PLUS_GLES2RICE_DEPENDENCIES = sdl2 alsa-lib mupen64plus-core
MUPEN64PLUS_GLES2RICE_INSTALL_STAGING = YES

define MUPEN64PLUS_GLES2RICE_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/projects/unix/Makefile
	CFLAGS="$(MUPEN64PLUS_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(MUPEN64PLUS_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" RANLIB="$(TARGET_RANLIB)" AR="$(TARGET_AR)" CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
			PREFIX="$(STAGING_DIR)/usr" \
			SHAREDIR="/recalbox/share/system/configs/mupen64/" \
			PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
			HOST_CPU="$(MUPEN64PLUS_CORE_HOST_CPU)" \
			APIDIR="$(STAGING_DIR)/usr/include/mupen64plus" \
			GL_CFLAGS="$(MUPEN64PLUS_CORE_GL_CFLAGS)" \
			GL_LDLIBS="$(MUPEN64PLUS_CORE_GL_LDLIBS)" \
			-C $(@D)/projects/unix all $(MUPEN64PLUS_CORE_PARAMS) OPTFLAGS="$(MUPEN64PLUS_CXXFLAGS)"
endef

define MUPEN64PLUS_GLES2RICE_INSTALL_TARGET_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/projects/unix/Makefile
	CFLAGS="$(MUPEN64PLUS_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(MUPEN64PLUS_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" RANLIB="$(TARGET_RANLIB)" AR="$(TARGET_AR)" CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
			PREFIX="$(TARGET_DIR)/usr/" \
			SHAREDIR="$(TARGET_DIR)/recalbox/share_init/system/configs/mupen64/" \
			PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
			HOST_CPU="$(MUPEN64PLUS_CORE_HOST_CPU)" \
			APIDIR="$(STAGING_DIR)/usr/include/mupen64plus" \
			GL_CFLAGS="$(MUPEN64PLUS_CORE_GL_CFLAGS)" \
			GL_LDLIBS="$(MUPEN64PLUS_CORE_GL_LDLIBS)" \
			INSTALL="/usr/bin/install" \
			INSTALL_STRIP_FLAG="" \
			-C $(@D)/projects/unix all $(MUPEN64PLUS_CORE_PARAMS) OPTFLAGS="$(MUPEN64PLUS_CXXFLAGS)" install
endef

define MUPEN64PLUS_GLES2RICE_CROSS_FIXUP
	$(SED) 's|/opt/vc/include|$(STAGING_DIR)/usr/include|g' $(@D)/projects/unix/Makefile
	$(SED) 's|/opt/vc/lib|$(STAGING_DIR)/usr/lib|g' $(@D)/projects/unix/Makefile
endef

MUPEN64PLUS_GLES2RICE_PRE_CONFIGURE_HOOKS += MUPEN64PLUS_GLES2RICE_CROSS_FIXUP

$(eval $(generic-package))
