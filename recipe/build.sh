#!/bin/bash

mkdir -p "${PREFIX}/lib"
mkdir -p "${PREFIX}/include"

cp ${RECIPE_DIR}/Makefile.C pfapack/c_interface/makefile
cp ${RECIPE_DIR}/Makefile.FORTRAN pfapack/fortran/makefile

# FORTRAN

cd pfapack/fortran
make clean all
cp *.o *.mod libpfapack.a libpfapack.so ${PREFIX}/lib
cd ../..

# C

cd pfapack/c_interface
make clean all
cp *.o libcpfapack.a libcpfapack.so ${PREFIX}/lib
cp *.h ${PREFIX}/lib
cd ../..

# Python

cd python
$PYTHON -m pip install . -vv
