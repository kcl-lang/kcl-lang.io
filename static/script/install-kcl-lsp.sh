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

# @Warning: This script will be deprecated in KCL v0.8.0.

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
KCL_CLI_FILENAME=kcl-language-server
# KCL file path
KCL_CLI_FILE=${KCL_INSTALL_DIR}/bin/${KCL_CLI_FILENAME}
# KCL Home dir
KCLVM_HOME_DIR=${KCL_INSTALL_DIR}

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

isMuslLinux() {
    [ "$OS" = "linux" ] || return 1

    if [ -f "/etc/alpine-release" ]; then
        return 0
    fi

    if type "ldd" > /dev/null 2>&1; then
        local ldd_version
        ldd_version=$(ldd --version 2>&1 || true)
        case "$ldd_version" in
            *musl*) return 0 ;;
        esac
    fi

    return 1
}

ensureMuslDependencies() {
    [ "$OS" = "linux-musl" ] || return 0

    if [ -e "/lib/libgcc_s.so.1" ] || [ -e "/usr/lib/libgcc_s.so.1" ]; then
        return 0
    fi

    if ! type "apk" > /dev/null 2>&1; then
        warn "The musl build requires libgcc_s.so.1. Install libgcc manually if the language server fails to start."
        return 0
    fi

    info "Installing" "libgcc runtime dependency for Alpine Linux"
    if ! runAsRoot apk add --no-cache libgcc > /dev/null; then
        error "Failed to install libgcc automatically. Please run 'apk add --no-cache libgcc' and retry."
        exit 1
    fi
}

getSystemInfo() {
    ARCH=$(uname -m)
    case $ARCH in
        armv7*) ARCH="arm";;
        aarch64) ARCH="arm64";;
        x86_64) ARCH="amd64";;
    esac

    OS=$(echo `uname`|tr '[:upper:]' '[:lower:]')
    if isMuslLinux; then
        OS="linux-musl"
    fi

    # Most linux distro needs root permission to copy the file to /usr/local/
    if [[ "$OS" == linux* || "$OS" == "darwin" ]] && [ "$KCL_INSTALL_DIR" == "/usr/local" ]; then
        USE_SUDO="true"
    fi
}

verifySupported() {
    releaseTag=$1
    local supported=(darwin-amd64 darwin-arm64 linux-amd64 linux-arm64 linux-musl-amd64 linux-musl-arm64)
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
        $KCL_CLI_FILE version
        echo -e "Reinstalling KCL into ${KCL_CLI_FILE} ...\n"
    fi
}

