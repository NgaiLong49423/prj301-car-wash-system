# Phân công công việc & Báo cáo Grouped Issues

**Dự án:** AutoWash Pro  
**Phạm vi:** PRJ301 Assessment — Advance Booking & Loyalty Program  
**Thời gian cập nhật:** 2026-07-05  
**Trạng thái:** Đã điều chỉnh Story Points, dependency, deadline nội bộ, PM/Ops work và quy định review.

---

## 1. Thống kê GitHub Issues

- **Tổng số Grouped Issues:** 12
- **Issues đã sync/cập nhật:** GI-01 đến GI-12
- **Tổng Code Story Points sau điều chỉnh:** 86 SP
- **Tổng PM/Ops Story Points:** 11 SP
- **Tổng Delivery Story Points:** 97 SP

> Story Points là điểm ước lượng công sức, độ khó và rủi ro của công việc. Điểm này không chỉ tính thời gian code, mà còn tính độ phức tạp, dependency, khả năng gây lỗi và công sức kiểm tra.

---

## 2. Deadline và mốc kiểm soát nội bộ

### 2.1 Deadline chính thức

- **Deadline chính thức:** 24:00 Chủ Nhật, ngày **2026-07-19**
- Có thể hiểu thực tế là cuối ngày Chủ Nhật, tức khoảng **23:59:59 ngày 2026-07-19**.

### 2.2 Deadline review nội bộ của Leader

Dự án phải hoàn thành trước deadline chính thức ít nhất **3 ngày** để còn thời gian kiểm tra, cải thiện code, sửa lỗi và chuẩn bị demo.

- **Mốc dừng nhận review lớn:** 24:00 Thứ Năm, ngày **2026-07-16**
- Từ **00:00 Thứ Sáu, ngày 2026-07-17**, Leader không cam kết review, kiểm tra hoặc integrate các PR lớn/nộp trễ.

### 2.3 Quy định sau mốc 2026-07-16 24:00

Sau mốc này, Leader chỉ xem xét:

- bug fix nhỏ;
- sửa lỗi build/run;
- sửa lỗi giao diện nhỏ;
- sửa lỗi dữ liệu seed/demo;
- chỉnh nội dung hiển thị không ảnh hưởng logic lớn;
- cleanup nhẹ để demo ổn định.

Leader không chịu trách nhiệm nếu thành viên nộp trễ sau mốc này và PR không kịp review/merge.

### 2.4 Lưu ý về giai đoạn cải thiện code

Hoàn thành các grouped issues không có nghĩa là dự án đã sẵn sàng nộp ngay. Sau khi các issue chính hoàn thành, nhóm vẫn cần thời gian để:

- cải thiện lại code;
- dọn hardcode không cần thiết nếu có thời gian;
- sửa lỗi phát sinh khi tích hợp;
- kiểm tra lại flow demo;
- chuẩn hóa dữ liệu seed;
- kiểm tra branch/PR đã merge đúng;
- đảm bảo app chạy ổn trước khi nộp.

Vì vậy, mốc **2026-07-17 đến 2026-07-19** được giữ cho giai đoạn cải thiện, ổn định và chuẩn bị demo, không phải để bắt đầu làm feature mới.

---

## 3. Điều chỉnh Story Points

### 3.1 Code Story Points

