# k2p-qmk-mouse-mode

Custom QMK keymap for the Keychron K2 Pro (ANSI, RGB).

## Features

- CapsLock: tap for Escape, hold for a mouse layer (works in both Mac and Windows mode)
- Mouse layer: `hjkl` move, `yuio` scroll, `m , .` left/right/middle click
- RGB: static pale turquoise on boot, top-right direct toggle key disabled, Fn+toggle still works
- Fix for the bluetooth code failing to build on newer gcc, applied automatically

## Setup (one time)

Install the QMK CLI:

```
uv tool install qmk --with appdirs --with argcomplete --with colorama \
  --with dotty-dict --with hid --with hjson --with "jsonschema>=4" \
  --with "milc>=1.4.2" --with pygments --with pyserial --with pyusb --with pillow
```

Install the ARM toolchain (Arch):

```
sudo pacman -S git arm-none-eabi-gcc arm-none-eabi-binutils arm-none-eabi-newlib dfu-util
```

## Build

```
./build.sh
```

First run clones Keychron's QMK fork into `~/development/qmk_firmware_keychron`, applies the patches in `patches/`, and compiles. Later runs just compile.

## Flash

1. Plug the keyboard in with a USB-C cable
2. Flip the mode switch to "Off"
3. Hold Esc
4. Flip the switch to "Cable" while still holding Esc
5. Run:

```
./build.sh flash
```

## Files

- `keyboards/keychron/k2_pro/ansi/rgb/keymaps/custom/` - the keymap
- `patches/` - fixes applied to the cloned QMK fork before building
- `qmk.json` - marks this repo as a QMK external userspace
- `build.sh` - clones the framework if missing, patches it, compiles or flashes
