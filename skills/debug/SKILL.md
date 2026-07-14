---
name: flow-debug
description: >
  Root-cause debugging phase. Force a reproducing feedback loop and find the real cause before any fix,
  then land a regression test. Use for any bug/failure/regression/slow behavior, when the user says
  "flow-debug", "diagnose", "debug this", or reports something broken/throwing/failing.
---

# flow-debug — Root-cause (DEBUG)

## IRON LAW (superpowers systematic-debugging, giữ nguyên)
**KHÔNG sửa khi chưa tìm ra root cause.** Đi hết mỗi phase trước khi sang phase sau. "Quick fix cho xong",
sửa trước khi trace = red flag → quay lại Phase 1.

## Phase 1 — Dựng feedback loop (đây MỚI là kỹ năng chính — mattpocock diagnosing-bugs)
Có một tín hiệu **pass/fail** chuyển ĐỎ đúng con bug này, trước khi làm gì khác. Thứ tự ưu tiên dựng loop:
failing test → curl/HTTP → CLI + fixture diff → headless → replay trace → harness tạm → bisection.
- Đọc lỗi/stack **đầy đủ**; `git log`/`git diff` các thay đổi gần đây (**regression → root cause nằm trong diff**).
- **Reproduce xác định**; bug không xác định thì tăng tỉ lệ tái hiện, đừng cố ép repro sạch.
- Tiêu chí xong Phase 1: **một lệnh đã chạy** vừa có thể-đỏ + xác định + nhanh + agent tự chạy được. Chưa có → **không** sang Phase 2.

## Phase 2 — Reproduce tối giản
Xác nhận đúng triệu chứng user gặp; thu nhỏ repro tới mức mọi phần còn lại đều load-bearing (cắt từng phần một).

## Phase 3 — Giả thuyết
Nêu **3–5 giả thuyết falsifiable, xếp hạng** (kèm dự đoán) TRƯỚC khi test cái nào. Đối chiếu bảng pattern
(gstack investigate): race / nil-propagation / state-corruption / integration-failure / config-drift / stale-cache.

## Phase 4 — Kiểm chứng
Một probe cho mỗi dự đoán, đổi **một biến một lúc**; ưu tiên debugger/REPL > log biên có mục tiêu. **Gắn nhãn mọi log
debug bằng prefix `[DEBUG-xxxx]`** để grep dọn một lần. Perf: đo baseline trước rồi bisect.
- **3 lần thử fail → STOP, nghi kiến trúc sai** (không phải giả thuyết sai) → cân nhắc `flow-design` lại.

## Phase 5 — Fix + regression test
Viết **regression test ĐỎ trước khi fix** (chỉ khi có seam đúng exercise được bug; không có seam → chính sự thiếu
seam đó là phát hiện → cờ cho kiến trúc). Fix **root cause, không phải triệu chứng**, diff tối thiểu. Xem test chuyển
xanh, chạy full suite. >5 file bị đụng → cảnh báo blast radius.

## Phase 6 — Dọn + post-mortem
Xóa hết `[DEBUG-...]`, prototype tạm; repro gốc đã hết; regression pass (hoặc ghi rõ seam-absence). Ghi hypothesis
đúng vào commit/PR. Hỏi **"điều gì đã ngăn được bug này?"** — nếu do kiến trúc → xử lý sau khi fix.

<!-- sources: superpowers/systematic-debugging (iron law, 4 phases), mattpocock/diagnosing-bugs (feedback-loop, [DEBUG-xxxx], hypotheses, regression-first), gstack/investigate (pattern table, 3-strike) @ 2026-07-14 -->
