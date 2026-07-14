#!/usr/bin/env bash
# Chỉ dùng khi TÁC GIẢ muốn tổng hợp lại từ upstream. Clone/pull 3 nguồn vào .sources/ (gitignored),
# rồi in commit mới kể từ SHA đã pin trong SOURCES.md để biết cần cập nhật skill nào.
set -euo pipefail
KIT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$KIT/.sources"; mkdir -p "$SRC"

clone_or_pull() { # $1=dir $2=url
  if [ -d "$SRC/$1/.git" ]; then git -C "$SRC/$1" pull --ff-only || true
  else git clone --depth 50 "$2" "$SRC/$1"; fi
}
clone_or_pull gstack     https://github.com/garrytan/gstack.git
clone_or_pull mattpocock https://github.com/mattpocock/skills.git

echo "=== commit mới kể từ SHA đã pin (SOURCES.md) ==="
for r in gstack mattpocock; do
  sha="$(grep -oE "\`[0-9a-f]{40}\`" "$KIT/SOURCES.md" | tr -d '`' | { [ "$r" = gstack ] && head -1 || sed -n 2p; })"
  echo "--- $r (từ ${sha:0:12}) ---"
  git -C "$SRC/$r" log --oneline "${sha}..HEAD" 2>/dev/null | head -30 || echo "  (không so được — kiểm tra SHA)"
done
echo "Nếu có thay đổi đáng kể: đọc lại skill gốc, sửa tay skills/<phase>/SKILL.md, cập nhật SHA trong SOURCES.md."
