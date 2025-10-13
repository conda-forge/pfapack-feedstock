@echo off
setlocal enabledelayedexpansion

set PIP_NO_BUILD_ISOLATION=1
set SETUPTOOLS_SCM_PRETEND_VERSION=%PKG_VERSION%

for %%I in ("%LIBRARY_LIB%") do (
	set "OPENBLAS_LIBDIR=%%~fI"
)

if "%MESON_ARGS%"=="" (
	set "MESON_ARGS=-Dfortran_std=none -Dopenblas_libdir=!OPENBLAS_LIBDIR!"
) else (
	set "MESON_ARGS=%MESON_ARGS% -Dfortran_std=none -Dopenblas_libdir=!OPENBLAS_LIBDIR!"
)

%PYTHON% -m pip install . --no-deps --no-build-isolation -vv
