#! /bin/sh

BASE="$HOME/.cli-kit"
mkdir -p "$BASE"

case "$1" in
	memo )
		FILE="$BASE/$(data +%F).md"
		nvim "$FILE"
		;;
	*)
		echo "使い方"
		echo "cli-kit memo"
		;;
esac
