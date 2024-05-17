#!/bin/bash

set -ex

export CXXFLAGS="${CXXFLAGS} -D__STDC_FORMAT_MACROS -D_LIBCPP_DISABLE_AVAILABILITY"


WRT=yes


mkdir build
cd build
export LFORTRAN_CC=${CC}
export EMSDK_PATH=${CONDA_EMSDK_DIR}
# export WASI_SDK_PATH=""

chmod 777 ${SRC_DIR}/ci/version.sh

cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_LLVM=yes \
    -DLFORTRAN_BUILD_ALL=yes \
    -DWITH_STACKTRACE=yes \
    -DWITH_RUNTIME_STACKTRACE=no \
    -DCMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH_LFORTRAN;$CONDA_PREFIX" \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_LIBDIR=share/lfortran/lib \
    -DWITH_TARGET_WASM=yes \
    $SRC_DIR

# cmake ${CMAKE_ARGS} \
#     -DCMAKE_BUILD_TYPE=Release \
#     -DCMAKE_CXX_FLAGS_RELEASE="-Wall -Wextra -O3 -funroll-loops -DNDEBUG" \
#     -DCMAKE_INSTALL_PREFIX=$PREFIX \
#     -DCMAKE_PREFIX_PATH=$PREFIX \
#     -DWITH_LLVM=yes \
#     -DWITH_XEUS=no \
#     -DWITH_TARGET_WASM=yes \
#     -DWITH_RUNTIME_LIBRARY=no \
#     -DWITH_RUNTIME_STACKTRACE=no \
#     -DCMAKE_INSTALL_LIBDIR=share/lfortran/lib \
#     $SRC_DIR

make -j${CPU_COUNT}
make install
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == 1 ]]; then
    cp ../build-native/src/runtime/*.mod $PREFIX/share/lfortran/lib/
fi
