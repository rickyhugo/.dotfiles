#!/bin/bash

# NOTE: sony wh-1000xm5
# NOTE: run "bluetoothctl" to find the MAC address of your device.
MAC="FD:92:C5:D6:90:36"

if hcitool con | grep -q "$MAC"
then
    echo -e "disconnect $MAC \nquit" | bluetoothctl
else
    echo -e "connect $MAC \nquit" | bluetoothctl
fi
