#!/bin/bash

#
# Cargo Vendor Integration
#
# This scripts runs as custom target and takes care of vendoring the Cargo
# dependencies for offline builds.
#

set -eo pipefail

#
# Input Variable Declarations
#
# All these variables can be set by the caller. Suitable defaults are provided
# for most, but a caller is advised to set all of them unconditionally.
#

MCARGO_BIN_CARGO=${MCARGO_BIN_CARGO:-"cargo"}
MCARGO_VENDOR_DIR=${MCARGO_VENDOR_DIR:-""}

MCARGO_MANIFEST_PATH=${1}

#
# Helper Functions
#

failexit() { printf "==> ERROR: $1\n" "${@:2}"; exit 1; } >&2

#
# Verify Arguments
#

if [[ -z ${MCARGO_VENDOR_DIR} ]] ; then
        failexit '%s: missing vendor directory directive' "${0##*/}"
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
                "${MCARGO_VENDOR_DIR}" \
                >/dev/null
echo >&2 "(Cargo configuration output suppressed)"
