#!/data/data/com.termux/files/usr/bin/bash
set -u
BASE="$HOME/.termux-lock"; CFG="$BASE/config"; HASH="$CFG/password.sha256"; SALT="$CFG/salt"
[ -f "$BASE/ui.sh" ] && . "$BASE/ui.sh"
hashpw(){ printf '%s%s' "$2" "$1" | sha256sum | awk '{print $1}'; }
setup(){ mkdir -p "$CFG"; local a b s; while :; do printf 'New password: '; IFS= read -r -s a || exit 1; printf '\nConfirm password: '; IFS= read -r -s b || exit 1; printf '\n'; [ -n "$a" ] || { echo 'Password cannot be empty.'; continue; }; [ "$a" = "$b" ] || { echo 'Passwords do not match.'; continue; }; s="$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')"; printf '%s' "$s" > "$SALT"; hashpw "$a" "$s" > "$HASH"; chmod 600 "$SALT" "$HASH"; unset a b; echo 'Password saved.'; return; done; }
verify(){ local a s e; s="$(cat "$SALT")"; e="$(cat "$HASH")"; printf 'Password: '; IFS= read -r -s a || return 1; printf '\n'; [ "$(hashpw "$a" "$s")" = "$e" ]; }
lock(){ trap 'echo; echo "Locked. Enter password."' INT TSTP QUIT; local n=0; while :; do ui_lock 2>/dev/null || clear; if verify; then trap - INT TSTP QUIT; clear; echo 'Access granted.'; return; fi; n=$((n+1)); ui_error "$n" 2>/dev/null || { clear; echo "ACCESS DENIED — attempt $n"; }; done; }
case "${1:-lock}" in passwd|password|set-password) setup;; lock) [ -f "$HASH" ] || setup; lock;; status) [ -f "$HASH" ] && echo 'Termux Lock: configured' || echo 'Termux Lock: not configured';; uninstall) exec "$BASE/uninstall.sh";; help|-h|--help) echo 'Usage: termux-lock [lock|passwd|status|uninstall]';; *) echo 'Unknown command'; exit 2;; esac
