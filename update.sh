#!/bin/bash
# STE OS Updating script

echo "This is STE OS Update script..."

UPDATE_TO_DIR="/home/ste"

UPDATE_FROM_DIR="/home/ste/ste-update"

echo "Rsyncing the new install over the current install, skipping any other mounts."

rsync -c -a -x --exclude='ste-update' --exclude='steapp/userdata/' --exclude='*.db' --exclude='uploads/' --exclude='printer_version' "${UPDATE_FROM_DIR}/" "${UPDATE_TO_DIR}/"

# TODO: Remove in the next update!!!
# rm "$UPDATE_TO_DIR/steapp/cluster.db"

chmod +x "$UPDATE_TO_DIR/steapp/panel/ru.stereotech.steapp"
chmod +x "$UPDATE_TO_DIR/steapp/STEApp"

#Copy firmware to the USB Mass storage in order to be installed on STE Board
MASS_STORAGE_MOUNT="/home/ste/uploads/SD"
#Prepare needed config
SERIAL_NUMBER="$(cat /home/ste/printer_version)"
PRINTER_HOSTNAME="$(cat /home/ste/printer_hostname)"
PRINTER_MODEL=$(echo $SERIAL_NUMBER | cut -c 1-6)
MANUFACTURING_WEEK=$(echo $SERIAL_NUMBER | cut -c 7-8)
MANUFACTURING_YEAR=$(echo $SERIAL_NUMBER | cut -c 9-10)
echo "Serial number: $SERIAL_NUMBER | Model: $PRINTER_MODEL"
echo "Manufacturing date: week $MANUFACTURING_WEEK | year $MANUFACTURING_YEAR"
cp "$UPDATE_TO_DIR/smoothie-build/configs/$PRINTER_MODEL-$MANUFACTURING_YEAR-$MANUFACTURING_WEEK-config.txt" "$MASS_STORAGE_MOUNT/config.txt"

#copy firmware
cp "$UPDATE_TO_DIR/smoothie-build/main.bin" "$MASS_STORAGE_MOUNT/firmware.bin"

/usr/bin/sudo /bin/sed -i "s/ST-AAA/$PRINTER_HOSTNAME/g" /etc/hostname
/usr/bin/sudo /bin/sed -i "s/ST-111/$PRINTER_HOSTNAME/g" /etc/hostname
/usr/bin/sudo /bin/sed -i "s/ST-AAA/$PRINTER_HOSTNAME/g" /etc/hosts
/usr/bin/sudo /bin/sed -i "s/ST-111/$PRINTER_HOSTNAME/g" /etc/hosts

echo "Update complete"
