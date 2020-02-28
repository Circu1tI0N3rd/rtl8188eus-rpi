# RTL8188EUS cross compilation setup for Raspberry Pi
_Note: also works for other kernel modules_

** Slightly more important note: if you can improve the script, please open an issue to let me know, thanks! **

## INTRO:
This is my setup to compile a Raspberry Pi usable driver for my TP-LINK TL-WN725N USB WiFi dongle (mine used RTL8188EUS IC). (***Yes, the included driver in Raspbian sucks!***)

## BUILD INSTRUCTION:

__Disclamer: ONLY compile on Linux (not macOS due to Raspberry Pi tools limitations)__

### INSTALL NECESSARY PACKAGES:

"sudo" is your best friend:

```
sudo apt-get update
sudo apt-get install git bc bison flex libssl-dev make libc6-dev libncurses5-dev
```

### INITIALIZE:

```
git clone https://github.com/Circu1tI0N3rd/rtl8188eus-rpi
cd rtl8188eus-rpi
git submodules update --init
```

Take your time as RPi kernel source is quite large!
Then, make sure the script is executable:

```
chmod +x compile.sh
```

### UASGE:

Run "./compile.sh" without arguments:

```
Usage: ./compile.sh <rpi_kernel_type>

Arg <rpi_kernel_type>:
    - "kernel"  :   For Pi 1, Pi Zero, Pi Zero W, or Compute Module.
    - "kernel7" :   For Pi 2, Pi 3, Pi 3+, or Compute Module 3.
    - "kernel7l"    :   For Raspberry Pi 4.
```

_As for kernel version:_ if you're unsure, use the default branch name of [raspberrypi/linux](https://github.com/raspberrypi/linux)

## REFERENCES:
- [Raspberry Pi kernel building instruction](https://www.raspberrypi.org/documentation/linux/kernel/building.md)

## LICENSE:
Use it whatever you want! Just read the script included to know how to do the same for other kernel modules you want to put on your Pi.