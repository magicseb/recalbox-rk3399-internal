################################################################################
#
# amiberry
#
################################################################################
ifeq ($(BR2_PACKAGE_RECALBOX_TARGETGROUP_ROCKCHIP),y)
AMIBERRY_VERSION = 9cffc2680394fa705a7732e36f2453d8ace8eaad
AMIBERRY_BINARY = amiberry
AMIBERRY_DEPENDENCIES = sdl2 sdl2_image sdl2_mixer guichan mpg123 host-pkgconf sdl2_ttf libcapsimage libmpeg2
else
AMIBERRY_VERSION = v3.1.3.1
AMIBERRY_SITE = $(call github,midwan,amiberry,$(AMIBERRY_VERSION))
AMIBERRY_DEPENDENCIES = sdl2 sdl2_image sdl2_ttf libcapsimage libmpeg2 mpg123 flac

ifeq ($(BR2_PACKAGE_RECALBOX_TARGET_RPI3),y)
AMIBERRY_PLATFORM=rpi3-sdl2
else ifeq ($(BR2_PACKAGE_RECALBOX_TARGET_RPI2),y)
AMIBERRY_PLATFORM=rpi2-sdl2
else ifeq ($(BR2_PACKAGE_RECALBOX_TARGET_RPI1),y)
AMIBERRY_PLATFORM=rpi1-sdl2
else ifeq ($(BR2_PACKAGE_RECALBOX_TARGET_XU4),y)
AMIBERRY_PLATFORM=xu4
else ifeq ($(BR2_PACKAGE_RECALBOX_TARGET_RK3328),y)
AMIBERRY_PLATFORM=RK3328
else ifeq ($(BR2_PACKAGE_RECALBOX_TARGET_RK3399),y)
AMIBERRY_PLATFORM=RK3399
endif

define AMIBERRY_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_GCC_LINKER_OPTIMIZATION_EXECUTABLE)" \
	CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_GCC_LINKER_OPTIMIZATION_EXECUTABLE)" \
	LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_GCC_LINKER_OPTIMIZATION_EXECUTABLE)" \
	$(TARGET_CONFIGURE_OPTS) \
	$(MAKE)	CPP="$(TARGET_CPP)" \
		CXX="$(TARGET_CXX)" \
		CC="$(TARGET_CC)" \
		AS="$(TARGET_AS)" \
		STRIP="$(TARGET_STRIP)" \
		SDL_CONFIG=$(STAGING_DIR)/usr/bin/sdl2-config \
		-C $(@D) \
		-f Makefile \
		PLATFORM="$(AMIBERRY_PLATFORM)"
endef

define AMIBERRY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/amiberry $(TARGET_DIR)/usr/bin/amiberry
	mkdir -p $(TARGET_DIR)/usr/share/amiberry
	cp -R $(@D)/data $(TARGET_DIR)/usr/share/amiberry
	cp -R $(@D)/whdboot $(TARGET_DIR)/usr/share/amiberry
	rm $(TARGET_DIR)/usr/share/amiberry/whdboot/hostprefs.conf
	rm $(TARGET_DIR)/usr/share/amiberry/whdboot/save-data/Savegames/foo.txt
	rm $(TARGET_DIR)/usr/share/amiberry/whdboot/save-data/Kickstarts/foo.txt
	rm $(TARGET_DIR)/usr/share/amiberry/whdboot/save-data/Debugs/foo.txt
	rm $(TARGET_DIR)/usr/share/amiberry/whdboot/save-data/Autoboots/foo.txt
endef

$(eval $(generic-package))