| Group ID | GitHub Issue | Tên grouped issue | SP cũ | SP mới | Ghi chú |
|---|---:|---|---:|---:|---|
| GI-01 | #83 | Auth, Registration and Access Control | 5 | 5 | Giữ nguyên |
| GI-02 | #84 | Customer Dashboard, Loyalty Overview and History | 8 | 8 | Giữ nguyên |
| GI-03 | #41 | Booking Completion Loyalty Award | 13 | 13 | Core logic lớn nhất |
| GI-04 | #42 | Tier Review and Active 12-Month Loyalty Data | 5 | 5 | Giữ nguyên |
| GI-05 | #44 | Point Batch Expiry and Active Points Refresh | 5 | 5 | Giữ nguyên |
| GI-06 | #43 | Reward Redemption into Voucher | 5 | 5 | Giữ nguyên |
| GI-07 | #85 | Apply Voucher to Booking and Voucher Lifecycle | 8 | 8 | Giữ nguyên |
| GI-08 | #86 | Admin UI Shell and Dashboard | 5 | 5 | Giữ nguyên |
| GI-09 | #45 | Admin Loyalty Configuration Controls | 8 | 8 | Giữ nguyên |
| GI-10 | #46 | Promotion Management and Customer Promotion Inbox | 8 | 8 | Giữ nguyên |
| GI-11 | #47 | Admin Reports Dashboard | 8 | 8 | Giữ nguyên |
| GI-12 | #87 | Assessment Seed Data, Demo Flow and Scope Cleanup | 5 | 8 | Tăng vì seed/demo/cleanup cần kiểm tra nhiều luồng |

**Tổng Code SP:** 86 SP

### 3.2 Project Management / Documentation / GitHub Operations Story Points

| Work ID | Công việc | Owner | Story Points | Ghi chú |
|---|---|---|---:|---|
| PM-01 | Cập nhật SRS, phân rã grouped issues, checklist và merge rules | Ngô Gia Long / Leader | 6 | Bao gồm phân tích yêu cầu, gom FR-AS thành grouped issues, chuẩn hóa checklist |
| PM-02 | GitHub Issues sync, kiểm tra issue trùng, setup GitHub Project/labels/status | Ngô Gia Long / Leader | 3 | Bao gồm update issue cũ, tạo issue mới, xử lý duplicate/superseded |
| PM-03 | Quản lý branch workflow, PR template, review rule và điều phối merge | Ngô Gia Long / Leader | 2 | Bao gồm kiểm soát PR, nhắc reviewer, theo dõi deadline |

**Tổng PM/Ops SP:** 11 SP

### 3.3 Tổng Delivery Story Points

| Nhóm công việc | Story Points |
|---|---:|
| Code grouped issues | 86 |
| PM/Ops/Documentation/GitHub management | 11 |
| **Tổng delivery SP** | **97** |

---

## 4. Phân công công việc sau điều chỉnh

| Member | Công việc phụ trách | Code SP | PM/Ops SP | Tổng SP | Reviewer chéo đề xuất |
|---|---|---:|---:|---:|---|
| **Ngô Gia Long / Leader** | GI-03, GI-04, PM-01, PM-02, PM-03 | 18 | 11 | 29 | Phạm Hoàng Phúc |
| **Phạm Hoàng Phúc** | GI-05, GI-06, GI-07, GI-09 | 26 | 0 | 26 | Ngô Gia Long |
| **Nguyễn Trí** | GI-08, GI-10, GI-11 | 21 | 0 | 21 | Nguyễn Anh Kiệt |
| **Nguyễn Anh Kiệt** | GI-01, GI-02, GI-12 | 21 | 0 | 21 | Nguyễn Trí |

### 4.1 Lý do điều chỉnh

Ngô Gia Long / Leader đã phụ trách phân rã SRS, grouped issues, GitHub setup, branch workflow và review coordination nên cần tính thêm PM/Ops SP. Vì vậy Ngô Gia Long chỉ nhận GI-03 và GI-04, không nhận thêm GI-05 để tránh quá tải.

GI-03 vẫn do Ngô Gia Long / Leader phụ trách vì đây là core logic quan trọng nhất của Loyalty Engine. GI-04 phụ thuộc trực tiếp GI-03 nên nên đi cùng Ngô Gia Long để giảm rủi ro sai logic xét hạng.

---

## 5. Dependency theo mức độ block

### 5.1 Can start immediately

Các issue có thể bắt đầu ngay, không bị block cứng bởi issue khác.

