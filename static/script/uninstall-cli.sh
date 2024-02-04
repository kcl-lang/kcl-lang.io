#!/bin/bash

# KCL location
: ${KCL_INSTALL_DIR:="/usr/local"}

# KCL filename
KCL_CLI_FILENAME="kcl"
# KCL file path
KCL_CLI_FILE="${KCL_INSTALL_DIR}/bin/${KCL_CLI_FILENAME}"

# --- helper functions ---
info() {
    printf '\033[1;32m%s\033[0m %s\n' "$1" "$2"
}

warn() {
    printf '\033[1;33mWarning\033[0m %s\n' "$1"
}

error() {
    printf '\033[1;31mError\033[0m %s\n' "$1"
}

# Uninstall KCL
uninstall_kcl() {
    if [ -f "$KCL_CLI_FILE" ]; then
        # Remove the binary file
        sudo rm -f "$KCL_CLI_FILE"
        if [ $? -eq 0 ]; then
            info "Success" "KCL uninstalled from $KCL_CLI_FILE"
        else
            error "Failed to uninstall KCL from $KCL_CLI_FILE"
        fi
    else
        warn "KCL is not installed in $KCL_CLI_FILE"
    fi
}

# Remove modifications from user's profile
remove_profile_modifications() {
    detected_profile=$(detectProfile "$(basename $SHELL)" "$(uname -s)")
    if [ -n "$detected_profile" ]; then
        info "Profile" "Removing modifications from $detected_profile"
        sed -i.bak '/kcl-lang.io/d' "$detected_profile"
        if [ $? -eq 0 ]; then
            info "Success" "Profile modifications removed"
        else
            error "Failed to remove profile modifications"
        fi
        rm -f "${detected_profile}.bak"
    else
        warn "No user profile found."
    fi
}

# Detect user's profile
detectProfile() {
    local shell_name="$1"
    local uname="$2"

    case "$shell_name" in
        bash)
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
            # Fall back to checking for profile file existence
            local profiles
            case $uname in
                Darwin)
                    profiles=("$HOME/.bash_profile" "$HOME/.bashrc")
                    ;;
                *)
                    profiles=("$HOME/.bashrc" "$HOME/.bash_profile")
                    ;;
            esac

            for profile in "${profiles[@]}"; do
                echo_fexists "$profile" && break
            done
            ;;
    esac
}

# Check if file exists and echo it
echo_fexists() {
    [ -f "$1" ] && echo "$1"
}

# Main uninstallation process
uninstall() {
    uninstall_kcl
    remove_profile_modifications
}

# Execute uninstallation
uninstall
