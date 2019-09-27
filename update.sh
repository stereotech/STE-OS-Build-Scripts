#!/bin/bash
# STE OS Updating script

echo "This is STE OS Update script..."

UPDATE_TO_DIR="/home/ste"

UPDATE_FROM_DIR="/home/ste/ste-update"

echo "Rsyncing the new install over the current install, skipping any other mounts."

rsync -c -a -x --exclude='ste-update' --exclude='steapp/userdata/' --exclude='*.db' --exclude='uploads/' --exclude='printer_version' "${UPDATE_FROM_DIR}/" "${UPDATE_TO_DIR}/"

chmod +x "$UPDATE_TO_DIR/steapp/panel/ru.stereotech.steapp"
#Copy firmware to the USB Mass storage in order to be installed on STE Board
MASS_STORAGE_MOUNT="/home/ste/uploads/SD"
#Prepare needed config
SERIAL_NUMBER="$(cat /home/ste/printer_version)"
PRINTER_MODEL=$(echo $SERIAL_NUMBER | cut -c 1-6)
echo "Serial number: $SERIAL_NUMBER | Model: $PRINTER_MODEL"
cp "$UPDATE_TO_DIR/smoothie-build/configs/$PRINTER_MODEL-config.txt" "$MASS_STORAGE_MOUNT/config.txt"

#copy firmware
cp "$UPDATE_TO_DIR/smoothie-build/main.bin" "$MASS_STORAGE_MOUNT/firmware.bin"

echo "Update complete"
