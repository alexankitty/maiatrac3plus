#!/bin/bash
set -e

if [ -d "./lib" ]; then
    rm -rf ./lib
fi

cd ./MaiAT3PlusDecoder

if [ -d "./build" ]; then
    rm -rf ./build
fi

mkdir -p ../lib

linux(){
    cmake . -B ./build -DCMAKE_BUILD_TYPE=Release
    make -C ./build -j$(nproc)
    cp ./build/lib/libat3plusdecoder.so ../lib/
}

windows(){
    export CXX=x86_64-w64-mingw32-g++
    export CC=x86_64-w64-mingw32-gcc
    TOOLCHAIN_FILE="/usr/share/mingw/toolchain-x86_64-w64-mingw32.cmake"
    if [ -f "$TOOLCHAIN_FILE" ]; then
        cmake . -B ./build -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE
    else
        echo "Warning: Toolchain file not found at $TOOLCHAIN_FILE. Using CC/CXX env vars only."
        cmake . -B ./build -DCMAKE_BUILD_TYPE=Release -DCMAKE_SYSTEM_NAME=Windows
    fi
    make -C ./build -j$(nproc)
    cp ./build/libat3plusdecoder.dll ../lib/
}

macos(){
    cmake . -B ./build -DCMAKE_BUILD_TYPE=Release
    make -C ./build -j$(sysctl -n hw.ncpu)
    cp ./build/lib/libat3plusdecoder.dylib ../lib/
}

if [ $# -eq 0 ]; then
    echo "Usage: $0 [linux|windows|macos]"
    exit 1
fi

for target in "$@"; do
    case $target in
        linux)
            linux ;;
        windows)
            windows ;;
        macos)
            macos ;;
        *)
            echo "Unknown target: $target"
            exit 1 ;;
    esac
done

