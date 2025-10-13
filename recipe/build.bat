@echo off
setlocal enabledelayedexpansion

set PIP_NO_BUILD_ISOLATION=1
set SETUPTOOLS_SCM_PRETEND_VERSION=%PKG_VERSION%

%PYTHON% -m pip install . --no-deps --no-build-isolation -vv
