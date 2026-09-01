# Termux Lock

Bash startup lock for Termux with password setup/change, salted SHA-256 verification, terminal UI, interruption handling, status, and uninstall.

## Install
```bash
git clone https://github.com/YOUR_USERNAME/termux-lock.git
cd termux-lock
bash install.sh
```

Restart Termux.

## Commands
```bash
termux-lock
termux-lock passwd
termux-lock status
termux-lock uninstall
```

## Security limitation
This is a shell startup lock, not an Android system-level App Lock. Someone with sufficient access to the device/Termux files can remove or bypass a shell startup script. Use Android's built-in App Lock too when available.
