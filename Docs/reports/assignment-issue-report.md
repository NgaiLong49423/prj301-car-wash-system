# Phân công công việc & Báo cáo Grouped Issues
**Dự án:** AutoWash Pro
**Thời gian:** 2026-07-05
**Trạng thái:** Đã cập nhật Format chuẩn mới nhất (Metadata, Checklist, Merge Rules).

## 1. Thống kê Sync GitHub Issues
- **Tổng số Grouped Issues:** 12
- **Đã cập nhật (Format chuẩn):** 12 issues (GI-01 đến GI-12)

## 2. Bảng Phân Công Công Việc Ẩn Danh

| Member | Grouped Issues phụ trách | Lý do & Scope | Reviewer Chéo (Suggested) |
| :--- | :--- | :--- | :--- |
| **Member 1** | GI-03, GI-04, GI-05 | Core logic phức tạp nhất: cộng điểm, tier review, point batch expiry. | Member 2 |
| **Member 2** | GI-06, GI-07, GI-09 | Reward redemption, voucher lifecycle, admin loyalty configuration. | Member 1 |
| **Member 3** | GI-08, GI-10, GI-11 | Admin UI shell, promotion management, reports dashboard. | Member 4 |
| **Member 4** | GI-01, GI-02, GI-12 | Auth, customer dashboard, seed data, demo flow và cleanup. | Member 3 |

## 3. Danh sách Issue & Dependency

| Group ID | GitHub | FR Cover | Size/SP/Priority/Type | Phụ trách | Dependency (Làm sau) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| GI-01 | #83 | FR-AS-01, FR-AS-02, FR-AS-27 | M / 5 / High / Feature | Member 4 | None |
| GI-02 | #84 | FR-AS-03, FR-AS-04, FR-AS-05, FR-AS-06, FR-AS-13 | L / 8 / Medium / Feature | Member 4 | GI-01 |
| GI-03 | #41 | FR-AS-07, FR-AS-08, FR-AS-09, FR-AS-10, FR-AS-28 | L / 13 / High / Core | Member 1 | GI-01 |
| GI-04 | #42 | FR-AS-11 | M / 5 / High / Core | Member 1 | GI-03 |
| GI-05 | #44 | FR-AS-12 | M / 5 / High / Core | Member 1 | GI-03 |
| GI-06 | #43 | FR-AS-14 | M / 5 / High / Core | Member 2 | GI-04, GI-05 |
| GI-07 | #85 | FR-AS-15, FR-AS-16 | M / 8 / High / Core | Member 2 | GI-06 |
| GI-08 | #86 | FR-AS-17, FR-AS-26 | M / 5 / Medium / Admin | Member 3 | GI-01 |
| GI-09 | #45 | FR-AS-18, FR-AS-19, FR-AS-20 | L / 8 / High / Admin | Member 2 | GI-08 |
| GI-10 | #46 | FR-AS-21, FR-AS-23 | M / 8 / Medium / Feature | Member 3 | GI-08 |
| GI-11 | #47 | FR-AS-22 | M / 8 / Medium / Admin | Member 3 | GI-03, GI-08 |
| GI-12 | #87 | FR-AS-24, FR-AS-25, FR-AS-29, FR-AS-30 | M / 5 / High / QA | Member 4 | GI-01 -> GI-11 |

## 4. Hướng dẫn & Lưu ý quan trọng
- **Issue ưu tiên làm trước (Demo Readiness):** `GI-01` và `GI-08` cần làm đầu tiên để có bộ khung Auth và UI cho việc test. Cốt lõi hệ thống điểm là `GI-03` nên Member 1 cần ưu tiên.
- **Rủi ro ảnh hưởng lớn:** `GI-03` tác động tới cấu trúc Database transaction mạnh nhất, dễ block người khác nếu code sai. Cần Member 2 review thật kỹ. `GI-12` cần được cập nhật dần trong quá trình làm thay vì chờ tới cuối.
- **Merge Blockers:** Bất kỳ PR nào vi phạm quy tắc ở mục 14.8 trong SRS.md đều không được phép merge. Thành viên review chéo phải chịu trách nhiệm đảm bảo Acceptance Criteria của issue mình review đã được hoàn thành.
