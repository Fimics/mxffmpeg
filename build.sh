#!/bin/bash

NDK=/Users/mac/soft/ndk22b
HOST_TAG=linux-x86_64
API=21
BASEPATH=$(cd `dirname $0`; pwd)

uname_s=$(uname -s)
echo $uname_s

 if [ "$uname_s" == "Darwin" ]; then
     echo "this is macOS"
     HOST_TAG=darwin-x86_64
 elif [ "$uname_s" == "Linux" ]; then
      echo "this is Linux"
      HOST_TAG=linux-x86_64
 else
    echo "this is windows"
    HOST_TAG=windows-x86_64
 fi

TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG/
echo $TOOLCHAIN

function build_android
{
echo "---------------------------------------------build android start----------------------------------------------------"
rm -rf $(pwd)/android
echo "Compiling FFmpeg for $PLATFORM"
echo "Compiling FFmpeg link $FDK_LIB"
echo "Compiling FFmpeg link $X264_LIB"
echo "Compiling FFmpeg link $MP3_LIB"
echo "Compiling FFmpeg link $RTMP_LIB"
echo "先执行  ./configure --disable-x86asm 解决  Makefile:2: ffbuild/config.mak: No such file or directory问题"
./configure \
    --prefix=$PREFIX \
    --enable-small \
    --disable-neon \
    --disable-hwaccels \
    --enable-shared \
    --enable-static \
    --enable-jni \
    --disable-mediacodec \
    --disable-decoder=h264_mediacodec \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-doc \
    --disable-symver \
    --extra-cflags="-I$X264_INCLUDE  -I$FDK_INCLUDE -I$MP3_INCLUDE -I$RTMP_INCLUDE" \
    --extra-ldflags="-L$X264_LIB -L$MP3_LIB -L$FDK_LIB -L$RTMP_LIB" \
    --enable-nonfree \
    --enable-gpl \
    --disable-librtmp \
    --enable-libfdk-aac \
    --enable-libx264 \
    --enable-libmp3lame \
    --cross-prefix=$CROSS_PREFIX \
    --target-os=android \
    --arch=$ARCH \
    --cpu=$CPU \
    --cc=$CC
    --cxx=$CXX
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
make clean
make
make install
echo "The Compilation of FFmpeg for $PLATFORM is completed"
echo "---------------------------------------------build android end----------------------------------------------------"
}

function build_depends
{

    echo  "---------------------当前目录"$BASEPATH"-------------------------------------"
    # 在shell脚本里切换目录 https://blog.csdn.net/kaikai136412162/article/details/80744380
    echo "---------------------------------------------librtmp start----------------------------------------------------"
    cd "$BASEPATH/librtmp"
    sh ./build.sh
    echo "---------------------------------------------librtmp end----------------------------------------------------"

    echo "---------------------------------------------x264 start----------------------------------------------------"
    cd "$BASEPATH/x264"
    sh ./build.sh
    echo "---------------------------------------------x264 end----------------------------------------------------"

    echo "---------------------------------------------lame start----------------------------------------------------"
    cd "$BASEPATH/lame"
    sh ./build.sh
    echo "---------------------------------------------lame end----------------------------------------------------"

    echo "---------------------------------------------fdk-aac start----------------------------------------------------"
    cd "$BASEPATH/fdk-aac"
    sh ./build.sh
    echo "---------------------------------------------fdk-aac end----------------------------------------------------"
    cd "$BASEPATH"
}


