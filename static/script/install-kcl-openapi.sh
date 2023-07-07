#!/usr/bin/env bash

# ------------------------------------------------------------
# Copyright 2023 The KCL Authors
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

# kcl-openapi location
: ${KCL_OPENAPI_BIN_DIR:="/usr/local/bin"}

# sudo is required to copy binary to /usr/local/bin for linux
: ${USE_SUDO:="false"}

# Http request CLI
KCL_OPENAPI_HTTP_REQUEST_CLI=curl

# kcl-openapi filename
KCL_OPENAPI_CLI=kcl-openapi

KCL_OPENAPI_CLI_FILE_PATH="${KCL_OPENAPI_BIN_DIR}/${KCL_OPENAPI_CLI}"

GITHUB_ORG=kcl-lang
GITHUB_REPO=kcl-openapi

DOWNLOAD_BASE="https://github.com/$GITHUB_ORG/$GITHUB_REPO/releases/download"

# --- helper functions for logs ---
info() {
	command printf '\033[1;32mInfo\033[0m: %s\n' "$1" 1>&2
}

warn() {
	command printf '\033[1;33mWarn\033[0m: %s\n' "$1" 1>&2
}

error() {
	command printf '\033[1;31mError\033[0m: %s\n' "$1" 1>&2
}

echo_fexists() {
  [ -f "$1" ] && echo "$1"
}

getSystemInfo() {
	ARCH=$(uname -m)
	case $ARCH in
	armv7*) ARCH="arm" ;;
	aarch64) ARCH="arm64" ;;
	x86_64) ARCH="amd64" ;;
	esac

	OS=$(echo "$(uname)" | tr '[:upper:]' '[:lower:]')

	# Most linux distro needs root permission to copy the file to /usr/local/bin
	if [ "$OS" == "linux" ] || [ "$OS" == "darwin" ]; then
		if [ "$KCL_OPENAPI_BIN_DIR" == "/usr/local/bin" ]; then
			USE_SUDO="true"
		fi
	fi
}

verifySupported() {
	local supported=(darwin-amd64 linux-amd64 darwin-arm64)
	local current_os_arch="${OS}-${ARCH}"

	for osarch in "${supported[@]}"; do
		if [ "$osarch" == "$current_os_arch" ]; then
			info "Your system is ${OS}_${ARCH}"
			return
		fi
	done

	info "No prebuilt binary for ${current_os_arch}"
	exit 1
}

runAsRoot() {
	local CMD="$*"

	if [ $EUID -ne 0 ] && [ $USE_SUDO = "true" ]; then
		CMD="sudo $CMD"
	fi

	$CMD
}

checkHttpRequestCLI() {
	if type "curl" >/dev/null; then
		HTTP_REQUEST_CLI=curl
	elif type "wget" >/dev/null; then
		HTTP_REQUEST_CLI=wget
	else
		warn "Either curl or wget is required"
		exit 1
	fi
}

checkExistingKclOpenApi() {
	if [ -f "$KCL_OPENAPI_CLI_FILE_PATH" ]; then
		info "kcl-openapi is detected: ${KCL_OPENAPI_CLI_FILE_PATH}"
		info "Reinstalling kcl-openapi to ${KCL_OPENAPI_BIN_DIR}..."
	else
		info "Installing kcl-openapi ..."
	fi
}

getLatestRelease() {
    local KclOpenApiReleaseURL="https://api.github.com/repos/$GITHUB_ORG/$GITHUB_REPO/releases"
    local latest_release=""

    if [ "$HTTP_REQUEST_CLI" == "curl" ]; then
        latest_release=$(curl -s $KclOpenApiReleaseURL | grep \"tag_name\" | grep -v rc | awk 'NR==1{print $2}' |  sed -n 's/\"\(.*\)\",/\1/p')
    else
        latest_release=$(wget -q --header="Accept: application/json" -O - $KclOpenApiReleaseURL | grep \"tag_name\" | grep -v rc | awk 'NR==1{print $2}' |  sed -n 's/\"\(.*\)\",/\1/p')
    fi

    version=$latest_release
}

download() {
	LATEST_RELEASE_TAG=$1

    # kcl-openapi_0.4.3-alpha1_darwin_amd64.tar.gz
	KCL_OPENAPI_CLI_ARTIFACT="${KCL_OPENAPI_CLI}_${LATEST_RELEASE_TAG:1}_${OS}_${ARCH}.tar.gz"

	DOWNLOAD_URL="${DOWNLOAD_BASE}/${LATEST_RELEASE_TAG}/${KCL_OPENAPI_CLI_ARTIFACT}"

	# Create the temp directory
	KCL_OPENAPI_TMP_ROOT=$(mktemp -dt kcl-openapi-install-tmp)
	ARTIFACT_TMP_FILE="$KCL_OPENAPI_TMP_ROOT/$KCL_OPENAPI_CLI_ARTIFACT"

	info "Downloading $DOWNLOAD_URL ..."
	if [ "$HTTP_REQUEST_CLI" == "curl" ]; then
		curl -SL "$DOWNLOAD_URL" -o "$ARTIFACT_TMP_FILE"
	else
		wget -O "$ARTIFACT_TMP_FILE" "$DOWNLOAD_URL"
	fi

	if [ ! -f "$ARTIFACT_TMP_FILE" ]; then
		error "failed to download $DOWNLOAD_URL ..."
	fi
}

install() {
	# Decompress to tmp directory
	tar xf "$ARTIFACT_TMP_FILE" -C $KCL_OPENAPI_TMP_ROOT

	# Clean old kcl-openapi binary
	rm -rf "$KCL_OPENAPI_CLI_FILE_PATH"

	# Move binary to target path
	runAsRoot mv "$KCL_OPENAPI_TMP_ROOT/$KCL_OPENAPI_CLI" "$KCL_OPENAPI_BIN_DIR"

	# Verify installation
	if [ $? -eq 0 ] && [ -f "$KCL_OPENAPI_CLI_FILE_PATH" ]; then
		info "kcl-openapi installed into $KCL_OPENAPI_CLI_FILE_PATH successfully."
	else
		error "$KCL_OPENAPI_CLI_FILE_PATH not exists. Install failed."
	fi

	# clean tmp files
	rm -rf $KCL_OPENAPI_TMP_ROOT
}


fail_trap() {
	result=$?
	if [ "$result" != "0" ]; then
		error "Failed to install kcl-openapi, go to https://kcl-lang.io/docs/reference/cli/openapi/quick-start for more support."
	fi
	cleanup
	exit $result
}

cleanup() {
	if [[ -d "${KCL_OPENAPI_TMP_ROOT:-}" ]]; then
		rm -rf "$KCL_OPENAPI_TMP_ROOT"
	fi
}

installCompleted() {
	info "For more information on how to started, please visit: https://kcl-lang.io/docs/user_docs/guides/adopting/from_kubernetes"
}

# -----------------------------------------------------------------------------
# main
# -----------------------------------------------------------------------------
trap "fail_trap" EXIT

getSystemInfo
verifySupported
checkExistingKclOpenApi
checkHttpRequestCLI

if [ -z "$1" ]; then
	info "Getting the latest kcl-openapi ..."
	getLatestRelease
elif [[ $1 == v* ]]; then
	version=$1
else
	version=v$1
fi

download $version
install
cleanup

installCompleted
