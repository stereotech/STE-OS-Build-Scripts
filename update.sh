#!/bin/bash
# STE OS Updating script

echo "This is STE OS Update script..."

UPDATE_FROM_DIR="/tmp/ste-update"

UPDATE_TO_DIR="/home/ste"

echo "Rsyncing the new install over the current install, skipping any other mounts."

rsync -c -a -x --exclude='steapp/userdata/' --exclude='*.db' --exclude='uploads/' --exclude='printer_version' "${UPDATE_FROM_DIR}/" "${UPDATE_TO_DIR}/"

#Copy firmware to the USB Mass storage in order to be installed on STE Board
MASS_STORAGE_MOUNT="/home/ste/uploads/SD"
#Prepare needed config
SERIAL_NUMBER="$(cat /home/ste/printer_version)"
PRINTER_MODEL=$(echo $SERIAL_NUMBER | cut -c 6)
cp "$UPDATE_TO_DIR/smoothie-build/configs/$PRINTER_MODEL-config.txt" "$MASS_STORAGE_MOUNT/config.txt"

#copy firmware
cp "$UPDATE_TO_DIR/smoothie-build/main.bin" "$MASS_STORAGE_MOUNT/firmware.bin"

echo "Update complete"
