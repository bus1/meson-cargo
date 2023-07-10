#!/bin/bash

#
# Cargo Build Integration
#
# This script effectively calls `cargo build` and copies all created artifacts
# over into an output directory. It sets configuration options suitable for
# integration into MesonBuild.
#

set -eo pipefail

#
# Input Variable Declarations
#
# All these variables can be set by the caller. Suitable defaults are provided
# for most, but a caller is advised to set all of them unconditionally.
#

MCARGO_BIN_CARGO=${MCARGO_BIN_CARGO:-"cargo"}
MCARGO_BIN_CP=${MCARGO_BIN_CP:-"cp"}
MCARGO_BIN_JQ=${MCARGO_BIN_JQ:-"jq"}
MCARGO_CRATE_TYPE=${MCARGO_CRATE_TYPE:-""}
MCARGO_OFFLINE=${MCARGO_OFFLINE:-"no"}
MCARGO_PROFILE=${MCARGO_PROFILE:-""}
MCARGO_TARGET=${MCARGO_TARGET:-""}
MCARGO_TARGET_DIR=${MCARGO_TARGET_DIR:-""}
MCARGO_TARGETS=${MCARGO_TARGETS:-"--lib"}
MCARGO_VENDOR_DIR=${MCARGO_VENDOR_DIR:-"."}

MCARGO_OUTPUT_DIR=${1}
MCARGO_MANIFEST_PATH=${2}

#
# Helper Functions
#

failexit() { printf "==> ERROR: $1\n" "${@:2}"; exit 1; } >&2

#
# Verify Arguments
#

if [[ -z ${MCARGO_TARGET_DIR} ]] ; then
        failexit '%s: missing target directory directive' "${0##*/}"
elif [[ -z ${MCARGO_TARGETS} ]] ; then
        failexit '%s: missing target selection argument' "${0##*/}"
elif [[ -z ${MCARGO_OUTPUT_DIR} ]] ; then
        failexit '%s: missing output directory argument' "${0##*/}"
elif [[ -z ${MCARGO_MANIFEST_PATH} ]] ; then
        failexit '%s: missing manifest path argument' "${0##*/}"
fi

#
# Run Cargo Build
#
# Run `cargo rustc` with all specified parameters. Use `--message-format=json`
# to get formatted output from the build, which we can later parse.
#
# If offline mode is requested, we use vendored sources as specified by the
# caller. Usually, this requires the caller to invoke `vendor.sh` or
# `cargo-vendor` before.
#
# Since `--crate-type` cannot be used when building anything but `--lib`, we
# have to invoke Cargo twice if it is used with other targets.
#

_MCARGO_DEF_USED="no"
_MCARGO_DEF_ARGS=()
[[ ${MCARGO_OFFLINE} == "no" ]] || _MCARGO_DEF_ARGS+=("--offline")
[[ ${MCARGO_OFFLINE} == "no" ]] || _MCARGO_DEF_ARGS+=("--config=source.crates-io.replace-with=\"vendored-sources\"")
[[ ${MCARGO_OFFLINE} == "no" ]] || _MCARGO_DEF_ARGS+=("--config=source.vendored-sources.directory=\"${MCARGO_VENDOR_DIR}\"")
[[ -z ${MCARGO_PROFILE} ]] || _MCARGO_DEF_ARGS+=("--profile=${MCARGO_PROFILE}")
[[ -z ${MCARGO_TARGET} ]] || _MCARGO_DEF_ARGS+=("--target=${MCARGO_TARGET}")

_MCARGO_LIB_USED="no"
_MCARGO_LIB_ARGS=("${_MCARGO_DEF_ARGS[@]}")
[[ -z ${MCARGO_CRATE_TYPE} ]] || _MCARGO_LIB_ARGS+=("--crate-type=${MCARGO_CRATE_TYPE}")

IFS=',' read -r -a _MCARGO_TARGETS <<< "${MCARGO_TARGETS}"
for target in "${_MCARGO_TARGETS[@]}" ; do
        if [[ ${target} == "--lib" ]] ; then
                _MCARGO_LIB_USED="yes"
                _MCARGO_LIB_ARGS+=("${target}")
        else
                _MCARGO_DEF_USED="yes"
                _MCARGO_DEF_ARGS+=("${target}")
        fi
done

_MCARGO_LIB_JSON="{}"
if [[ ${_MCARGO_LIB_USED} == "yes" ]] ; then
        _MCARGO_LIB_JSON=$( \
                ${MCARGO_BIN_CARGO} \
                        rustc \
                                --manifest-path "${MCARGO_MANIFEST_PATH}" \
                                --message-format=json \
                                --target-dir "${MCARGO_TARGET_DIR}" \
                                "${_MCARGO_LIB_ARGS[@]}" \
        )
fi

_MCARGO_DEF_JSON="{}"
if [[ ${_MCARGO_DEF_USED} == "yes" ]] ; then
        _MCARGO_DEF_JSON=$( \
                ${MCARGO_BIN_CARGO} \
                        rustc \
                                --manifest-path "${MCARGO_MANIFEST_PATH}" \
                                --message-format=json \
                                --target-dir "${MCARGO_TARGET_DIR}" \
                                "${_MCARGO_DEF_ARGS[@]}" \
        )
fi

#
# Copy Artifacts
#
# Parse the JSON output of cargo-build, collect all output artifacts and copy
# them safely into the output directory.
#
# Note: We keep the artifact-list as json-encoded strings so the bash-iterator
#       is safe even regarding whitespace and control characters, as they are
#       required to be escaped in json.
#

_MCARGO_FILTER=''
_MCARGO_FILTER+='map('
_MCARGO_FILTER+='  select('
_MCARGO_FILTER+='    .reason == "compiler-artifact"'
_MCARGO_FILTER+='  )'
_MCARGO_FILTER+=')'
_MCARGO_FILTER+='| .[].filenames[]'

_MCARGO_DEF_FILES=$(${MCARGO_BIN_JQ} --slurp "${_MCARGO_FILTER}" <<<"${_MCARGO_DEF_JSON}")
_MCARGO_LIB_FILES=$(${MCARGO_BIN_JQ} --slurp "${_MCARGO_FILTER}" <<<"${_MCARGO_LIB_JSON}")

while IFS= read -r line ; do
        [[ -n ${line} ]] && ${MCARGO_BIN_CP} "$(${MCARGO_BIN_JQ} -r . <<<"${line}")" "${MCARGO_OUTPUT_DIR}/"
done <<<"${_MCARGO_DEF_FILES}"

while IFS= read -r line ; do
        [[ -n ${line} ]] && ${MCARGO_BIN_CP} "$(${MCARGO_BIN_JQ} -r . <<<"${line}")" "${MCARGO_OUTPUT_DIR}/"
done <<<"${_MCARGO_LIB_FILES}"

exit 0
