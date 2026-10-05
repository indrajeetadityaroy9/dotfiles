#!/bin/sh
# macOS settings that differ from Apple's defaults. chezmoi re-runs this when it changes;
# each write is skipped when the value already matches, so nothing restarts needlessly.
set -eu

restart=
pref() { # domain key type value [process to restart]; bools as true/false
    want=$4
    [ "$3" != bool ] || { [ "$4" = true ] && want=1 || want=0; } # `defaults read` prints 1/0
    [ "$(defaults read "$1" "$2" 2>/dev/null)" = "$want" ] && return
    defaults write "$1" "$2" "-$3" "$4"
    [ -z "${5:-}" ] || restart="$restart $5"
}

pref NSGlobalDomain AppleInterfaceStyle string Dark
pref com.apple.dock tilesize int 38 Dock
pref com.apple.dock show-recents bool false Dock
pref com.apple.finder FXPreferredViewStyle string clmv Finder

# shellcheck disable=SC2086 # word-split the process list
[ -z "$restart" ] || killall $restart

# Touch ID for sudo; sudo_local survives macOS updates.
grep -qs '^auth.*pam_tid\.so' /etc/pam.d/sudo_local ||
    sed 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local >/dev/null
