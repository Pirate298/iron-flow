#!/usr/bin/env bash
# iron-flow installer — cài skill vào Claude Code (copy + áp prefix theo [area] + sentinel cleanup).
# Không phụ thuộc nguồn ngoài: mọi skill trong skills/ là bản tự chứa.
#
# Dùng:
#   ./install.sh                     # cài vào user config: ${CLAUDE_CONFIG_DIR:-~/.claude}/skills
#   ./install.sh --project [PATH]    # cài vào PATH/.claude/skills (mặc định PATH=$PWD)
#   ./install.sh --dir  /abs/skills  # cài vào thư mục chỉ định
set -euo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"
MANIFEST="$KIT/manifest.txt"
SENTINEL=".iron-flow-managed"

MODE="user"; PROJDIR=""; TARGET=""
while [ $# -gt 0 ]; do
  case "$1" in
    --project) MODE="project"; shift
               if [ $# -gt 0 ] && [ "${1#-}" = "$1" ]; then PROJDIR="$1"; shift; fi ;;
    --dir)     shift; TARGET="${1:-}"; shift || true ;;
    *)         shift ;;
  esac
done

if [ -z "$TARGET" ]; then
  if [ "$MODE" = "project" ]; then TARGET="${PROJDIR:-$PWD}/.claude/skills"
  else TARGET="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills"; fi
fi
mkdir -p "$TARGET"

# 1) dọn bản iron-flow cài lần trước (thư mục có sentinel)
for d in "$TARGET"/*; do
  [ -e "$d" ] || continue
  [ -f "$d/$SENTINEL" ] && rm -rf "$d"
done

# 2) cài theo manifest ([area] → prefix <area>-<skill>; dòng trước header = không prefix)
prefix=""; count=0
while IFS= read -r raw; do
  if [[ "$raw" =~ ^[[:space:]]*\[([a-zA-Z0-9_-]+)\][[:space:]]*$ ]]; then prefix="${BASH_REMATCH[1]}"; continue; fi
  line="${raw%%#*}"; line="$(printf '%s' "$line" | xargs || true)"
  [ -z "$line" ] && continue
  src="$KIT/skills/$line"; base="$(basename "$line")"
  [ -d "$src" ] || { echo "  SKIP (không thấy): $line"; continue; }
  name="${prefix:+$prefix-}$base"; dst="$TARGET/$name"
  rm -rf "$dst"; cp -RL "$src" "$dst"; touch "$dst/$SENTINEL"
  if [ -f "$dst/SKILL.md" ]; then
    awk -v n="$name" '
      /^---[ \t]*$/ { fm++ }
      (fm==1 && !done && $0 ~ /^name:/) { print "name: " n; done=1; next }
      { print }
    ' "$dst/SKILL.md" > "$dst/SKILL.md.tmp" && mv "$dst/SKILL.md.tmp" "$dst/SKILL.md"
  fi
  echo "  /$name"; count=$((count + 1))
done < "$MANIFEST"

echo "iron-flow: đã cài $count skill → $TARGET"
echo "(mở phiên Claude Code mới để nạp)"
