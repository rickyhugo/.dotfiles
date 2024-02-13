#!/bin/bash

# NOTE: sony wh-1000xm5
# NOTE: run "bluetoothctl" to find the MAC address of your device.
MAC="88:C9:E8:16:D8:B3"

if hcitool con | grep -q "$MAC"
then
    echo -e "disconnect $MAC \nquit" | bluetoothctl
else
    echo -e "connect $MAC \nquit" | bluetoothctl
fi
