---
name: flow
description: >
  Master orchestrator for building a feature end-to-end through 5 phases: intake -> design -> build ->
  (debug) -> ship. Re-entrant: a new feature mid-stream re-runs a scoped intake+design; a small fix jumps
  straight to debug. Use when the user says "flow", "làm tính năng từ đầu", "build feature end-to-end",
  "chạy full pipeline", or hands over a feature to take from requirement to shipped product.
---

# flow — Master pipeline (gstack ⊕ mattpocock ⊕ superpowers, viết lại tự chứa)

Điều phối 5 phase; mỗi phase là một skill riêng gọi độc lập được. Dừng ở **gate** giữa các phase để user duyệt.

```
/flow-intake  →  /flow-design  →  /flow-build  ⇄  /flow-debug  →  /flow-ship
  (nhận,          (thiết kế         (code+test)     (root-cause)    (review+verify
   chốt scope)     FE↔BE, mở rộng)                                   +ra sản phẩm)
   ▲ GATE          ▲ GATE
```

## Chạy
1. **flow-intake** — làm rõ requirement + UI/UX mơ hồ → scope doc. **GATE: user duyệt.**
2. **flow-design** — requirement → thiết kế hệ thống FE↔BE, contract, domain model, plan cắt lát. **GATE: duyệt design.**
3. **flow-build** — worktree + TDD, từng tracer-bullet ticket, dùng test runner + E2E của chính project.
4. **flow-debug** — khi có lỗi: feedback-loop → root cause → regression test. (đan xen với build)
5. **flow-ship** — review 2 trục + critical checklist → verify khớp thiết kế (bằng chứng tươi) → merge/PR → build.

## Tái nhập (đang dev mà có feature mới)
Chạy **flow-intake + flow-design phạm vi hẹp** cho feature mới, nối ticket vào plan hiện tại, tiếp tục flow-build.
Đừng nhét ngang vào code đang dở mà bỏ qua thiết kế.

## Lối tắt
- **Fix nhỏ / bug rõ nguyên nhân** (1 chỗ): nhảy thẳng **flow-debug** → fix → phần verify của **flow-ship**. Bỏ intake/design.
- **Chỉ đổi doc/config**: bỏ qua pipeline.

## Bốn Iron Laws xuyên suốt (không thương lượng)
1. Không impl trước khi design được duyệt (gate ở intake). 2. Không code khi chưa có test đỏ. 3. Không fix khi chưa
ra root cause. 4. Không tuyên bố xong khi chưa có bằng chứng chạy tươi.

## Bối cảnh project (tự phát hiện, KHÔNG giả định stack)
Trước khi chạy, đọc file cấu hình để xác định stack + layout: `package.json` / `pubspec.yaml` / `go.mod` /
`Cargo.toml` / `build.gradle` / `*.csproj` / `requirements.txt`; monorepo config (`pnpm-workspace.yaml` / `melos.yaml` /
`turbo.json` / `nx.json`); và `docs/` / `README`. Từ đó suy ra: đâu là FE, đâu là BE, test runner, tầng E2E,
cách build/deploy. `docs/` (nếu có) là source of truth. Ranh giới FE↔BE thay đổi → cập nhật cả hai phía + doc contract.
Có phần dùng chung (shared schema/registry/package) → sau khi đổi phải rebuild/redeploy mọi consumer.

<!-- sources: tổng hợp intake/design/build/debug/ship (gstack + mattpocock + superpowers) @ 2026-07-14 -->
