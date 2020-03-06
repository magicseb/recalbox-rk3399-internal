################################################################################
#
# VICE
#
################################################################################

LIBRETRO_VICE_VERSION = 3ab6a83a65aace0fef10b1f83394bd814a0abf3f
LIBRETRO_VICE_SITE = $(call github,libretro,vice-libretro,$(LIBRETRO_VICE_VERSION))

LIBRETRO_VICE_SUBEMULATORS = x64 x64sc x128 xpet xplus4 xvic xcbm2

define LIBRETRO_VICE_BUILD_EMULATOR
	find $(@D) -name *.o -delete; \
	find $(@D) -name *.a -delete; \
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		SHARED="$(TARGET_SHARED)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile.libretro platform="$(RETROARCH_LIBRETRO_PLATFORM)" EMUTYPE=$(strip $(1));
endef

define LIBRETRO_VICE_BUILD_CMDS
	$(foreach emulator, $(LIBRETRO_VICE_SUBEMULATORS), $(call LIBRETRO_VICE_BUILD_EMULATOR, $(emulator)))
endef

define LIBRETRO_VICE_INSTALL_EMULATOR
#	@echo "Installing $(1)..."; \
	$(INSTALL) -D $(@D)/vice_$(strip $(1))_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/vice_$(strip $(1))_libretro.so ;
endef

define LIBRETRO_VICE_INSTALL_TARGET_CMDS
	$(foreach emulator, $(LIBRETRO_VICE_SUBEMULATORS), $(call LIBRETRO_VICE_INSTALL_EMULATOR, $(emulator)))
endef

define LIBRETRO_VICE_PRE_PATCH_FIXUP
	$(SED) "s|-O2|-O3|g" $(@D)/Makefile.libretro
	$(SED) 's/\r//g' $(@D)/libretro/libretro-core.c
endef

LIBRETRO_VICE_PRE_PATCH_HOOKS += LIBRETRO_VICE_PRE_PATCH_FIXUP

LIBRETRO_VICE_CONF_OPTS += -DCMAKE_C_ARCHIVE_CREATE="<CMAKE_AR> qcs <TARGET> <LINK_FLAGS> <OBJECTS>"
LIBRETRO_VICE_CONF_OPTS += -DCMAKE_C_ARCHIVE_FINISH=true
LIBRETRO_VICE_CONF_OPTS += -DCMAKE_CXX_ARCHIVE_CREATE="<CMAKE_AR> qcs <TARGET> <LINK_FLAGS> <OBJECTS>"
LIBRETRO_VICE_CONF_OPTS += -DCMAKE_CXX_ARCHIVE_FINISH=true
LIBRETRO_VICE_CONF_OPTS += -DCMAKE_AR="$(TARGET_CC)-ar"
LIBRETRO_VICE_CONF_OPTS += -DCMAKE_C_COMPILER="$(TARGET_CC)"
LIBRETRO_VICE_CONF_OPTS += -DCMAKE_CXX_COMPILER="$(TARGET_CXX)"
LIBRETRO_VICE_CONF_OPTS += -DCMAKE_LINKER="$(TARGET_LD)"
LIBRETRO_VICE_CONF_OPTS += -DCMAKE_C_FLAGS="$(COMPILER_COMMONS_CFLAGS_SO)"
LIBRETRO_VICE_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(COMPILER_COMMONS_CXXFLAGS_SO)"
LIBRETRO_VICE_CONF_OPTS += -DCMAKE_LINKER_EXE_FLAGS="$(COMPILER_COMMONS_LDFLAGS_SO)"

$(eval $(generic-package))
