---
name: flow-intake
description: >
  Phase 1 of the flow pipeline. Turn a vague PO requirement + UI/UX design into a locked, approved
  scope BEFORE any system design or code. Use when starting a new feature, when the user says
  "flow-intake", "nhận requirement", "làm rõ yêu cầu", "chốt scope", or drops an unclear spec/design
  to build from.
---

# flow-intake — Nhận & làm rõ (FRAME)

Mục tiêu: từ requirement + thiết kế UI/UX (thường mơ hồ) của PO → **scope đã chốt và được user duyệt**.
Không viết code, không thiết kế hệ thống ở phase này.

## HARD GATE
Không chuyển sang thiết kế/impl cho tới khi có một **scope doc được user duyệt**. Áp dụng cả với việc
"nhỏ". Nếu yêu cầu trải nhiều hệ con độc lập → tách thành các feature con, mỗi cái chạy pipeline riêng.

## Cách hỏi (mattpocock grilling)
- Hỏi **một câu một lần**, chờ trả lời rồi mới hỏi tiếp (hỏi dồn là "bewildering"). Ưu tiên multiple-choice.
- Với mỗi câu **tự đề xuất câu trả lời khuyến nghị**.
- **Fact thì tra code, không hỏi** (đọc `apps/mobile/src/data/solis.ts`, `docs/`, code hiện có). Chỉ hỏi
  những gì là **quyết định** của user/PO.

## Sáu câu ép rõ (gstack office-hours) — hỏi câu nào cần, theo giai đoạn feature
1. **Nhu cầu thật**: ai thực sự cần cái này, đau ở đâu? (chống "market mơ hồ")
2. **Hiện trạng**: giờ user làm việc đó thế nào, trong app hay ngoài app?
3. **Cụ thể tới mức khó chịu**: nêu tên **màn cụ thể / user cụ thể** — không nói chung chung.
4. **Wedge hẹp nhất**: lát cắt nhỏ nhất mà vẫn có giá trị để ship trước?
5. **Edge case / bất ngờ**: empty state, lỗi mạng, chưa có dữ liệu chart, free vs premium?
6. **Khớp tương lai**: có kẹt gì khi mở rộng sau không?

Chống nịnh: gặp phát biểu mơ hồ / "user sẽ thích" → **đẩy lại đòi bằng chứng cụ thể**, đừng gật theo.

## Neo vào thiết kế UI/UX đã có
Thiết kế PO gửi (trong `apps/mobile/design-ref/` hoặc file PO đưa) là **source of truth cho UI**. Map từng
requirement ↔ màn/element trong design. Nêu rõ chỗ requirement và design **mâu thuẫn** để PO chốt.

## Scope (gstack plan-ceo-review)
Chốt rõ 3 mục: **In scope** · **NOT in scope** (viết ra để khỏi trôi) · **Đã có sẵn / tái dùng được**
(mock, component, endpoint hiện có). Với dev đơn lẻ, mặc định thiên **HOLD / REDUCE scope** — làm chắc lát nhỏ.

## Alternatives (BẮT BUỘC)
Đưa **2–3 hướng tiếp cận** (tối thiểu: minimal-viable + bản lý tưởng-dễ-mở-rộng, tùy chọn 1 hướng lateral),
mỗi hướng ghi Effort / Risk / Pros / Cons / Tái dùng gì. **STOP** cho user chọn.

## Output
Ghi `docs/flow/<feature-slug>/intake.md`: vấn đề (góc nhìn user) · scope in/out · tái dùng · hướng đã chọn ·
edge cases · câu hỏi còn mở cho PO. Rồi **xin user duyệt** trước khi sang `flow-design`.

<!-- sources: superpowers/brainstorming (hard-gate, 2-3 approaches, decompose), gstack/office-hours (6 forcing questions, anti-sycophancy, alternatives), gstack/plan-ceo-review (scope modes, NOT-in-scope, reuse), mattpocock/grilling (one-Q, recommend-answer, look-up-facts) @ 2026-07-14 -->
