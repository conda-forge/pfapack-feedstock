@echo off
setlocal enabledelayedexpansion

set PIP_NO_BUILD_ISOLATION=1
set SETUPTOOLS_SCM_PRETEND_VERSION=%PKG_VERSION%
set "OPENBLAS_LIBDIR=%PREFIX%\Library\lib"

%PYTHON% -m pip install . --no-deps --no-build-isolation ^
  -Csetup-args=-Dfortran_std=none ^
  "-Csetup-args=-Dopenblas_libdir=!OPENBLAS_LIBDIR!" ^
  -vv
