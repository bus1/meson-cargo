#!/bin/bash

#
# Cargo Dist Integration
#
# This scripts runs during `meson-dist` and takes care of vendoring the Cargo
# dependencies just like the custom `vendor` target. However, it is designed
# to use `MESON_DIST_ROOT` as provided by `meson-dist`.
#

set -eo pipefail

#
# Input Variable Declarations
#

MCARGO_BIN_CARGO=${1}
MCARGO_VENDOR_DIR=${2}
MCARGO_MANIFEST_PATH=${3}

#
# Helper Functions
#

failexit() { printf "==> ERROR: $1\n" "${@:2}"; exit 1; } >&2

#
# Verify Arguments
#

if [[ -z ${MCARGO_BIN_CARGO} ]] ; then
        failexit '%s: missing bin-cargo argument' "${0##*/}"
elif [[ -z ${MCARGO_VENDOR_DIR} ]] ; then
        failexit '%s: missing vendor-dir argument' "${0##*/}"
elif [[ -z ${MCARGO_MANIFEST_PATH} ]] ; then
        failexit '%s: missing manifest path argument' "${0##*/}"
fi

#
# Vendor Dependencies
#

${MCARGO_BIN_CARGO} \
        vendor \
                --locked \
                --manifest-path "${MCARGO_MANIFEST_PATH}" \
                --no-delete \
                --versioned-dirs \
                -- \
                "${MESON_DIST_ROOT}/${MCARGO_VENDOR_DIR}" \
                >/dev/null
echo >&2 "(Cargo configuration output suppressed)"
