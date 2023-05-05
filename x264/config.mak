SRCPATH=.
prefix=/Users/mac/code/c/mxffmpeg/x264/android/arm64-v8a
exec_prefix=${prefix}
bindir=${exec_prefix}/bin
libdir=${exec_prefix}/lib
includedir=${prefix}/include
SYS_ARCH=AARCH64
SYS=LINUX
CC=/Users/mac/soft/ndk22b/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android21-clang
CFLAGS=-Wshadow -O3 -ffast-math -Os -fpic  -Wall -I. -I$(SRCPATH) -std=gnu99 -D_GNU_SOURCE -fPIC -fomit-frame-pointer -fno-tree-vectorize -fvisibility=hidden
CFLAGSSO=
CFLAGSCLI=
COMPILER=GNU
COMPILER_STYLE=GNU
DEPMM=-MM -g0
DEPMT=-MT
LD=/Users/mac/soft/ndk22b/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android21-clang -o 
LDFLAGS= -lm  -ldl
LDFLAGSCLI=-ldl 
LIBX264=libx264.a
CLI_LIBX264=$(LIBX264)
AR=/Users/mac/soft/ndk22b/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android-ar rc 
RANLIB=/Users/mac/soft/ndk22b/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android-ranlib
STRIP=/Users/mac/soft/ndk22b/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android-strip
INSTALL=install
AS=/Users/mac/soft/ndk22b/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android21-clang
ASFLAGS= -I. -I$(SRCPATH) -c -DSTACK_ALIGNMENT=16 -DPIC
RC=
RCFLAGS=
EXE=
HAVE_GETOPT_LONG=1
DEVNULL=/dev/null
PROF_GEN_CC=-fprofile-generate
PROF_GEN_LD=-fprofile-generate
PROF_USE_CC=-fprofile-use
PROF_USE_LD=-fprofile-use
HAVE_OPENCL=yes
CC_O=-o $@
default: cli
install: install-cli
default: lib-static
install: install-lib-static
