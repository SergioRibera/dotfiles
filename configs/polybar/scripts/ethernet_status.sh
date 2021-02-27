#!/bin/bash

echo -e "%{F#313131}歷 $(/usr/sbin/ifconfig enp3s0 2>/dev/null| grep "inet " | awk '{print $2}')%{u-}"
