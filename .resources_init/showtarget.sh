#!/bin/sh

TARGET=$(cat ~/.config/polybar/target)
target_icon="什"

if [ "$TARGET" != "" ]; then
	echo "%{F#ff0000}$target_icon %{F#ffffff}TARGET: $TARGET%{u-}"
else
	echo "%{F#ff0000}$target_icon%{u-}%{F-}"
fi