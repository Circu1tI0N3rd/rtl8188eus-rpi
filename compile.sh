#!/bin/bash
#CURR_DIR=`dirname $0`
CURR_DIR=`pwd`

usage () {
	echo "Usage: $0 <rpi_kernel_type> <rpi_kernel_version>"
	printf "\nArg <rpi_kernel_type>:\n\
	- \"kernel\"	:	For Pi 1, Pi Zero, Pi Zero W, or Compute Module.\n\
	- \"kernel7\"	:	For Pi 2, Pi 3, Pi 3+, or Compute Module 3.\n\
	- \"kernel7l\"	:	For Raspberry Pi 4.\n\n"
	printf "Arg <rpi_kernel_version>:\
	Execute \`uname -r\` on your running Raspbian.\n"
}

missing () {
	echo "Missing submodule $1, exiting..."
	exit 1
}

if [ ! -d linux ]; then
	missing "RPi kernel src"
elif [ ! -d tools ]; then
	missing "RPi compiling toolchain"
elif [ ! -d rtl8188eus ]; then
	missing "Aircrack-ng's RTL8188EUS kernel module src"
fi

if [ $# -ne 2 ]; then
	usage
	exit 1
fi

if [[ $(uname -m) == *x86_64* ]]; then
	export PATH=$PATH:$CURR_DIR/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin
else
	# Assuming i386 system then
	export PATH=$PATH:$CURR_DIR/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin
fi

KERNEL=$1
KVER=$2

print_target_debug() {
	printf "Target boards: Raspberry Pi "
	echo $1	
}

echo "Initializing kernel src..."
# Create config for appropriate destination system
cd $CURR_DIR/linux
if [ $KERNEL == "kernel" ]; then
	print_target_debug "1, Pi Zero, Pi Zero W, and Compute Module"
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcmrpi_defconfig
elif [ $KERNEL == "kernel7" ]; then
	print_target_debug "2, Pi 3, Pi 3+, and Compute Module 3"
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
elif [ $KERNEL == "kernel7l" ]; then
	print_target_debug "4"
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig
else
	usage
	printf "\n"
	echo "ERROR: Inappropriate kernel type, exiting..."
	exit 1
fi

# Build objects in the 'scripts' folder
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- scripts

echo "Entering $CURR_DIR/rtl8188eus..."
# Switch to kernel module src folder
cd $CURR_DIR/rtl8188eus

echo "Building kernel module..."
# Build the kernel module
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- KVER=$KVER KSRC=$CURR_DIR/linux

# Exit with last make return code
exit $?