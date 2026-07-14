---
name: flow-design
description: >
  Phase 2 of the flow pipeline. Convert an approved requirement into a system design that FE and BE agree
  on, runs, matches the UI/UX, and is built to extend later — producing a spec, domain model, and a
  tracer-bullet implementation plan. Use after flow-intake, or when the user says "flow-design",
  "thiết kế hệ thống", "lên kiến trúc", "chuyển requirement sang design cho dev".
---

# flow-design — Thiết kế hệ thống (SPEC + PLAN)

Mục tiêu: từ scope đã chốt → **thiết kế FE↔BE khớp nhau, chạy được, đúng UI/UX, và dễ mở rộng**, kèm spec +
domain model + plan cắt lát để build. Chưa viết code.

## 1. Spec (mattpocock to-spec)
Tổng hợp (KHÔNG phỏng vấn lại) thành spec theo template, dùng đúng từ vựng domain, tôn trọng ADR vùng liên quan:
- **Problem** (góc nhìn user) · **Solution** (góc nhìn user) · **User Stories** (liệt kê "As an X, I want Y,
  so that Z", đầy đủ) · **Implementation Decisions** · **Testing Decisions** (test hành vi ngoài, module nào,
  seam nào) · **Out of Scope** · **Notes**.
- **Không nhét file path / code** (mau lỗi thời) — trừ snippet cốt lõi rút từ prototype (state machine / schema / type).

## 2. Domain model (mattpocock domain-modeling) — living doc
- `CONTEXT.md` = **glossary thuần** (không chi tiết impl). 1 repo → root `CONTEXT.md`; nhiều context →
  `CONTEXT-MAP.md` trỏ tới `src/<ctx>/CONTEXT.md`. Tạo **lazy** (chỉ khi có gì để ghi), cập nhật **inline** ngay
  khi một thuật ngữ được chốt (không gom lô).
- Format term: `**Term**:` định nghĩa 1–2 câu (nó LÀ gì) + `_Avoid_:` các từ đồng nghĩa nên tránh. Opinionated:
  chọn một từ, còn lại cho vào Avoid. Chỉ thuật ngữ đặc thù dự án.
- **ADR** (`docs/adr/NNNN-slug.md`, đánh số tăng dần) chỉ khi **cả 3**: khó đảo ngược **và** bất ngờ nếu thiếu
  ngữ cảnh **và** là kết quả một trade-off thật.

## 3. Kiến trúc cho mở rộng (mattpocock codebase-design)
- Thiết kế **module sâu**: nhiều hành vi sau một interface nhỏ ở một **seam** sạch. Tránh module nông
  (interface to, impl mỏng).
- **Deletion test**: xóa thử module — độ phức tạp biến mất (pass-through, nên gộp) hay tái xuất ở N caller (đáng giữ)?
- "Interface là mặt test" — muốn test xuyên qua nó = sai hình dạng. **Một adapter = seam giả định; hai = seam thật**
  (đừng thêm seam khi chưa có gì biến thiên).
- Tách vocab **domain** (CONTEXT.md) vs **kiến trúc** (module/interface/depth/seam/adapter/leverage/locality).

## 4. Review kiến trúc (gstack plan-eng-review)
Áp các pattern eng-manager: **blast-radius**, boring-by-default (giới hạn "innovation token"), **strangler-fig**
(đổi tăng dần), Conway's law (FE/BE team ↔ contract), tách **essential vs accidental complexity**,
"make the change easy, then make the easy change". Liệt kê **edge case** đầy đủ và **test plan** (đường code nào
được phủ, đâu cần E2E). Với mỗi phát hiện đáng kể → nêu và để user quyết (đừng nhét âm thầm vào doc).

## 5. Contract FE↔BE tường minh
Ghi rõ **hợp đồng** giữa FE và BE của chính project (REST / GraphQL / gRPC / RPC / SDK — tùy stack):
endpoint/method, shape request/response, mã lỗi, ai tính gì (server-computed / client-computed / mock/stub),
nguồn dữ liệu mỗi field. Nếu feature đụng phần dùng chung (shared schema / registry / package)
→ ghi chú phải rebuild/redeploy mọi consumer, nếu không FE sẽ hỏng khi gọi contract chưa tồn tại.

## 6. Plan cắt lát (mattpocock to-tickets)
Chia thành **tracer bullets**: mỗi ticket cắt **dọc** một đường mỏng-nhưng-đủ qua mọi tầng (schema→BE→FE→test),
demo/verify độc lập, vừa một context window; ghi **blocking edges** (ticket nào phải xong trước). Refactor diện rộng
→ **expand–contract** (thêm dạng mới cạnh cũ → migrate theo lô CI xanh → xóa cũ).

## Output
`docs/flow/<feature-slug>/design.md` (thiết kế hệ thống FE+BE + contract + edge/test plan), cập nhật
`CONTEXT.md`/`docs/adr/*`, và danh sách ticket cắt lát. **Xin duyệt design** trước khi sang `flow-build`.

<!-- sources: mattpocock/to-spec + domain-modeling + codebase-design + to-tickets, gstack/plan-eng-review (eng patterns, edge/coverage, confidence) @ 2026-07-14 -->
