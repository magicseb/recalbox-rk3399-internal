################################################################################
#
# mupen64plus core
#
################################################################################

MUPEN64PLUS_CORE_VERSION = 4edc53c2d5aee33605b3a151d405882030ba94f3
MUPEN64PLUS_CORE_SITE = $(call github,mupen64plus,mupen64plus-core,$(MUPEN64PLUS_CORE_VERSION))
MUPEN64PLUS_CORE_LICENSE = GPLv2+
MUPEN64PLUS_CORE_DEPENDENCIES = sdl2 alsa-lib libpng freetype host-nasm host-binutils
MUPEN64PLUS_CORE_INSTALL_STAGING = YES

MUPEN64PLUS_CORE_GL_CFLAGS = -I$(STAGING_DIR)/usr/include -L$(STAGING_DIR)/usr/lib

MUPEN64PLUS_CXXFLAGS = $(TARGET_CXXFLAGS)
MUPEN64PLUS_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_PACKAGE_XORG7),y)
MUPEN64PLUS_CORE_GL_LDLIBS = -lGL
else
MUPEN64PLUS_CORE_GL_LDLIBS = -lGLESv2 -lEGL
MUPEN64PLUS_CORE_PARAMS = USE_GLES=1
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
MUPEN64PLUS_CORE_DEPENDENCIES += rpi-userland
MUPEN64PLUS_CORE_GL_LDLIBS += -lbcm_host
MUPEN64PLUS_CORE_PARAMS += VC=1
endif

ifeq ($(BR2_arm),y)
ifeq ($(BR2_ARM_CPU_ARMV8A),y)
MUPEN64PLUS_CORE_HOST_CPU = armv8
else
MUPEN64PLUS_CORE_HOST_CPU = armv7
endif
endif

ifeq ($(BR2_aarch64),y)
MUPEN64PLUS_CORE_HOST_CPU = aarch64
MUPEN64PLUS_CORE_PARAMS += NEON=1
endif

ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
MUPEN64PLUS_CORE_PARAMS += NEON=1
endif

ifeq ($(BR2_PACKAGE_RECALBOX_TARGET_X86),y)
MUPEN64PLUS_CORE_HOST_CPU = i586
endif

ifeq ($(BR2_PACKAGE_RECALBOX_TARGET_X86_64),y)
MUPEN64PLUS_CORE_HOST_CPU = x86_64
endif


ifeq ($(BR2_PACKAGE_RECALBOX_TARGETGROUP_ROCKCHIP),y)
	MUPEN64PLUS_CORE_PARAMS += USE_GLES=1 ARCH=arm NEW_DYNAREC=1 VFP_HARD=1 VFP=1 CRC_OPT=1 TRIBUFFER_OPT=1 NO_SSE=1 PIC=1 USE_FRAMESKIPPER=1
	MUPEN64PLUS_CXXFLAGS += -I/usr/include/libdrm -ldrm -fpermissive
	MUPEN64PLUS_CFLAGS += -I/usr/include/libdrm -ldrm
endif

define MUPEN64PLUS_CORE_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/projects/unix/Makefile
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" RANLIB="$(TARGET_RANLIB)" AR="$(TARGET_AR)" \
		    CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" AS="$(HOST_DIR)/bin/nasm" STRINGS="$(STAGING_DIR)/../bin/strings" \
			PREFIX="$(STAGING_DIR)/usr" \
			SHAREDIR="/recalbox/share/system/configs/mupen64/" \
			PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
			HOST_CPU="$(MUPEN64PLUS_CORE_HOST_CPU)" \
			-C $(@D)/projects/unix all $(MUPEN64PLUS_CORE_PARAMS) OPTFLAGS="$(TARGET_CXXFLAGS)"
endef

define MUPEN64PLUS_CORE_INSTALL_STAGING_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/projects/unix/Makefile
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" RANLIB="$(TARGET_RANLIB)" AR="$(TARGET_AR)" CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
			PREFIX="$(STAGING_DIR)/usr" \
			SHAREDIR="$(TARGET_DIR)/recalbox/share_init/system/configs/mupen64/" \
			PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
			HOST_CPU="$(MUPEN64PLUS_CORE_HOST_CPU)" \
			INSTALL="/usr/bin/install" \
			INSTALL_STRIP_FLAG="" \
			-C $(@D)/projects/unix all $(MUPEN64PLUS_CORE_PARAMS) OPTFLAGS="$(TARGET_CXXFLAGS)" install
endef

define MUPEN64PLUS_CORE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 $(@D)/projects/unix/libmupen64plus.so.2.0.0 $(TARGET_DIR)/usr/lib
	mkdir -p $(TARGET_DIR)/recalbox/share_init/system/configs/mupen64/hires_texture
endef

define MUPEN64PLUS_CORE_CROSS_FIXUP
	$(SED) 's|/opt/vc/include|$(STAGING_DIR)/usr/include|g' $(@D)/projects/unix/Makefile
	$(SED) 's|/opt/vc/lib|$(STAGING_DIR)/usr/lib|g' $(@D)/projects/unix/Makefile
endef

MUPEN64PLUS_CORE_PRE_CONFIGURE_HOOKS += MUPEN64PLUS_CORE_CROSS_FIXUP

$(eval $(generic-package))