getLatestRelease() {
    # We try three strategies, in order of robustness:
    #
    #   1. Follow the HTML redirect of /releases/latest. No API rate limit,
    #      and GitHub's redirect target is already the latest non-draft /
    #      non-prerelease release — so no client-side filtering needed.
    #   2. Hit the REST /releases/latest endpoint. Subject to the 60-req/hr
    #      unauthenticated rate limit, and returns 404 if every release is
    #      a prerelease (kcl-lang/kcl is fine, but be defensive). Setting
    #      GITHUB_TOKEN raises the quota to 5000 req/hr — the CI workflows
    #      pass it automatically.
    #   3. Scan the /releases list. Same rate-limit caveat as (2); the
    #      awk/sed pipeline is brittle so this is a last resort.
    #
    # Each layer only runs if the previous one yielded an empty result.
    local org="$GITHUB_ORG" repo="$GITHUB_REPO"
    local latest_release=""
    local -a auth_header=()
    if [ -n "${GITHUB_TOKEN:-}" ]; then
        auth_header=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
    fi

    # --- (1) HTML redirect ----------------------------------------------------
    if [ "$KCL_HTTP_REQUEST_CLI" == "curl" ]; then
        # -s silent, -S still show errors, -L follow redirects,
        # -o /dev/null discard body, -w print the final URL after redirects.
        latest_release=$(curl -sSL -o /dev/null -w '%{url_effective}' \
            "https://github.com/${org}/${repo}/releases/latest" 2>/dev/null \
            | sed -n 's:.*/tag/\(v\?[0-9][A-Za-z0-9._-]*\).*:\1:p' \
            | head -n1)
    else
        # wget: -S print response headers, --max-redirect=0 do not follow
        # redirects, -O /dev/null discard body. The 30x Location header on
        # stderr carries the final tag URL.
        latest_release=$(wget -S --max-redirect=0 -q \
            "https://github.com/${org}/${repo}/releases/latest" \
            -O /dev/null 2>&1 \
            | grep -i '^  Location:' \
            | tail -n1 \
            | sed -n 's:.*/tag/\(v\?[0-9][A-Za-z0-9._-]*\).*:\1:p')
    fi

    # --- (2) REST /releases/latest -------------------------------------------
    if [ -z "$latest_release" ]; then
        local api_response
        if [ "$KCL_HTTP_REQUEST_CLI" == "curl" ]; then
            api_response=$(curl -sS "${auth_header[@]}" "https://api.github.com/repos/${org}/${repo}/releases/latest" 2>/dev/null)
        else
            api_response=$(wget -q "${auth_header[@]}" --header="Accept: application/json" \
                -O - "https://api.github.com/repos/${org}/${repo}/releases/latest" 2>/dev/null)
        fi

        # GitHub errors come back as JSON like {"message":"..."} with no
        # tag_name field. Detect those before parsing so we don't silently
        # pick up an empty string.
        if [ -n "$api_response" ] \
           && ! echo "$api_response" | grep -q '"message"' \
           && ! echo "$api_response" | grep -qi 'rate limit'; then
            latest_release=$(echo "$api_response" \
                | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
                | head -n1)
        fi
    fi

    # --- (3) Legacy list-based fallback ----------------------------------------
    if [ -z "$latest_release" ]; then
        if [ "$KCL_HTTP_REQUEST_CLI" == "curl" ]; then
            latest_release=$(curl -s "${auth_header[@]}" "https://api.github.com/repos/${org}/${repo}/releases" \
                | grep '\"tag_name\"' | grep -v 'rc' \
                | head -n1 \
                | sed -n 's/.*\"tag_name\"[[:space:]]*:[[:space:]]*\"\(v\?[^\"]*\)\".*/\1/p')
        else
            latest_release=$(wget -q "${auth_header[@]}" --header="Accept: application/json" -O - \
                "https://api.github.com/repos/${org}/${repo}/releases" \
                | grep '\"tag_name\"' | grep -v 'rc' \
                | head -n1 \
                | sed -n 's/.*\"tag_name\"[[:space:]]*:[[:space:]]*\"\(v\?[^\"]*\)\".*/\1/p')
        fi
    fi

    ret_val=$latest_release
}