| Issue | GitHub | Owner | Ghi chú |
|---|---:|---|---|
| GI-01 Auth, Registration and Access Control | #83 | Nguyễn Anh Kiệt | Nền đăng nhập/phân quyền |
| GI-08 Admin UI Shell and Dashboard | #86 | Nguyễn Trí | Có thể dựng admin shell/layout trước |
| GI-12 Seed Data bản đầu | #87 | Nguyễn Anh Kiệt | Seed/demo checklist nên chuẩn bị dần |
| PM-01/PM-02/PM-03 | N/A | Ngô Gia Long / Leader | Làm xuyên suốt từ đầu |

### 5.2 Soft dependency

Soft dependency nghĩa là có thể làm trước một phần, nhưng cần issue khác hoàn thiện để tích hợp đầy đủ.

| Issue | GitHub | Owner | Phụ thuộc mềm | Có thể làm trước |
|---|---:|---|---|---|
| GI-02 Customer Dashboard, Loyalty Overview and History | #84 | Nguyễn Anh Kiệt | GI-01, GI-03, GI-06, GI-07 | UI, route, layout, đọc dữ liệu mẫu |
| GI-09 Admin Loyalty Configuration Controls | #45 | Phạm Hoàng Phúc | GI-08 | DAO/form/config screens có thể chuẩn bị trước |
| GI-10 Promotion Management and Customer Promotion Inbox | #46 | Nguyễn Trí | GI-08 | Promotion tables/servlet/UI skeleton |
| GI-11 Admin Reports Dashboard | #47 | Nguyễn Trí | GI-03, GI-08 | Report layout trước, query thật sau |
| GI-12 Final demo/cleanup | #87 | Nguyễn Anh Kiệt | GI-01 đến GI-11 | Cập nhật dần theo tiến độ |

### 5.3 Hard dependency / blocked by

Hard dependency nghĩa là nên chờ issue trước hoàn thành hoặc ít nhất có database/API ổn định.

| Issue | GitHub | Owner | Bị block bởi | Lý do |
|---|---:|---|---|---|
| GI-04 Tier Review and Active 12-Month Loyalty Data | #42 | Ngô Gia Long | GI-03 | Cần active spend/visit từ booking completed |
| GI-05 Point Batch Expiry and Active Points Refresh | #44 | Phạm Hoàng Phúc | GI-03 | Cần LoyaltyPointBatch được tạo từ GI-03 |
| GI-06 Reward Redemption into Voucher | #43 | Phạm Hoàng Phúc | GI-04, GI-05 | Cần active points/tier và expired refresh đúng |
| GI-07 Apply Voucher to Booking and Voucher Lifecycle | #85 | Phạm Hoàng Phúc | GI-06 | Cần Redemption/Voucher trước |
| GI-11 Admin Reports Dashboard | #47 | Nguyễn Trí | GI-03, GI-08 | Cần dữ liệu booking completed/loyalty và admin shell |

---

## 6. Kế hoạch triển khai theo phase và deadline dự tính

### 6.1 Tổng quan mốc thời gian

| Mốc | Thời gian | Ý nghĩa |
|---|---|---|
| Project start / planning baseline | 2026-07-05 | Hoàn tất phân rã SRS, grouped issues, report và rule review |
| Feature build window | 2026-07-06 đến 2026-07-15 | Thời gian chính để code các grouped issues |
| Internal feature freeze | 2026-07-16 24:00 | Mốc cuối để Leader nhận review/integrate PR lớn |
| Stabilization window | 2026-07-17 đến 2026-07-19 | Chỉ sửa lỗi nhỏ, cleanup, cải thiện code và chuẩn bị demo |
| Official deadline | 2026-07-19 24:00 | Hạn chính thức nộp/demonstration package |

**Feature freeze** là mốc khóa tính năng. Sau mốc này, nhóm không nên thêm feature mới. Chỉ nên sửa bug, cleanup nhỏ, chỉnh seed data, sửa UI nhỏ và chuẩn bị demo.

