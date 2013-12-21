#
# Makefile
#
# Copyright (C) 2013 Creytiv.com
#

# Paths to your Android SDK/NDK
NDK_PATH  := /Users/alfredh/android/android-ndk-r8e
SDK_PATH  := /Users/alfredh/android/android-sdk-mac_x86

# Tools
SYSROOT   := $(NDK_PATH)/platforms/android-14/arch-arm/usr
PREBUILT  := $(NDK_PATH)/toolchains/arm-linux-androideabi-4.7/prebuilt
BIN       := $(PREBUILT)/darwin-x86_64/bin
CC        := $(BIN)/arm-linux-androideabi-gcc
RANLIB    := $(BIN)/arm-linux-androideabi-ranlib
ADB       := $(SDK_PATH)/platform-tools/adb

# Compiler and Linker Flags
CFLAGS    := \
	-I$(SYSROOT)/include/ \
	-Wno-cast-align \
	-Wno-shadow \
	-Wno-nested-externs \
	-march=armv7-a
LFLAGS    := -L$(SYSROOT)/lib/
LFLAGS    += --sysroot=$(NDK_PATH)/platforms/android-14/arch-arm


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
		OS=linux ARCH=arm

default:	retest baresip

libre.a: Makefile
	@rm -f re/$@
	@make $@ -C re $(COMMON_FLAGS)

librem.a:	Makefile libre.a
	@rm -f rem/$@
	@make $@ -C rem $(COMMON_FLAGS)

retest:		Makefile librem.a libre.a
	@make $@ -C retest $(COMMON_FLAGS) LIBRE_SO=../re

baresip:	Makefile librem.a libre.a
	@rm -f baresip/baresip
	@make $@ -C baresip $(COMMON_FLAGS) LIBRE_SO=../re STATIC=1 \
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
