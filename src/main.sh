#!/bin/bash

BASE="$HOME/.cli-kit"
mkdir -p "$BASE"

DATE=$(date +%F)

show_help() {
  cat << 'EOF'
cli-kit

Usage:
  cli-kit help              Show this help
  cli-kit memo [folder]     Create or edit today's memo
  cli-kit list              Show memo list
  cli-kit open              Open a memo by number

Examples:
  cli-kit memo work
  cli-kit list
  cli-kit open
EOF
}

case "$1" in
  help)
    show_help
    ;;

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
        echo "$file" >> "$TMP"
        i=$((i + 1))
      done
    done

    echo "Select a number:"
    read num

    TARGET=$(sed -n "${num}p" "$TMP")
    rm -f "$TMP"

    if [ -z "$TARGET" ]; then
      echo "Invalid number"
      exit 1
    fi

    nvim "$TARGET"
    ;;

  *)
    show_help
    ;;
esac

