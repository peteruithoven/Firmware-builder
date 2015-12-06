#!/bin/sh
GCC_ARM_PATH='/gcc-arm/gcc-arm-none-eabi-4_9-2015q3/bin/'
FIRMWARE_DIR="/home/Firmware"

cd $FIRMWARE_DIR/mbed

# perform remaining setup, if not setup already
if [ ! -f workspace_tools/private_settings.py ]; then 
  echo "> Performing remaining setup"
  echo "> Setting GCC path: $GCC_ARM_PATH"
  echo "GCC_ARM_PATH = \"$GCC_ARM_PATH\"" > workspace_tools/private_settings.py

  echo "> Patching mbed libraries"
  patch -p1 < ../laser/mbed.patch

  echo "> Building MBED libraries"
  python workspace_tools/build.py -m LPC1768 -t GCC_ARM -r -e -u -c

  echo "> Linking LaOSlaser as an mbed example project"
  ln -s  $FIRMWARE_DIR/laser $FIRMWARE_DIR/mbed/libraries/tests/net/protocols/
fi

echo "> Building LaosLaser"
python workspace_tools/make.py -m LPC1768 -t GCC_ARM -n laser

RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo '[ok] Build successful'

  # copy binary to shared folder
  echo "> copying bin to bin folder"
  cp -r build/test/LPC1768/GCC_ARM/laser/laser.bin /home/bin/

  # complete
  echo "> complete"
else
  echo '[error] Build failed'
fi