function copy
{
echo "---------------------------------------------copy start----------------------------------------------------"
    if [ ! -d "$FFMPEG_INCLUDE_EXTENDS" ]; then
       echo "$FFMPEG_INCLUDE_EXTENDS does not exist"
       mkdir $FFMPEG_INCLUDE_EXTENDS
       echo "创建 -> $FFMPEG_INCLUDE_EXTENDS"
       else
       echo "$FFMPEG_INCLUDE_EXTENDS already exist"
    fi

    if [ ! -d "$FFMPEG_LIB_EXTENDS" ]; then
       echo "$FFMPEG_LIB_EXTENDS does not exist"
       mkdir $FFMPEG_LIB_EXTENDS
       echo "创建 -> $FFMPEG_LIB_EXTENDS"
       else
       echo "$FFMPEG_LIB_EXTENDS already exist"
    fi

    #copy includedir and *.a
    mkdir $FFMPEG_INCLUDE_EXTENDS/fdk-acc
    cp -r $FDK_INCLUDE/fdk-aac/ $FFMPEG_INCLUDE_EXTENDS/fdk-acc
    cp  $FDK_LIB/libfdk-aac.a $FFMPEG_LIB_EXTENDS/libfdk-aac.a

    mkdir -p $FFMPEG_INCLUDE_EXTENDS/x264
    cp -r $X264_INCLUDE/ $FFMPEG_INCLUDE_EXTENDS/x264
    cp  $X264_LIB/libx264.a $FFMPEG_LIB_EXTENDS/libx264.a

    mkdir -p $FFMPEG_INCLUDE_EXTENDS/lame
    cp -r $MP3_INCLUDE/lame/ $FFMPEG_INCLUDE_EXTENDS/lame
    cp  $MP3_LIB/libmp3lame.a $FFMPEG_LIB_EXTENDS/libmp3lame.a

    mkdir -p $FFMPEG_INCLUDE_EXTENDS/librtmp
    cp -r $RTMP_INCLUDE/librtmp/ $FFMPEG_INCLUDE_EXTENDS/librtmp/
    cp  $RTMP_LIB/librtmp.a $FFMPEG_LIB_EXTENDS/librtmp.a
    echo "---------------------------------------------copy end----------------------------------------------------"
}


PLATFORM="arm64-v8a"
#armv8-a
ARCH=arm64
CPU=armv8-a
CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
SYSROOT=$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
PREFIX=$(pwd)/android/$PLATFORM
OPTIMIZE_CFLAGS="-march=$CPU"

#拷贝目录
FFMPEG_INCLUDE_EXTENDS=$BASEPATH/android/$PLATFORM/include/extra
FFMPEG_LIB_EXTENDS=$BASEPATH/android/$PLATFORM/lib/extra

#第三方库
FDK_INCLUDE=$BASEPATH/fdk-aac/android/$PLATFORM/include
FDK_LIB=$BASEPATH/fdk-aac/android/$PLATFORM/lib
X264_INCLUDE=$BASEPATH/x264/android/$PLATFORM/include
X264_LIB=$BASEPATH/x264/android/$PLATFORM/lib
MP3_INCLUDE=$BASEPATH/lame/android/$PLATFORM/include
MP3_LIB=$BASEPATH/lame/android/$PLATFORM/lib
RTMP_INCLUDE=$BASEPATH/librtmp/android/$PLATFORM/include
RTMP_LIB=$BASEPATH/librtmp/android/$PLATFORM/lib

startTime_s=`date +%s`
build_depends
build_android
copy
endTime_s=`date +%s`
sumTime=$[ $endTime_s - $startTime_s ]
echo "$startTime ---> $endTime" "Total:$sumTime seconds"

: <<EOF

#armv7-a
ARCH=arm
CPU=armv7-a
OUT_DIR=armeabi-v7a
CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
SYSROOT=$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
PREFIX=$(pwd)/android/$OUT_DIR
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
#第三方库
FDK_INCLUDE=$BASEPATH/fdk-aac/android/$CPU/include
FDK_LIB=$BASEPATH/fdk-aac/android/$CPU/lib
X264_INCLUDE=$BASEPATH/x264/android/$CPU/include
X264_LIB=$BASEPATH/x264/android/$CPU/lib
MP3_INCLUDE=$BASEPATH/lame/android/$CPU/include
MP3_LIB=$BASEPATH/lame/android/$CPU/lib
# build_android
EOF
