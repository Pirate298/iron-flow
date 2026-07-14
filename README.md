# iron-flow

Bộ skill cho Claude Code: một **pipeline dev 5 phase** (`/flow-*`) **viết lại tổng hợp** từ điểm mạnh của
[gstack](https://github.com/garrytan/gstack), [mattpocock/skills](https://github.com/mattpocock/skills) và
[superpowers](https://github.com/obra/superpowers-marketplace). Các skill **tự chứa** (không cần `bun`, không
gọi `bin/` của gstack, không phụ thuộc plugin nào) → cài lại được trên mọi máy / project bằng một script.

## Cài

```bash
git clone git@github.com:Pirate298/iron-flow.git ~/.iron-flow
~/.iron-flow/install.sh                 # → user config: ${CLAUDE_CONFIG_DIR:-~/.claude}/skills
# hoặc cài cho riêng 1 project (như BMAD):
~/.iron-flow/install.sh --project /path/to/project     # → <project>/.claude/skills
```
Mở phiên Claude Code mới để nạp. Cài lại/ cập nhật: `git pull && ~/.iron-flow/install.sh`.

## Pipeline

| Lệnh | Phase | Làm gì |
|---|---|---|
| `/flow` | master | Điều phối cả chuỗi, có gate; tái nhập feature mới; lối tắt fix nhỏ |
| `/flow-intake` | Nhận | Requirement + UI/UX mơ hồ → scope chốt (6 forcing questions, alternatives, gate duyệt) |
| `/flow-design` | Thiết kế | Requirement → thiết kế hệ thống FE↔BE, contract, domain model (CONTEXT.md/ADR), plan cắt lát |
| `/flow-build` | Code+Test | worktree + TDD (đỏ trước), tracer-bullet, vitest/jest, E2E Maestro |
| `/flow-debug` | Debug | Feedback-loop → root cause → regression test (Iron Law: no fix without root cause) |
| `/flow-ship` | Ra sản phẩm | Review 2 trục + checklist → verify khớp thiết kế (bằng chứng tươi) → merge/PR → build |

**4 Iron Laws:** không impl trước khi design duyệt · không code khi chưa test đỏ · không fix khi chưa ra
root cause · không tuyên bố xong khi chưa verify tươi.

## Tùy biến

- Bật/tắt hay thêm skill: sửa [manifest.txt](manifest.txt) (mỗi `[area]` = một prefix `<area>-<skill>`), chạy lại `install.sh`.
- Thêm mảng mới: mở `[tên-mảng]` rồi liệt kê thư mục skill dưới `skills/`.

## Cập nhật từ upstream

Skill là bản tổng hợp (fork) — không auto-pull. Khi muốn đồng bộ lại: `dev/resync.sh` kéo 3 nguồn vào
`.sources/` (gitignored) và in commit mới kể từ SHA trong [SOURCES.md](SOURCES.md); đọc lại rồi sửa tay phase
tương ứng (footer `<!-- sources: ... -->` trong mỗi SKILL.md cho biết ăn theo skill nào).

Xem [NOTICE.md](NOTICE.md) cho attribution.