---

### 6.2 Phase triển khai chi tiết

| Phase | Thời gian dự tính | Công việc | Owner chính | Kết quả cần đạt |
|---|---|---|---|---|
| Phase 0 | 2026-07-05 đến 2026-07-06 24:00 | PM-01, PM-02, PM-03 | Ngô Gia Long / Leader | SRS, grouped issues, branch rule, PR rule và project tracking sẵn sàng |
| Phase 1 | 2026-07-06 đến 2026-07-08 24:00 | GI-01, GI-08, GI-12 seed bản đầu | Nguyễn Anh Kiệt, Nguyễn Trí | Đăng nhập/phân quyền cơ bản, admin shell, seed data nền |
| Phase 2 | 2026-07-08 đến 2026-07-11 24:00 | GI-03 | Ngô Gia Long / Leader | Booking completed cộng điểm, tạo transaction/batch, update customer summary |
| Phase 3 | 2026-07-11 đến 2026-07-13 24:00 | GI-04, GI-05, GI-06 | Ngô Gia Long, Phạm Hoàng Phúc | Tier review, point expiry, reward redemption hoạt động |
| Phase 4 | 2026-07-13 đến 2026-07-15 24:00 | GI-07, GI-02, GI-09, GI-10, GI-11 | Phạm Hoàng Phúc, Nguyễn Trí, Nguyễn Anh Kiệt | Voucher lifecycle, customer dashboard, admin config, promotion, report |
| Phase 5 | 2026-07-15 đến 2026-07-16 24:00 | Integration review, merge cleanup, final feature PR review | All members + Leader | Các feature chính được merge trước mốc dừng review |
| Phase 6 | 2026-07-17 đến 2026-07-19 24:00 | Code improvement, bug fix, demo hardening, submission prep | All members | Không thêm feature lớn; chỉ ổn định demo và chuẩn bị nộp |

---

### 6.3 Deadline dự tính theo grouped issue

| Issue | GitHub | Owner | Start dự tính | PR đầu tiên nên có trước | Deadline hoàn thành nội bộ | Loại dependency | Ghi chú |
|---|---:|---|---|---|---|---|---|
| PM-01 | N/A | Ngô Gia Long / Leader | 2026-07-05 | 2026-07-05 | 2026-07-06 24:00 | Can start immediately | SRS update, grouped issue matrix, checklist/merge standard |
| PM-02 | N/A | Ngô Gia Long / Leader | 2026-07-05 | 2026-07-05 | 2026-07-06 24:00 | Can start immediately | GitHub issue sync, duplicate handling, project board/labels/status |
| PM-03 | N/A | Ngô Gia Long / Leader | 2026-07-05 | 2026-07-06 | 2026-07-16 24:00 | Ongoing | Branch workflow, PR template, review coordination |
| GI-01 | #83 | Nguyễn Anh Kiệt | 2026-07-06 | 2026-07-07 24:00 | 2026-07-08 24:00 | Can start immediately | Auth và role là nền để test Customer/Admin |
| GI-08 | #86 | Nguyễn Trí | 2026-07-06 | 2026-07-07 24:00 | 2026-07-08 24:00 | Can start immediately | Admin shell/layout để gắn GI-09/GI-10/GI-11 |
| GI-12 v1 | #87 | Nguyễn Anh Kiệt | 2026-07-06 | 2026-07-08 24:00 | 2026-07-08 24:00 | Can start immediately | Seed data bản đầu và demo checklist nền |
| GI-03 | #41 | Ngô Gia Long / Leader | 2026-07-08 | 2026-07-10 24:00 | 2026-07-11 24:00 | Depends on GI-01 | Core loyalty award; phải ưu tiên vì block nhiều issue sau |
| GI-04 | #42 | Ngô Gia Long / Leader | 2026-07-11 | 2026-07-12 12:00 | 2026-07-13 24:00 | Hard blocked by GI-03 | Tier review theo active spend/visits |
| GI-05 | #44 | Phạm Hoàng Phúc | 2026-07-11 | 2026-07-12 12:00 | 2026-07-13 24:00 | Hard blocked by GI-03 | Point batch expiry/event-based refresh |
| GI-06 | #43 | Phạm Hoàng Phúc | 2026-07-12 | 2026-07-13 12:00 | 2026-07-13 24:00 | Hard blocked by GI-04/GI-05 | Redeem reward thành voucher |
| GI-07 | #85 | Phạm Hoàng Phúc | 2026-07-13 | 2026-07-14 12:00 | 2026-07-15 24:00 | Hard blocked by GI-06 | Apply voucher vào booking và lifecycle |
| GI-02 | #84 | Nguyễn Anh Kiệt | 2026-07-08 | 2026-07-14 12:00 | 2026-07-15 24:00 | Soft dependency | Có thể làm UI trước, gắn dữ liệu thật sau |
| GI-09 | #45 | Phạm Hoàng Phúc | 2026-07-09 | 2026-07-14 12:00 | 2026-07-15 24:00 | Soft dependency on GI-08 | Admin config tier/reward/settings |
| GI-10 | #46 | Nguyễn Trí | 2026-07-09 | 2026-07-14 12:00 | 2026-07-15 24:00 | Soft dependency on GI-08 | Promotion management + customer inbox |
| GI-11 | #47 | Nguyễn Trí | 2026-07-13 | 2026-07-15 12:00 | 2026-07-16 24:00 | Blocked by GI-03/GI-08 | Reports cần dữ liệu completed booking/loyalty |
| GI-12 final | #87 | Nguyễn Anh Kiệt | 2026-07-15 | 2026-07-16 12:00 | 2026-07-16 24:00 | Depends on all main flows | Final seed/demo/cleanup trước feature freeze |

