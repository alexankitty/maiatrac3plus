#!/bin/bash
set -e

linux(){
    cmake -S ./MaiAT3PlusDecoder -B ./MaiAT3PlusDecoder/build -DCMAKE_BUILD_TYPE=Release
    cmake --build ./MaiAT3PlusDecoder/build --config Release
}

windows(){
    CXX=x86_64-w64-mingw32-g++
    CC=x86_64-w64-mingw32-gcc
    cmake -S ./MaiAT3PlusDecoder -B ./MaiAT3PlusDecoder/build -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=../cmake/mingw-w64-x86_64.cmake
    cmake --build ./MaiAT3PlusDecoder/build --config Release
}

macos(){
    cmake -S ./MaiAT3PlusDecoder -B ./MaiAT3PlusDecoder/build -DCMAKE_BUILD_TYPE=Release
    cmake --build ./MaiAT3PlusDecoder/build --config Release
}

if([ $# -eq 0 ]); then
    echo "Usage: $0 [linux|windows|macos]"
    exit 1
fi

for target in $@; do
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

