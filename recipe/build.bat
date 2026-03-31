@echo off
setlocal

mkdir build

REM Meson still needs explicit linker selection for flang-new on Windows.
set LD=lld-link
set FC_LD=lld-link
set CC_LD=lld-link

set PIP_NO_BUILD_ISOLATION=1
set SETUPTOOLS_SCM_PRETEND_VERSION=%PKG_VERSION%
%PYTHON% -m pip install . --no-deps --no-build-isolation -vv ^
  -Cbuild-dir=build ^
  -Csetup-args=-Dbuild_tests=disabled

if %ERRORLEVEL% neq 0 (type build\meson-logs\meson-log.txt && exit 1)