---

### 6.4 Mốc PR bắt buộc

Để tránh dồn PR sát deadline, mỗi grouped issue nên có PR đầu tiên trước deadline hoàn thành ít nhất 12 đến 24 giờ.

| Loại công việc | PR đầu tiên nên có trước | Lý do |
|---|---|---|
| Issue nền như GI-01, GI-08 | Trước deadline issue 1 ngày | Cần sớm để các issue khác dùng |
| Core issue như GI-03, GI-04, GI-05, GI-06, GI-07 | Trước deadline issue 12–24 giờ | Cần thời gian review logic và sửa lỗi |
| UI/report/promotion | Trước deadline issue 12 giờ | Cần kiểm tra layout, dữ liệu, route |
| GI-12 demo/seed | Cập nhật liên tục, không chờ cuối | Seed/demo bị lỗi sẽ ảnh hưởng toàn bộ demo |

Nếu đến deadline hoàn thành nội bộ mà chưa có PR hoặc chưa báo tiến độ, issue đó được xem là có rủi ro trễ và Leader có quyền điều chỉnh scope hoặc chuyển người hỗ trợ.

---

### 6.5 Quy tắc sau mốc 2026-07-16 24:00

Từ **2026-07-17 00:00** trở đi:

- Không bắt đầu feature lớn mới.
- Không refactor lớn.
- Không đổi database schema lớn nếu không cực kỳ cần thiết.
- Không merge PR lớn nếu chưa được review từ trước.
- Chỉ nhận bug fix nhỏ, cleanup, seed data, UI fix nhỏ hoặc sửa lỗi demo.

Nếu thành viên nộp PR feature lớn sau mốc này, Leader không cam kết review hoặc integrate. Thành viên đó tự chịu trách nhiệm nếu phần việc không kịp merge vào bản demo/nộp cuối.

---

### 6.6 Giai đoạn cải thiện code sau khi xong feature

Sau khi các issue chính hoàn thành trước mốc 2026-07-16 24:00, nhóm vẫn còn giai đoạn cải thiện code từ 2026-07-17 đến 2026-07-19. Giai đoạn này dùng để:

