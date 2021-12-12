# Keyboards

This README holds instructions for using/flashing each of my keyboards.

## BDN9

This uses QMK firmware. The keymap is stored at `./qmk_firmware/keyboards/keebio/bdn9/keymaps/lucaspickering/keymap.c`. Make any changes necessary to that file, then see [QMK Firmware](#qmk-firmware) for flashing instructions.

## CU80

[See here](https://maz0r.github.io/cu80-flashguide/) for flashing instructions. Using VIA+ANSI firmware. Once QMK is flashed, all further configuration is done in VIA.

**To enter bootloader:** Hold `ESC` during bootup

VIA keybinding config is stored in this repo.

### Keybinds

| Keystroke | Function        |
| --------- | --------------- |
| Fn+Space  | Toggle LEDs     |
| Fn+F9     | LED Mode        |
| Fn+Ins    | Incr Hue        |
| Fn+Del    | Decr Hue        |
| Fn+Home   | Incr Sat        |
| Fn+End    | Decr Sat        |
| Fn+PgUp   | Incr Brightness |
| Fn+PgDn   | Decr Brightness |

## QMK Firmware

Some keyboards use QMK firmware, which makes it pretty easy to customize and flash. Each of those keyboards has a keymap that lives in the `./qmk_firmware` submodule. This submodule is pulled from [a fork](https://github.com/LucasPickering/qmk_firmware), so feel free to make changes to it.

To flash, follow [the instructions here](https://docs.qmk.fm/#/newbs_flashing).

TODO if you follow these steps, add any more info here that might be helpful.
