#!/bin/bash
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

CM_ROOT="${MY_DIR}/../../.."

HELPER="${CM_ROOT}/vendor/cm/build/tools/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_COMMON=
ONLY_TARGET=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --only-common )
                ONLY_COMMON=true
                ;;
        --only-target )
                ONLY_TARGET=true
                ;;
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        lib/libnvramagentclient.so)
            add_needed libbinder_shim.so "${2}"
            ;;
    esac
}

function add_needed() {
    patchelf --print-needed "${2}" | grep -qx "${1}" || patchelf --add-needed "${1}" "${2}"
}

function sigfind() {
    od -An -v -tx1 "${2}" | tr -d ' \n' | grep -ob "${1}" | cut -d: -f1 | awk '$1 % 2 == 0 { print $1 / 2 }'
}

function sigscan() {
    local pattern="${1// /}" patch="${2// /}" file="${3}"
    local offsets

    offsets=($(sigfind "${pattern}" "${file}"))
    if [ "${#offsets[@]}" -eq 0 ] && [ "$(sigfind "${patch}${pattern:${#patch}}" "${file}" | wc -l)" -eq 1 ]; then
        return 0
    fi
    if [ "${#offsets[@]}" -ne 1 ]; then
        echo "sigscan: found ${#offsets[@]} matches in ${file}"
        return 1
    fi

    printf "$(sed 's/../\\x&/g' <<< "${patch}")" | dd of="${file}" bs=1 seek="${offsets[0]}" conv=notrunc status=none
}

function fixup_blobs() {
    local BLOB_ROOT="${CM_ROOT}/vendor/${VENDOR}/${1}/proprietary"

    for BLOB in $(cd "${BLOB_ROOT}" && find . -type f | sed 's|^\./||'); do
        if declare -F blob_fixup > /dev/null; then
            blob_fixup "${BLOB}" "${BLOB_ROOT}/${BLOB}"
        fi
        if readelf --dyn-syms -W "${BLOB_ROOT}/${BLOB}" 2> /dev/null | grep -qE " UND (lab126_|__metrics_|__vitals_)"; then
            add_needed libamazonlog.so "${BLOB_ROOT}/${BLOB}"
        fi
    done
}

if [ -z "${ONLY_TARGET}" ]; then
    # Initialize the helper for common device
    setup_vendor "${DEVICE_COMMON}" "${VENDOR}" "${CM_ROOT}" true "${CLEAN_VENDOR}"

    extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${SECTION}"
    fixup_blobs "${DEVICE_COMMON}"
fi

if [ -z "${ONLY_COMMON}" ] && [ -s "${MY_DIR}/../${DEVICE}/proprietary-files.txt" ]; then
    # Reinitialize the helper for device
    source "${MY_DIR}/../${DEVICE}/extract-files.sh"
    setup_vendor "${DEVICE}" "${VENDOR}" "${CM_ROOT}" false "${CLEAN_VENDOR}"

    extract "${MY_DIR}/../${DEVICE}/proprietary-files.txt" "${SRC}" "${SECTION}"
    fixup_blobs "${DEVICE}"
fi

"${MY_DIR}/setup-makefiles.sh"