- sửa lỗi tích hợp;
- dọn code khó đọc nếu còn thời gian;
- giảm hardcode business/display values nếu có thể;
- kiểm tra lại quyền Admin/Customer/Guest;
- kiểm tra lại booking completed loyalty flow;
- kiểm tra redeem/voucher/report/promotion;
- chuẩn hóa seed data;
- chuẩn bị demo script;
- đảm bảo app chạy ổn trước deadline chính thức.

Giai đoạn này không được xem là thời gian làm feature mới. Feature chính phải hoàn thành trước đó.



## 7. Quy định branch và Pull Request

### 7.1 Branch naming

Mỗi issue nên có branch riêng theo format:

```text
feature/GI-XX-short-title
```

Ví dụ:

```text
feature/GI-03-booking-loyalty-award
feature/GI-06-reward-redemption
feature/GI-11-admin-reports
```

### 7.2 Pull Request rules

Mỗi PR phải:

- link đúng GitHub Issue;
- dùng đúng PR template trong `.github`;
- ghi rõ issue đang làm;
- ghi rõ phần đã hoàn thành;
- ghi rõ phần chưa hoàn thành nếu có;
- có ít nhất 2 review trước khi merge:
  - 1 review bằng agent automation;
  - 1 review thủ công từ reviewer chéo hoặc người có module bị ảnh hưởng.

Không bắt buộc phải có screenshot/log/query test, nhưng nếu có test thủ công thì nên ghi ngắn trong PR description.

### 7.3 Quy định sau mốc dừng review

Sau **2026-07-16 24:00**, PR lớn hoặc feature mới sẽ không được Leader cam kết review. Nếu thành viên nộp code trễ và không kịp merge, thành viên đó tự chịu trách nhiệm với phần việc của mình.

---

## 8. Rủi ro chính

| Rủi ro | Ảnh hưởng | Cách giảm |
|---|---|---|
| GI-03 làm sai | Block GI-04, GI-05, GI-06, GI-07, GI-11 | Phạm Hoàng Phúc review kỹ, ưu tiên làm sớm |
| GI-01 chậm | Customer/Admin flow khó test | Nguyễn Anh Kiệt làm đầu tiên |
| GI-08 chậm | Admin config/report/promotion bị chậm | Nguyễn Trí dựng shell sớm |
| GI-12 để cuối | Demo dễ thiếu dữ liệu hoặc lỗi flow | Cập nhật seed/demo dần từng phase |
| PR nộp sau D-3 | Leader không kịp review/integrate | Khóa feature trước 2026-07-16 24:00 |
| Branch sống quá lâu | Conflict, khó merge | Merge nhỏ theo issue, review thường xuyên |

---

## 9. Kết luận phân công

Ngô Gia Long / Leader nhận **GI-03 + GI-04 + 11 SP PM/Ops** là hợp lý. Đây là phần nặng nhưng đúng vai trò leader vì GI-03 là lõi của toàn bộ Loyalty Engine, còn GI-04 nối trực tiếp với logic xét hạng.

Không nên để Leader nhận thêm GI-05 vì khi cộng thêm công việc SRS, GitHub setup, branch workflow và review coordination thì tổng tải sẽ quá cao.

Bảng phân công cuối:

```text
Ngô Gia Long / Leader: GI-03, GI-04, PM-01, PM-02, PM-03
Phạm Hoàng Phúc: GI-05, GI-06, GI-07, GI-09
Nguyễn Trí: GI-08, GI-10, GI-11
Nguyễn Anh Kiệt: GI-01, GI-02, GI-12
```

Sau khi hoàn thành các issue chính, nhóm vẫn cần dùng giai đoạn cuối để cải thiện code, sửa lỗi tích hợp và chuẩn bị demo. Vì vậy mọi feature chính phải hoàn thành trước mốc **2026-07-16 24:00**.
