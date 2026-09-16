#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QMK_HOME="${QMK_HOME:-$HOME/development/qmk_firmware_keychron}"
KEYBOARD="keychron/k2_pro/ansi/rgb"
KEYMAP="custom"

if ! command -v qmk >/dev/null 2>&1; then
    echo "qmk CLI not found. Install it first, e.g.:"
    echo "  uv tool install qmk --with appdirs --with argcomplete --with colorama \\"
    echo "    --with dotty-dict --with hid --with hjson --with 'jsonschema>=4' \\"
    echo "    --with 'milc>=1.4.2' --with pygments --with pyserial --with pyusb --with pillow"
    exit 1
fi

if [ ! -d "$QMK_HOME" ]; then
    echo "Cloning Keychron's QMK fork into $QMK_HOME ..."
    git clone --branch wireless_playground https://github.com/Keychron/qmk_firmware.git "$QMK_HOME"
    (cd "$QMK_HOME" && git submodule update --init --recursive)
fi

for patch in "$REPO_DIR"/patches/*.patch; do
    [ -e "$patch" ] || continue
    if ! git -C "$QMK_HOME" apply --reverse --check "$patch" >/dev/null 2>&1; then
        echo "Applying $(basename "$patch") ..."
        git -C "$QMK_HOME" apply "$patch"
    fi
done

qmk config user.qmk_home="$QMK_HOME" >/dev/null
qmk config user.overlay_dir="$REPO_DIR" >/dev/null

cd "$QMK_HOME"

case "${1:-compile}" in
    compile)
        qmk compile -kb "$KEYBOARD" -km "$KEYMAP"
        ;;
    flash)
        qmk flash -kb "$KEYBOARD" -km "$KEYMAP"
        ;;
    *)
        echo "Usage: $0 [compile|flash]"
        exit 1
        ;;
esac
