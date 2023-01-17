#!/usr/bin/env bash

# ------------------------------------------------------------
# Copyright 2022 The KCL Authors
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Reference: https://github.com/dapr/cli/tree/master/install
# ------------------------------------------------------------

# KCL location
: ${KCL_INSTALL_DIR:="/usr/local"}

# sudo is required to copy binary to KCL_INSTALL_DIR for linux
: ${USE_SUDO:="false"}

# Http request CLI
KCL_HTTP_REQUEST_CLI=curl

# GitHub Organization and repo name to download release
GITHUB_ORG=KusionStack
GITHUB_REPO=KCLVM

# KCL filename
KCL_CLI_FILENAME=kcl
# KCL file path
KCL_CLI_FILE=${KCL_INSTALL_DIR}/kclvm/bin/${KCL_CLI_FILENAME}

getSystemInfo() {
    ARCH=$(uname -m)
    case $ARCH in
        armv7*) ARCH="arm";;
        aarch64) ARCH="arm64";;
        x86_64) ARCH="amd64";;
    esac

    OS=$(echo `uname`|tr '[:upper:]' '[:lower:]')

    # Most linux distro needs root permission to copy the file to /usr/local/
    if [[ "$OS" == "linux" || "$OS" == "darwin" ]] && [ "$KCL_INSTALL_DIR" == "/usr/local" ]; then
        USE_SUDO="true"
    fi
}

verifySupported() {
    releaseTag=$1
    local supported=(darwin-amd64 darwin-arm64 linux-amd64 linux-arm linux-arm64)
    local current_osarch="${OS}-${ARCH}"

    for osarch in "${supported[@]}"; do
        if [ "$osarch" == "$current_osarch" ]; then
            echo "Your system is ${OS}_${ARCH}"
            return
        fi
    done

    echo "No prebuilt binary for ${current_osarch}"
    exit 1
}

runAsRoot() {
    local CMD="$*"

    if [ $EUID -ne 0 -a $USE_SUDO = "true" ]; then
        CMD="sudo $CMD"
    fi

    $CMD
}

checkHttpRequestCLI() {
    if type "curl" > /dev/null; then
        KCL_HTTP_REQUEST_CLI=curl
    elif type "wget" > /dev/null; then
        KCL_HTTP_REQUEST_CLI=wget
    else
        echo "Either curl or wget is required"
        exit 1
    fi
}

checkExistingKCL() {
    if [ -f "$KCL_CLI_FILE" ]; then
        # Check the KCL CLI version
        echo -e "\nKCL is detected:"
        $KCL_CLI_FILE -V
        echo -e "Reinstalling KCL into ${KCL_CLI_FILE} ...\n"
    fi
}

