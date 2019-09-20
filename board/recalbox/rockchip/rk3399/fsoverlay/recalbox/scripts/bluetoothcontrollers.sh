#!/bin/bash

HCIATTACH=/usr/bin/hciattach
SERIAL=$(awk '/^Serial/{ print $3 }' /proc/cpuinfo)
B1=${SERIAL:10:2}
B2=${SERIAL:12:2}
B3=${SERIAL:14:2}
BDADDR=$(printf b8:27:eb:%02x:%02x:%02x $((0x$B1 ^ 0xaa)) $((0x$B2 ^ 0xaa)) $((0x$B3 ^ 0xaa)))

if [ $(cat /proc/device-tree/model | grep -c "RockPro") -ne 0 ]; then
    echo 0 > /sys/class/rfkill/rfkill0/state
    sleep 1
    echo 1 > /sys/class/rfkill/rfkill0/state
    sleep 1
    $HCIATTACH /dev/ttyS0 bcm43xx 1500000 flow nosleep
elif [ $(cat /proc/device-tree/model | grep -c "ROCK PI 4B") -ne 0 ]; then
    echo 0 > /sys/class/rfkill/rfkill0/state
    sleep 1
    echo 1 > /sys/class/rfkill/rfkill0/state
    sleep 1
    $HCIATTACH /dev/ttyS0 bcm43xx 1500000 flow nosleep
else
 if [ "$(cat /proc/device-tree/aliases/uart0)" = "$(cat /proc/device-tree/aliases/serial1)" ] ; then
   if [ "$(wc -c /proc/device-tree/soc/gpio@7e200000/uart0_pins/brcm\,pins | cut -f 1 -d ' ')" = "16" ] ; then
     $HCIATTACH /dev/serial1 bcm43xx 3000000 flow - $BDADDR
   else
     $HCIATTACH /dev/serial1 bcm43xx 921600 noflow - $BDADDR
   fi
 else
   $HCIATTACH /dev/serial1 bcm43xx 460800 noflow - $BDADDR
 fi
fi