downloadFile() {
    LATEST_RELEASE_TAG=$1

    # Defense-in-depth: the upstream caller (main) already guards against an
    # empty tag, but if the brittle JSON parser in `getLatestRelease` ever
    # silently fails AND the upstream guard is bypassed, we'd build a
    # malformed URL like `…/releases/download//kcl-language-server--<os>-<arch>.tar.gz`
    # and wget/curl would happily save GitHub's 404 HTML page to disk, producing
    # the confusing "Unrecognized archive format" tar error.
    if [ -z "$LATEST_RELEASE_TAG" ]; then
        error "Empty release tag passed to downloadFile."
        info "This usually means the GitHub release JSON could not be parsed."
        info "Try a specific stable version, e.g.:"
        info "  curl -fsSL https://kcl-lang.io/script/install-kcl-lsp.sh | bash -s -- 0.11.2"
        exit 1
    fi

    NEW_ARTIFACT="kcl-language-server-${LATEST_RELEASE_TAG}-${OS}-${ARCH}.tar.gz"
    OLD_ARTIFACT="kclvm-${LATEST_RELEASE_TAG}-${OS}-${ARCH}.tar.gz"
    DOWNLOAD_BASE="https://github.com/${GITHUB_ORG}/${GITHUB_REPO}/releases/download"

    # Create the temp directory
    KCL_TMP_ROOT=$(mktemp -dt kcl-install-XXXXXX)

    # Prefer the per-binary release published since v0.13.0. Fall back to the
    # legacy combined kclvm tarball for older releases that don't ship the
    # per-binary asset yet.
    NEW_URL="${DOWNLOAD_BASE}/${LATEST_RELEASE_TAG}/${NEW_ARTIFACT}"
    info "Probing $NEW_URL ..."
    if probeUrl "$NEW_URL"; then
        info "Downloading $NEW_URL ..."
        KCL_CLI_ARTIFACT="$NEW_ARTIFACT"
        KCL_TARBALL_LAYOUT="new"
        ARTIFACT_TMP_FILE="$KCL_TMP_ROOT/$KCL_CLI_ARTIFACT"
        if [ "$KCL_HTTP_REQUEST_CLI" == "curl" ]; then
            # -f makes curl fail on HTTP errors instead of saving the error page.
            curl -f -SsL "$NEW_URL" -o "$ARTIFACT_TMP_FILE"
        else
            wget -q -O "$ARTIFACT_TMP_FILE" "$NEW_URL"
        fi
    else
        DOWNLOAD_URL="${DOWNLOAD_BASE}/${LATEST_RELEASE_TAG}/${OLD_ARTIFACT}"
        info "New asset not available, falling back to $DOWNLOAD_URL ..."
        KCL_CLI_ARTIFACT="$OLD_ARTIFACT"
        KCL_TARBALL_LAYOUT="legacy"
        ARTIFACT_TMP_FILE="$KCL_TMP_ROOT/$KCL_CLI_ARTIFACT"
        if [ "$KCL_HTTP_REQUEST_CLI" == "curl" ]; then
            curl -f -SsL "$DOWNLOAD_URL" -o "$ARTIFACT_TMP_FILE"
        else
            wget -q -O "$ARTIFACT_TMP_FILE" "$DOWNLOAD_URL"
        fi
    fi

    if [ ! -s "$ARTIFACT_TMP_FILE" ]; then
        error "Failed to download ${NEW_URL} or ${DOWNLOAD_URL:-$NEW_URL} ..."
        info "Try a specific stable version, e.g.:"
        info "  curl -fsSL https://kcl-lang.io/script/install-kcl-lsp.sh | bash -s -- 0.11.2"
        exit 1
    else
        info "Successful to download $ARTIFACT_TMP_FILE"
    fi
}

probeUrl() {
    local url="$1"
    if [ "$KCL_HTTP_REQUEST_CLI" == "curl" ]; then
        local httpstatus
        httpstatus=$(curl -sSLI -o /dev/null -w "%{http_code}" "$url" || echo "000")
        [ "$httpstatus" = "200" ]
    else
        wget -q --spider "$url"
    fi
}

isReleaseAvailable() {
    LATEST_RELEASE_TAG=$1

    DOWNLOAD_BASE="https://github.com/${GITHUB_ORG}/${GITHUB_REPO}/releases/download"
    NEW_URL="${DOWNLOAD_BASE}/${LATEST_RELEASE_TAG}/kcl-language-server-${LATEST_RELEASE_TAG}-${OS}-${ARCH}.tar.gz"
    OLD_URL="${DOWNLOAD_BASE}/${LATEST_RELEASE_TAG}/kclvm-${LATEST_RELEASE_TAG}-${OS}-${ARCH}.tar.gz"

    probeUrl "$NEW_URL" || probeUrl "$OLD_URL"
}

