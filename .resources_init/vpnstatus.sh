#!/bin/sh

IFACE=$(ip address | grep tun0 | grep inet | awk '{print $2}' |awk -F/ '{print $1}')
htb_icon=""

if [ "$IFACE" != "" ]; then
	echo "%{F#1bbf3e}$htb_icon %{F#e2ee6a}$IFACE%{u-}"
else
	echo "%{F#1bbf3e}$htb_icon%{u-}%{F-}"
fi