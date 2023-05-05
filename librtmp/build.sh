#!/bin/bash

# NDK_ROOT=/root/android-ndk-r17c
# CPU=arm-linux-androideabi
NDK=/Users/mac/soft/ndk22b
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
ANDROID_LIB_PATH="$(pwd)/android"


# export XCFLAGS="-isysroot $NDK_ROOT/sysroot -isystem $NDK_ROOT/sysroot/usr/include/arm-linux-androideabi -D__ANDROID_API__=17"
# export XLDFLAGS="--sysroot=${NDK_ROOT}/platforms/android-17/arch-arm "
# export CROSS_COMPILE=$TOOLCHAIN/bin/arm-linux-androideabi-

function build_android
{
rm -rf $(pwd)/android
echo "build for android $PLATFORM"
make clean
make install SYS=android prefix="$ANDROID_LIB_PATH/$PLATFORM" CRYPTO= SHARED=  XDEF=-DNO_SSL
echo "building for android $PLATFORM completed"
}

PLATFORM="arm64-v8a"
CPU=armv8-a
HOST=aarch64-linux-android
export AR=$TOOLCHAIN/bin/aarch64-linux-android-ar
# export AS=$TOOLCHAIN/bin/aarch64-linux-android-as
export LD=$TOOLCHAIN/bin/aarch64-linux-android-ld
export RANLIB=$TOOLCHAIN/bin/aarch64-linux-android-ranlib
export STRIP=$TOOLCHAIN/bin/aarch64-linux-android-strip
export CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
export CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
OPTIMIZE_CFLAGS=""
export CFLAGS="-Os -fpic $OPTIMIZE_CFLAGS"
export CPPFLAGS="-Os -fpic $OPTIMIZE_CFLAGS"

build_android

: <<EOF
#armv7-a
CPU=armeabi-v7a
HOST=arm-linux-android
export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
# export AS=$TOOLCHAIN/bin/arm-linux-androideabi-as
export LD=$TOOLCHAIN/bin/arm-linux-androideabi-ld
export RANLIB=$TOOLCHAIN/bin/arm-linux-androideabi-ranlib
export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip
export CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
export CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm"
export CFLAGS="-Os -fpic $OPTIMIZE_CFLAGS"
export CPPFLAGS="-Os -fpic $OPTIMIZE_CFLAGS"

build_android
EOF