installFile() {
    # Validate that the artifact is actually a gzipped tar before unpacking.
    # GitHub returns 404/5xx pages on missing assets, and wget happily writes
    # them to disk — so a non-404-detecting HTTP client yields a file that
    # isn't gzip at all. `tar -tzf` is the most portable sniff: it parses
    # both the gzip wrapper and the tar header, and exits non-zero on either
    # failure. We intentionally do NOT silence errors here so the diagnostic
    # reaches the user.
    if ! tar -tzf "$ARTIFACT_TMP_FILE" >/dev/null 2>&1; then
        rm -f "$ARTIFACT_TMP_FILE"
        error "Downloaded artifact is not a valid gzipped tar archive."
        error "The release asset for ${OS}/${ARCH} in version ${LATEST_RELEASE_TAG:-<unknown>} may be missing."
        info "Try a specific stable version, e.g.:"
        info "  curl -fsSL https://kcl-lang.io/script/install-kcl-lsp.sh | bash -s -- 0.11.2"
        exit 1
    fi

    tar xf $ARTIFACT_TMP_FILE -C $KCL_TMP_ROOT

    # The per-binary release (v0.13.0+) ships the executable at the tarball
    # root; older releases wrap it inside a kclvm/ directory.
    local bin_path
    if [ "${KCL_TARBALL_LAYOUT:-legacy}" = "new" ]; then
        bin_path="$KCL_TMP_ROOT/$KCL_CLI_FILENAME"
    else
        bin_path="$KCL_TMP_ROOT/kclvm/bin/$KCL_CLI_FILENAME"
    fi

    if [ ! -f "$bin_path" ]; then
        error "Failed to unpack KCL language server executable."
        exit 1
    fi

    # Copy the binary into the target installation directory.
    info "Copy the kcl language server binary $bin_path into the target installation directory $KCL_INSTALL_DIR"
    runAsRoot cp -f "$bin_path" $KCL_INSTALL_DIR/bin

    if [ -f "$KCL_CLI_FILE" ]; then
        ensureMuslDependencies
        updateProfile "$KCLVM_HOME_DIR" && info "Finished" "kcl-language-server installed into $KCL_INSTALL_DIR/bin successfully."
        # Check the KCL CLI version
        chmod +x $KCL_INSTALL_DIR/bin/kcl-language-server
        runAsRoot $KCL_INSTALL_DIR/bin/kcl-language-server version
    else 
        error "Failed to install KCL language server into $KCL_CLI_FILE"
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
            info "The KCL PATH string is"
            info $path_str
            command printf "$path_str" >> "$detected_profile"
        else
            warn "Your profile ($detected_profile) already mentions kcl language server and has not been changed."
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
        error "Failed to install KCL language server"
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
    echo -e "\nPlease add ${KCL_INSTALL_DIR}/bin into your PATH"
    echo -e "Remeber run the command source ~/.bash_profile or source ~/.bashrc to ensure your PATH is effective"
    echo -e "Reopen a terminal and execute 'kcl-language-server version' to ensure successful installation"
    echo -e "\nTo get started with KCL language server, please visit https://kcl-lang.io/docs/user_docs/getting-started/kcl-quick-start"
}

# -----------------------------------------------------------------------------
# main
# -----------------------------------------------------------------------------
trap "fail_trap" EXIT

getSystemInfo
checkHttpRequestCLI

if [ -z "$1" ]; then
    echo "Getting the latest KCL language server ..."
    getLatestRelease
else
    ret_val=v$1
fi

if [ -z "$ret_val" ]; then
    error "The KCL language server version is not found."
    error "Possible causes:"
    error "  - GitHub API rate limit hit (60 req/hr for unauthenticated requests)"
    error "  - Network or DNS issue reaching github.com / api.github.com"
    error "  - No stable release has been published in ${GITHUB_ORG}/${GITHUB_REPO} yet"
    info "Workaround: install a specific stable version, e.g.:"
    info "  curl -fsSL https://kcl-lang.io/script/install-kcl-lsp.sh | bash -s -- 0.11.2"
    exit 1
fi

verifySupported $ret_val
checkExistingKCL

info "Find the latest KCL language server version $ret_val"

downloadFile $ret_val
installFile
cleanup

installCompleted
