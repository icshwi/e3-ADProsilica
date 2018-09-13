#
#  Copyright (c) 2018 - Present  European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# 
# Author  : Jeong Han Lee
# email   : han.lee@esss.se
# Date    :Thursday, September 13 23:20:02 CEST 2018
# version : 0.0.2
#


where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(E3_REQUIRE_TOOLS)/driver.makefile

# If one would like to use the module dependency restrictly,
# one should look at other modules makefile to add more
# In most case, one should ignore the following lines:

ifneq ($(strip $(ASYN_DEP_VERSION)),)
asyn_VERSION=$(ASYN_DEP_VERSION)
endif

ifneq ($(strip $(ADCORE_DEP_VERSION)),)
ADCore_VERSION=$(ADCORE_DEP_VERSION)
endif

# Exclude linux-ppc64e6500
EXCLUDE_ARCHS = linux-ppc64e6500



# *** ISSUES
# driver.makefile recursively read all include directories which were installed.
# The only way to exclude header files is....



iocStats_VERSION=
autosave_VERSION=
#asyn_VERSION=
busy_VERSION=
modbus_VERSION=
ipmiComm_VERSION=
sequencer_VERSION=
sscan_VERSION=

std_VERSION=
ip_VERSION=
calc_VERSION=
pcre_VERSION=
stream_VERSION=
s7plc_VERSION=
recsync_VERSION=

devlib2_VERSION=
mrfioc2_VERSION=

exprtk_VERSION=
motor_VERSION=
ecmc_VERSION=
EthercatMC_VERSION=
ecmctraining_VERSION=


keypress_VERSION=
sysfs_VERSION=
symbolname_VERSION=
memDisplay_VERSION=
regdev_VERSION=
i2cDev_VERSION=

tosca_VERSION=
tsclib_VERSION=
ifcdaqdrv2_VERSION=

## The main issue is nds3, it is mandatory to disable it
## 
nds3_VERSION=
nds3epics_VERSION=
ifc14edrv_VERSION=
ifcfastint_VERSION=


nds_VERSION=
loki_VERSION=
nds_VERSION=
sis8300drv_VERSION=
sis8300_VERSION=
sis8300llrfdrv_VERSION=
sis8300llrf_VERSION=


ADSupport_VERSION=
#ADCore_VERSION=
ADSimDetector_VERSION=
ADAndor_VERSION=
ADAndor3_VERSION=
ADPointGrey_VERSION=
#ADProsilica_VERSION=

amcpico8_VERSION=
adpico8_VERSION=
adsis8300_VERSION=
adsis8300bcm_VERSION=
adsis8300bpm_VERSION=
adsis8300fc_VERSION=





SUPPORT:=prosilicaSupport

APP:=prosilicaApp
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src

## We will use XML2 as the system lib, instead of ADSupport
## Do we need to load libxml2 when we start iocsh?

USR_INCLUDES += -I/usr/include/libxml2
LIB_SYS_LIBS += xml2	

USR_CXXFLAGS += -D_LINUX -D_x86



HEADERS += $(SUPPORT)/PvApi.h

SOURCES += $(APPSRC)/prosilica.cpp

DBDS    += $(APPSRC)/prosilicaSupport.dbd


# USR_LDFLAGS += -Wl,--whole-archive $(where_am_I)$(SUPPORT)/os/linux-x86_64/libPvAPI.a -Wl,--no-whole-archive



LIBOBJS += $(where_am_I)$(SUPPORT)/os/linux-x86_64/libPvAPI.a


# # We don't have LIB_INSTALLS, so will tackle later
# ifeq ($(T_A),linux-x86_64)
# USR_LDFLAGS += -Wl,--enable-new-dtags
# USR_LDFLAGS += -Wl,-rpath=$(E3_MODULES_VENDOR_LIBS_LOCATION)
# USR_LDFLAGS += -L$(E3_MODULES_VENDOR_LIBS_LOCATION)
# USR_LDFLAGS += -lflycapture
# endif

# According to its makefile
# VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libflycapture.so.2.8.3.1
# VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libflycapture.so.2
# VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libflycapture.so



# We have to convert all to db 
TEMPLATES += $(wildcard $(APPDB)/*.db)



## This RULE should be used in case of inflating DB files 
## db rule is the default in RULES_DB, so add the empty one
## Please look at e3-mrfioc2 for example.

USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I $(EPICS_BASE)/db
USR_DBFLAGS += -I $(APPDB)

# 
#
USR_DBFLAGS += -I $(E3_SITELIBS_PATH)/ADCore_$(ADCORE_DEP_VERSION)_db

SUBS=$(wildcard $(APPDB)/*.substitutions)
TMPS=$(wildcard $(APPDB)/*.template)


db: $(SUBS) $(TMPS)

$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

$(TMPS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@


.PHONY: db $(SUBS) $(TMPS)





vlibs:

.PHONY: vlibs

# vlibs: $(VENDOR_LIBS)

# $(VENDOR_LIBS):
# 	$(QUIET) $(SUDO) install -m 555 -d $(E3_MODULES_VENDOR_LIBS_LOCATION)/
# 	$(QUIET) $(SUDO) install -m 555 $@ $(E3_MODULES_VENDOR_LIBS_LOCATION)/

# .PHONY: $(VENDOR_LIBS) vlibs



