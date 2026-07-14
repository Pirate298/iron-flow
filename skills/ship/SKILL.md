---
name: flow-ship
description: >
  Final phase. Review the diff (standards + spec + critical checklist), verify the product matches the
  design/requirement with real evidence, then merge/PR and produce the build. Use after flow-build/debug,
  or when the user says "flow-ship", "review + merge", "ra sản phẩm", "chốt đơn".
---

# flow-ship — Review + Verify + Ra sản phẩm (REVIEW/SHIP)

## 1. Code review 2 trục (mattpocock code-review) — chạy song song, KHÔNG trộn
- **Standards**: vi phạm chuẩn repo (`CODING_STANDARDS.md`/`CONTRIBUTING.md`) + baseline **12 code-smell Fowler**
  (Mysterious Name, Duplicated Code, Feature Envy, Data Clumps, Primitive Obsession, Repeated Switches, Shotgun
  Surgery, Divergent Change, Speculative Generality, Message Chains, Middle Man, Refused Bequest). Repo docs override baseline.
- **Spec**: đối chiếu diff với requirement/spec ở `docs/flow/<feature>/` — thiếu/sai/scope-creep, trích dòng spec.
- Ghép kết quả dưới `## Standards` / `## Spec`, **không rerank chéo**.

## 2. Critical checklist (gstack review)
Rà: SQL/data-safety, race condition, **LLM output trust boundary**, shell injection, **enum/value completeness**
(đọc cả code NGOÀI diff qua Grep). **Confidence 1–10**: mỗi phát hiện phải trích được `file:line` thúc đẩy nó —
không trích được thì hạ confidence xuống 4–5 hoặc bỏ (chặn false-positive "field không tồn tại").
- Tùy chọn security pass sâu (gstack cso): FP-filter, mỗi finding kèm kịch bản khai thác cụ thể.

## 3. Nhận phản hồi review (superpowers receiving-code-review)
ĐỌC hết → hiểu (nhắc lại/hỏi) → **verify với code thật** → đánh giá cho CHÍNH codebase này → làm từng item, test từng cái.
**Cấm** "You're absolutely right!/Great point!/Thanks" — nêu thẳng cách sửa. Sai thì phản biện có lý do; mình sai thì
sửa gọn, không xin lỗi dài.

## 4. IRON LAW — Verify trước khi tuyên bố xong (superpowers verification-before-completion)
**KHÔNG tuyên bố xong/pass khi chưa chạy verify tươi trong CHÍNH message này.** Map claim→proof: tests=0 fail,
build=exit 0, "bug đã fix"=test lại triệu chứng gốc, regression=đỏ-rồi-xanh, "agent xong"=xem diff VCS,
"khớp requirement"=checklist từng dòng. Bỏ bước = nói dối.
- **Sản phẩm khớp thiết kế**: đối chiếu kết quả thật với `docs/flow/<feature>/{intake,design}.md` + UI/UX ref.
  Với mobile, exercise luồng thật (Maestro / máy thật) — không chỉ unit test.

## 5. Kết nhánh (superpowers finishing-a-development-branch)
Verify test xanh TRƯỚC. Rồi trình đúng 4 lựa chọn: (1) merge local, (2) push + tạo PR, (3) giữ nhánh, (4) hủy
(gõ "discard" xác nhận). Merge xong verify lại trên kết quả rồi mới xóa worktree/branch.

## 6. Ra bản build (Solis — KHÔNG dùng deploy web của gstack)
- Đổi shared registry → **redeploy cả api + engine + chart-service** trước.
- Bản mobile qua skill build sẵn có: `/build-apk`, `/build-aab`, `/build-ios`, `/build-debug-android`,
  `/build-debug-ios` (chúng tự nâng version + upload Drive). E2E lại bằng Maestro trước khi phát hành.
- Đổi hành vi → cập nhật `docs/` cùng PR (source of truth).

<!-- sources: mattpocock/code-review (2-axis, Fowler), gstack/review (checklist, confidence-gate) + cso, superpowers/requesting+receiving-code-review + verification-before-completion + finishing-a-development-branch @ 2026-07-14 -->
