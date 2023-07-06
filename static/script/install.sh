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

# KCL location
: ${KCL_INSTALL_DIR:="/usr/local"}

# sudo is required to copy binary to KCL_INSTALL_DIR for linux
: ${USE_SUDO:="false"}

# Http request CLI
KCL_HTTP_REQUEST_CLI=curl

# GitHub Organization and repo name to download release
GITHUB_ORG=kcl-lang
GITHUB_REPO=kcl

# KCL filename
KCL_CLI_FILENAME=kcl
# KCL file path
KCL_CLI_FILE=${KCL_INSTALL_DIR}/kclvm/bin/${KCL_CLI_FILENAME}
# KCL Home dir
KCLVM_HOME_DIR=${KCL_INSTALL_DIR}/kclvm

# --- helper functions for logs ---
info() {
    local action="$1"
    local details="$2"
    command printf '\033[1;32m%12s\033[0m %s\n' "$action" "$details" 1>&2
}

warn() {
    command printf '\033[1;33mWarn\033[0m: %s\n' "$1" 1>&2
}

error() {
    command printf '\033[1;31mError\033[0m: %s\n' "$1" 1>&2
}

request() {
    command printf '\033[1m%s\033[0m\n' "$1" 1>&2
}

eprintf() {
    command printf '%s\n' "$1" 1>&2
}

bold() {
    command printf '\033[1m%s\033[0m' "$1"
}

# If file exists, echo it
echo_fexists() {
    [ -f "$1" ] && echo "$1"
}

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
            info "Your system is ${OS}_${ARCH}"
            return
        fi
    done

    error "No prebuilt binary for ${current_osarch}"
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
        error "Either curl or wget is required"
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

    info "Downloading $DOWNLOAD_URL ..."
    if [ "$KCL_HTTP_REQUEST_CLI" == "curl" ]; then
        curl -SsL "$DOWNLOAD_URL" -o "$ARTIFACT_TMP_FILE"
    else
        wget -q -O "$ARTIFACT_TMP_FILE" "$DOWNLOAD_URL"
    fi

    if [ ! -f "$ARTIFACT_TMP_FILE" ]; then
        error "Failed to download $DOWNLOAD_URL ..."
        exit 1
    else
        info "Scucessful to download $DOWNLOAD_URL"
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
        error "Failed to unpack KCL executable."
        exit 1
    fi

    # Copy temp kclvm folder into the target installation directory.
    info "Copy the kclvm folder $tmp_kclvm_folder into the target installation directory $KCL_INSTALL_DIR"
    runAsRoot cp -rf $tmp_kclvm_folder $KCL_INSTALL_DIR

    if [ -f "$KCL_CLI_FILE" ]; then
        updateProfile "$KCLVM_HOME_DIR" && info "Finished" "$KCL_CLI_FILENAME installed into $KCL_INSTALL_DIR/kclvm/bin successfully."
        # Check the KCL CLI version
        runAsRoot $KCL_CLI_FILE -V
    else 
        error "Failed to install KCL into $KCL_CLI_FILE"
        exit 1
    fi
}

updateProfile() {
    install_dir="$1"
    profile_install_dir=$(echo "$install_dir" | sed "s:^$HOME:\$HOME:")
    detected_profile=$(detectProfile "$(basename $SHELL)" "$(uname -s)")
    path_str="$(buildPathStr "$detected_profile" "$profile_install_dir")"

    info "Editing user profile ($detected_profile) with the profile install dir $profile_install_dir"

    if [ -z "${detected_profile-}" ]; then
        error "No user profile found."
        eprintf "Tried \$PROFILE ($PROFILE), ~/.bashrc, ~/.bash_profile, ~/.zshrc, ~/.profile, and ~/.config/fish/config.fish."
        eprintf "You can either create one of these and try again or add this to the appropriate file:"
        eprintf "$path_str"
        return 1
    else
        if ! command grep -qc 'KCLVM_HOME' "$detected_profile"; then
            info "The KCLVM PATH string is"
            info $path_str
            command printf "$path_str" >> "$detected_profile"
        else
            warn "Your profile ($detected_profile) already mentions kcl and has not been changed."
        fi
    fi
}

detectProfile() {
    local shell_name="$1"
    local uname="$2"

    if [ -f "$PROFILE" ]; then
        info "Current profile: $PROFILE"
        return
    fi

    # try to detect the current shell
    case "$shell_name" in
    bash)
        # Shells on macOS default to opening with a login shell, while Linuxes
        # default to a *non*-login shell, so if this is macOS we look for
        # `.bash_profile` first; if it's Linux, we look for `.bashrc` first. The
        # `*` fallthrough covers more than just Linux: it's everything that is not
        # macOS (Darwin). It can be made narrower later if need be.
        case $uname in
        Darwin)
            echo_fexists "$HOME/.bash_profile" || echo_fexists "$HOME/.bashrc"
            ;;
        *)
            echo_fexists "$HOME/.bashrc" || echo_fexists "$HOME/.bash_profile"
            ;;
        esac
        ;;
    zsh)
        echo "$HOME/.zshrc"
        ;;
    fish)
        echo "$HOME/.config/fish/config.fish"
        ;;
    *)
        # Fall back to checking for profile file existence. Once again, the order
        # differs between macOS and everything else.
        local profiles
        case $uname in
        Darwin)
            profiles=(.profile .bash_profile .bashrc .zshrc .config/fish/config.fish)
            ;;
        *)
            profiles=(.profile .bashrc .bash_profile .zshrc .config/fish/config.fish)
            ;;
        esac

        for profile in "${profiles[@]}"; do
            echo_fexists "$HOME/$profile" && break
        done
        ;;
    esac
}

# generate shell code to source the loading script and modify the path for the input profile
buildPathStr() {
    local profile="$1"
    local profile_install_dir="$2"

    if [[ $profile =~ \.fish$ ]]; then
        # fish uses a little different syntax to modify the PATH
        cat <<END_FISH_SCRIPT

string match -r "kclvm" "\$PATH" > /dev/null; or set -gx PATH "\$profile_install_dir/bin" \$PATH

END_FISH_SCRIPT
    else
        # bash and zsh
        cat <<END_BASH_SCRIPT

export PATH="$profile_install_dir/bin:\$PATH"

END_BASH_SCRIPT
    fi
}

fail_trap() {
    result=$?
    if [ "$result" != "0" ]; then
        error "Failed to install KCL"
        info "For support, go to https://kcl-lang.io"
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
    echo -e "Remeber run the command source ~/.bash_profile or source ~/.bashrc to ensure your PATH is effective"
    echo -e "Reopen a terminal and execute `kcl -h` to ensure successful installation"
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

# echo "The KCL version is $ret_val"
# 
# if [ -z "$ret_val" ]; then
#     echo "The latest version of KCL is not found. It may be due to network reasons. You can re-execute the installation script and try again."
#     exit 1
# fi

info "Find the latest KCL version $ret_val"

downloadFile $ret_val
installFile
cleanup

installCompleted
