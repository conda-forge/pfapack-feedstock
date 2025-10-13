@echo off
setlocal enabledelayedexpansion

set PIP_NO_BUILD_ISOLATION=1
set SETUPTOOLS_SCM_PRETEND_VERSION=%PKG_VERSION%

if "%MESON_ARGS%"=="" (
	set "MESON_ARGS=-Dfortran_std=none"
) else (
	set "MESON_ARGS=%MESON_ARGS% -Dfortran_std=none"
)

%PYTHON% -m pip install . --no-deps --no-build-isolation -vv
