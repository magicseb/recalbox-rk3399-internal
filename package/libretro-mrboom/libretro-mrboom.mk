################################################################################
#
# MRBOOM
#
################################################################################

LIBRETRO_MRBOOM_VERSION = 4273564fce7ecc850c424f02a3571393b30ae0ec
LIBRETRO_MRBOOM_SITE = $(call github,libretro,mrboom-libretro,$(LIBRETRO_MRBOOM_VERSION))

# Flag to fix build on arm platforms
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
LIBRETRO_MRBOOM_OPTIONS += HAVE_NEON=1
else
LIBRETRO_MRBOOM_OPTIONS +=
endif

define LIBRETRO_MRBOOM_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/Makefile
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="unix" $(LIBRETRO_MRBOOM_OPTIONS)
endef

define LIBRETRO_MRBOOM_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/mrboom_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/mrboom_libretro.so
endef

$(eval $(generic-package))
