#
# Makefile
#
# Copyright (C) 2014 Creytiv.com
#

# Paths to your Android SDK/NDK
NDK_PATH  := $(HOME)/android/android-ndk-r9c
SDK_PATH  := $(HOME)/android/android-sdk-mac_x86
HOST_OS   := linux-x86_64
#HOST_OS   := darwin-x86_64

# Tools
SYSROOT   := $(NDK_PATH)/platforms/android-19/arch-arm/usr
PREBUILT  := $(NDK_PATH)/toolchains/arm-linux-androideabi-4.8/prebuilt
BIN       := $(PREBUILT)/$(HOST_OS)/bin
CC        := $(BIN)/arm-linux-androideabi-gcc
RANLIB    := $(BIN)/arm-linux-androideabi-ranlib
AR        := $(BIN)/arm-linux-androideabi-ar
ADB       := $(SDK_PATH)/platform-tools/adb
PWD       := $(shell pwd)

# Compiler and Linker Flags
CFLAGS    := \
	-I$(SYSROOT)/include/ \
	-I$(PWD)/openssl/include \
	-Wno-cast-align \
	-Wno-shadow \
	-Wno-nested-externs \
	-march=armv7-a
LFLAGS    := -L$(SYSROOT)/lib/ \
	-L$(PWD)/openssl
LFLAGS    += --sysroot=$(NDK_PATH)/platforms/android-19/arch-arm


COMMON_FLAGS := CC=$(CC) \
		RANLIB=$(RANLIB) \
		EXTRA_CFLAGS="$(CFLAGS)" \
		EXTRA_LFLAGS="$(LFLAGS)" \
		SYSROOT=$(SYSROOT) \
		SYSROOT_ALT= \
		HAVE_LIBRESOLV= \
		HAVE_PTHREAD=1 \
		HAVE_PTHREAD_RWLOCK=1 \
		HAVE_LIBPTHREAD= \
		HAVE_INET_PTON=1 \
		HAVE_INET6= \
		PEDANTIC= \
		OS=linux ARCH=arm \
		USE_OPENSSL=yes

default:	retest baresip

libre.a: Makefile
	@rm -f re/$@
	@make $@ -C re $(COMMON_FLAGS)

librem.a:	Makefile libre.a
	@rm -f rem/$@
	@make $@ -C rem $(COMMON_FLAGS)

retest:		Makefile librem.a libre.a
	@make $@ -C retest $(COMMON_FLAGS) LIBRE_SO=$(PWD)/re

baresip:	Makefile librem.a libre.a
	@rm -f baresip/baresip
	@make $@ -C baresip $(COMMON_FLAGS) STATIC=1 \
		LIBRE_SO=$(PWD)/re LIBREM_PATH=$(PWD)/rem \
		EXTRA_MODULES="opensles"

install:	baresip retest
	$(ADB) push retest/retest /data/retest
	$(ADB) push baresip/baresip /data/baresip

clean:
	make distclean -C baresip
	make distclean -C retest
	make distclean -C rem
	make distclean -C re

info:
	make $@ -C re $(COMMON_FLAGS)

.PHONY: openssl
openssl:
	cd openssl && \
		CC=$(CC) RANLIB=$(RANLIB) AR=$(AR) \
		./Configure android-armv7 && \
		ANDROID_DEV=$(SYSROOT) make build_libs

dump:
	@echo "NDK_PATH = $(NDK_PATH)"
	@echo "SDK_PATH = $(SDK_PATH)"
	@echo "HOST_OS  = $(HOST_OS)"
