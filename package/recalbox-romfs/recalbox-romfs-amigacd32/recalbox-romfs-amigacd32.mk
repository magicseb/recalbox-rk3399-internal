################################################################################
#
# recalbox-romfs-amigacd32
#
################################################################################

# Package generated with :
# ./scripts/linux/empack.py --force --system amigacd32 --extension '.uae .cue .CUE .ccd .CCD .iso .ISO .zip .ZIP' --fullname 'Amiga CD32' --platform amigacd32 --theme amigacd32 1:amiberry:amiberry:BR2_PACKAGE_AMIBERRY

# Name the 3 vars as the package requires
RECALBOX_ROMFS_AMIGACD32_SOURCE = 
RECALBOX_ROMFS_AMIGACD32_SITE = 
RECALBOX_ROMFS_AMIGACD32_INSTALL_STAGING = NO
# Set the system name
SYSTEM_NAME_AMIGACD32 = amigacd32
SYSTEM_XML_AMIGACD32 = $(@D)/$(SYSTEM_NAME_AMIGACD32).xml
# System rom path
SOURCE_ROMDIR_AMIGACD32 = $(RECALBOX_ROMFS_AMIGACD32_PKGDIR)/roms

# CONFIGGEN_STD_CMD is defined in recalbox-romfs, so take good care that
# variables are global across buildroot


ifneq ($(BR2_PACKAGE_AMIBERRY),)
define CONFIGURE_MAIN_AMIGACD32_START
	$(call RECALBOX_ROMFS_CALL_ADD_SYSTEM,$(SYSTEM_XML_AMIGACD32),Amiga CD32,$(SYSTEM_NAME_AMIGACD32),.uae .cue .CUE .ccd .CCD .iso .ISO .zip .ZIP,amigacd32,amigacd32)
endef

ifneq ($(BR2_PACKAGE_AMIBERRY),)
define CONFIGURE_AMIGACD32_AMIBERRY_START
	$(call RECALBOX_ROMFS_CALL_START_EMULATOR,$(SYSTEM_XML_AMIGACD32),amiberry)
endef
ifeq ($(BR2_PACKAGE_AMIBERRY),y)
define CONFIGURE_AMIGACD32_AMIBERRY_AMIBERRY_DEF
	$(call RECALBOX_ROMFS_CALL_ADD_CORE,$(SYSTEM_XML_AMIGACD32),amiberry,1)
endef
endif

define CONFIGURE_AMIGACD32_AMIBERRY_END
	$(call RECALBOX_ROMFS_CALL_END_EMULATOR,$(SYSTEM_XML_AMIGACD32))
endef
endif



define CONFIGURE_MAIN_AMIGACD32_END
	$(call RECALBOX_ROMFS_CALL_END_SYSTEM,$(SYSTEM_XML_AMIGACD32),$(SOURCE_ROMDIR_AMIGACD32),$(@D))
endef
endif

define RECALBOX_ROMFS_AMIGACD32_CONFIGURE_CMDS
	$(CONFIGURE_MAIN_AMIGACD32_START)
	$(CONFIGURE_AMIGACD32_AMIBERRY_START)
	$(CONFIGURE_AMIGACD32_AMIBERRY_AMIBERRY_DEF)
	$(CONFIGURE_AMIGACD32_AMIBERRY_END)
	$(CONFIGURE_MAIN_AMIGACD32_END)
endef

$(eval $(generic-package))
