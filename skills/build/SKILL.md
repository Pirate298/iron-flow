---
name: flow-build
description: >
  Phase 3 of the flow pipeline. Implement the approved design test-first, one tracer-bullet ticket at a
  time, with isolation and review, on the project's real test runners. Use after flow-design, or when the
  user says "flow-build", "code đi", "triển khai", "implement feature".
---

# flow-build — Code + Test (BUILD/TEST)

Mục tiêu: hiện thực design đã duyệt thành **code chạy được, có test**, từng lát một.

## Chuẩn bị
- **Cô lập workspace** (superpowers using-git-worktrees): làm trên nhánh/worktree riêng, không làm thẳng trên
  `main`/base. Kiểm tra baseline test xanh trước khi bắt đầu.
- Nếu chưa có plan bước-nhỏ từ `flow-design`, dựng nhanh (superpowers writing-plans): mỗi bước 1 hành động
  2–5 phút, **không placeholder** (không "TODO", "add error handling", type/hàm phải cụ thể).

## Vòng thực thi (per ticket)
Chạy từng ticket theo thứ tự blocking edges. Với mỗi ticket dùng nhịp **subagent-driven / executing-plans**:
implement → self-review → **spec-review (phải ✅)** → code-quality review → sửa → mark done. Không check-in
giữa các ticket trừ khi BLOCKED/nhập nhằng thật.

## IRON LAW — TDD (superpowers + mattpocock, giữ nguyên)
**KHÔNG viết code sản phẩm khi chưa có một test ĐỎ.** Lỡ viết code trước? **Xóa** — đừng giữ để tham khảo.
- **RED**: viết 1 test nhỏ, 1 hành vi, tên rõ. **Xem nó FAIL đúng lý do** (thiếu tính năng, không phải typo).
  Pass ngay = đang test sai chỗ.
- **GREEN**: code đơn giản nhất để pass, không thêm tính năng thừa (YAGNI). Verify: pass + test khác vẫn xanh + output sạch.
- **REFACTOR**: chỉ khi xanh; bỏ trùng lặp, không thêm hành vi. (Refactor thuộc review, không thuộc vòng test.)
- Test tốt = **kiểm hành vi qua public interface**, đọc như spec, sống sót refactor. Test **chỉ ở seam đã chốt**.
  Tránh: test khớp impl (mock nội bộ / test private), tautological (assert tính lại chính giá trị kỳ vọng),
  horizontal (viết hết test rồi hết impl) → thay bằng **vertical slice**: 1 test → 1 impl → lặp.

## Runner của Solis
- `vitest` cho `apps/api`, `apps/engine`. `jest` (jest-expo) cho `apps/mobile`.
- Chạy typecheck thường xuyên + file test đơn lẻ thường xuyên; **full suite một lần ở cuối**.
- **E2E mobile = Maestro** (`apps/mobile/e2e/`). Thêm luồng/tính năng mới **bắt buộc** thêm/sửa flow Maestro tương ứng.
- Đổi shared registry → nhớ redeploy cả api+engine+chart-service (thuộc flow-ship, nhưng thiết kế test tính từ đây).

## Song song (tùy chọn)
Nếu có nhiều ticket **độc lập** (không share state, không sửa cùng file) → dispatch nhiều agent song song
(superpowers dispatching-parallel-agents), rồi gộp + chạy full suite.

## Output
Code trên nhánh riêng, mỗi ticket có test đi kèm, full suite xanh. Lỗi khó → sang `flow-debug`. Xong → `flow-ship`.

<!-- sources: superpowers/using-git-worktrees + writing-plans + subagent-driven-development/executing-plans + test-driven-development + dispatching-parallel-agents, mattpocock/implement + tdd @ 2026-07-14 -->