getLatestRelease() {
    local KCLReleaseUrl="https://api.github.com/repos/${GITHUB_ORG}/${GITHUB_REPO}/releases"
    local latest_release=""

    if [ "$KCL_HTTP_REQUEST_CLI" == "curl" ]; then
        latest_release=$(curl -s $KCLReleaseUrl | grep \"tag_name\" | grep -v rc | awk 'NR==1{print $2}' |  sed -n 's/\"\(.*\)\",/\1/p')
    else
        latest_release=$(wget -q --header="Accept: application/json" -O - $KCLReleaseUrl | grep \"tag_name\" | grep -v rc | awk 'NR==1{print $2}' |  sed -n 's/\"\(.*\)\",/\1/p')
    fi

    ret_val=$latest_release
}

downloadFile() {
    LATEST_RELEASE_TAG=$1

    KCL_CLI_ARTIFACT="kclvm-${LATEST_RELEASE_TAG}-${OS}-${ARCH}.tar.gz"
    DOWNLOAD_BASE="https://github.com/${GITHUB_ORG}/${GITHUB_REPO}/releases/download"
    DOWNLOAD_URL="${DOWNLOAD_BASE}/${LATEST_RELEASE_TAG}/${KCL_CLI_ARTIFACT}"

    # Create the temp directory
    KCL_TMP_ROOT=$(mktemp -dt kcl-install-XXXXXX)
    ARTIFACT_TMP_FILE="$KCL_TMP_ROOT/$KCL_CLI_ARTIFACT"

    echo "Downloading $DOWNLOAD_URL ..."
    if [ "$KCL_HTTP_REQUEST_CLI" == "curl" ]; then
        curl -SsL "$DOWNLOAD_URL" -o "$ARTIFACT_TMP_FILE"
    else
        wget -q -O "$ARTIFACT_TMP_FILE" "$DOWNLOAD_URL"
    fi

    if [ ! -f "$ARTIFACT_TMP_FILE" ]; then
        echo "Failed to download $DOWNLOAD_URL ..."
        exit 1
    else
        echo "Scucessful to download $DOWNLOAD_URL"
    fi
}

isReleaseAvailable() {
    LATEST_RELEASE_TAG=$1

    KCL_CLI_ARTIFACT="kclvm-${LATEST_RELEASE_TAG}-${OS}-${ARCH}.tar.gz"
    DOWNLOAD_BASE="https://github.com/${GITHUB_ORG}/${GITHUB_REPO}/releases/download"
    DOWNLOAD_URL="${DOWNLOAD_BASE}/${LATEST_RELEASE_TAG}/${KCL_CLI_ARTIFACT}"

    if [ "$KCL_HTTP_REQUEST_CLI" == "curl" ]; then
        httpstatus=$(curl -sSLI -o /dev/null -w "%{http_code}" "$DOWNLOAD_URL")
        if [ "$httpstatus" == "200" ]; then
            return 0
        fi
    else
        wget -q --spider "$DOWNLOAD_URL"
        exitstatus=$?
        if [ $exitstatus -eq 0 ]; then
            return 0
        fi
    fi
    return 1
}

installFile() {
    tar xf $ARTIFACT_TMP_FILE -C $KCL_TMP_ROOT
    local tmp_kclvm_folder=$KCL_TMP_ROOT/kclvm

    if [ ! -f "$tmp_kclvm_folder/bin/kcl" ]; then
        echo "Failed to unpack KCL executable."
        exit 1
    fi

    # Copy temp kclvm folder into the target installation directory.
    echo "Copy the kclvm folder $tmp_kclvm_folder into the target installation directory $KCL_INSTALL_DIR"
    runAsRoot cp -rf $tmp_kclvm_folder $KCL_INSTALL_DIR

    if [ -f "$KCL_CLI_FILE" ]; then
        echo "$KCL_CLI_FILENAME installed into $KCL_INSTALL_DIR/kclvm/bin successfully."
        # Check the KCL CLI version
        runAsRoot $KCL_CLI_FILE -V
    else 
        echo "Failed to install KCL into $KCL_CLI_FILE"
        exit 1
    fi
}

fail_trap() {
    result=$?
    if [ "$result" != "0" ]; then
        echo "Failed to install KCL"
        echo "For support, go to https://kcl-lang.io"
    fi
    cleanup
    exit $result
}

cleanup() {
    if [[ -d "${KCL_TMP_ROOT:-}" ]]; then
        rm -rf "$KCL_TMP_ROOT"
    fi
}

installCompleted() {
    echo -e "\nPlease add ${KCL_INSTALL_DIR}/kclvm/bin into your PATH"
    echo -e "\nTo get started with KCL, please visit https://kcl-lang.io/docs/user_docs/getting-started/kcl-quick-start"
}

# -----------------------------------------------------------------------------
# main
# -----------------------------------------------------------------------------
trap "fail_trap" EXIT

getSystemInfo
checkHttpRequestCLI

if [ -z "$1" ]; then
    echo "Getting the latest KCL ..."
    getLatestRelease
else
    ret_val=v$1
fi

verifySupported $ret_val
checkExistingKCL

echo "The KCL version is $ret_val"

if [ -z $ret_val ]; then
    echo "The latest version of KCL is not found. It may be due to network reasons. You can re-execute the installation script and try again."
    exit 1
fi

echo "Find the latest KCL version $ret_val"

downloadFile $ret_val
installFile
cleanup

installCompleted
