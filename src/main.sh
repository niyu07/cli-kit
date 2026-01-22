#!/bin/sh

BASE="$HOME/.cli-kit"
mkdir -p "$BASE"

DATE=$(date +%F)

case "$1" in
  memo)
    DIR="${2:-default}"
    mkdir -p "$BASE/$DIR"

    FILE="$BASE/$DIR/$DATE.md"

    if [ ! -f "$FILE" ]; then
      echo "# Write a title" > "$FILE"
      echo "" >> "$FILE"
    fi

    nvim "$FILE"
    ;;

  list)
    for dir in "$BASE"/*; do
      [ -d "$dir" ] || continue
      echo "[$(basename "$dir")]"

      for file in "$dir"/*.md; do
        [ -f "$file" ] || continue
        date=$(basename "$file" .md)
        title=$(sed -n '1s/^# //p' "$file")
        [ -z "$title" ] && title="(no title)"
        echo "  $date - $title"
      done
    done
    ;;

  open)
	  TMP=$(mktemp)
    i=1
    for dir in "$BASE"/*; do
      [ -d "$dir" ] || continue
      echo "[$(basename "$dir")]"

      for file in "$dir"/*.md; do
        [ -f "$file" ] || continue

        date=$(basename "$file" .md)
        title=$(sed -n '1s/^# //p' "$file")
        [ -z "$title" ] && title="(no title)"

        echo "$i) $date - $title"
        FILES="$FILES
$file"
        i=$((i + 1))
      done
    done

    echo "Select a number:"
    read num

    TARGET=$(echo "$FILES" | sed -n "${num}p")

    if [ -z "$TARGET" ]; then
      echo "No such number"
      exit 1
    fi

    nvim "$TARGET"
    ;;

  *)
    echo "Usage:"
    echo "  cli-kit memo [file name]"
    echo "  cli-kit list"
    echo "  cli-kit open"
    ;;

esac
