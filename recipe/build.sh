#!/bin/bash
set -euxo pipefail

export PIP_NO_BUILD_ISOLATION=1
export SETUPTOOLS_SCM_PRETEND_VERSION="${PKG_VERSION}"

${PYTHON} -m pip install . --no-deps --no-build-isolation -vv
