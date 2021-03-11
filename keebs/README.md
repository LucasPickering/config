# Keyboards

This README holds instructions for using/flashing each of my keyboards.

## BDN9

This uses QMK firmware. The keymap is stored at `./qmk_firmware/keyboards/keebio/bdn9/keymaps/lucaspickering/keymap.c`. Make any changes necessary to that file, then see [QMK Firmware](#qmk-firmware) for flashing instructions.

## CU80

[See here](https://maz0r.github.io/cu80-flashguide/) for flashing instructions. Using VIA+ANSI firmware.

**To enter bootloader:** Hold `Fn + Space` during bootup

### Keybinds

| Keystroke    | Function        |
| ------------ | --------------- |
| Fn+Space     | Toggle LEDs     |
| Fn+F9        | LED Mode        |
| Fn+F10       | Incr Hue        |
| Fn+F11       | Incr Sat        |
| Fn+F12       | Incr Brightness |
| Fn+Shift+F10 | Decr Hue        |
| Fn+Shift+F11 | Decr Sat        |
| Fn+Shift+F12 | Decr Brightness |

## Ducky One 2

### Keybinds

| Keystroke  | Function          |
| ---------- | ----------------- |
| Fn+1-6     | Profiles          |
| Fn+F10     | LED Mode          |
| Fn+NumLock | Toggle mouse mode |

### Record Macro

**This doesn't work on Profile 1**

- Fn+Ctrl for 3 seconds
- Press bound key
- Press target key(s)
- Fn+Ctrl to finish

## NerDy TKL

TODO

## XD84

- Download instructions/tools [here](https://drive.google.com/file/d/0B36cphsDCP8Zc3RvLWItQ2lVdVE/view)
- Install the necessary driver
  - Hold magnet to bottom/front of KB (around the left end of the spacebar)
  - Open Zadig, it should list "ATm32U4DFU"
  - Install the driver (keyboard will stop working)
  - Re-plug KB
- Open/edit layout [here](http://www.keyboard-layout-editor.com/#/gists/03b8102322a96b6b2a6b63a1a39867ba)
  - Make sure to save it if you change it
- Flash new firmware
  - Go to kai.tkg.io in the special Chrome
  - Set keyboard to Kimera
  - Click Config and set to XD84
  - Set Layer Mode to "Simple", then paste in the KLE link from above
  - Set Fn actions as needed
  - Hold magnet to KB again
  - Burn button on kai.tkg.io should turn green - click it

[For more info](https://geekhack.org/index.php?topic=82693.0)

## QMK Firmware

Some keyboards use QMK firmware, which makes it pretty easy to customize and flash. Each of those keyboards has a keymap that lives in the `./qmk_firmware` submodule. This submodule is pulled from [a fork](https://github.com/LucasPickering/qmk_firmware), so feel free to make changes to it.

To flash, follow [the instructions here](https://docs.qmk.fm/#/newbs_flashing).

TODO if you follow these steps, add any more info here that might be helpful.
