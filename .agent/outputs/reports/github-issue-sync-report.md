# Báo Cáo Đồng Bộ GitHub Issues

**Dự án:** AutoWash Pro - PRJ301  
**Ngày thực hiện:** 24/06/2026 (Local Time)  
**Công cụ sử dụng:** GitHub CLI (`gh`)  

---

## 📊 Kết Quả Đồng Bộ Chi Tiết

Dưới đây là danh sách các functional requirement (FR) đã được đồng bộ từ file `agent/assignment-issue-loyalty-flow-design.md` lên GitHub Issues. 

Tất cả các issue tương ứng đã tồn tại từ trước trên GitHub nên đều được thực hiện theo phương thức **Cập nhật (Update)** sau khi đã sao lưu nội dung cũ thành công.

| Mã FR | Trạng thái đồng bộ | Issue Number | Tiêu đề cuối cùng | Section nguồn trong file Flow Design |
| :--- | :--- | :--- | :--- | :--- |
| **FR-09** | Cập nhật issue cũ | #41 | `FR-09 — Tích điểm tự động sau khi hoàn thành rửa xe` | `# FR-09 — Tích điểm tự động sau khi hoàn thành rửa xe` |
| **FR-10a** | Cập nhật issue cũ | #42 | `FR-10a — Xét hạng thành viên tự động` | `# FR-10a — Xét hạng thành viên tự động` |
| **FR-10b** | Cập nhật issue cũ | #58 | `FR-10b — Tự động kích hoạt xét lại hạng khi dữ liệu loyalty thay đổi` | `# FR-10b — Tự động kích hoạt xét lại hạng khi dữ liệu loyalty thay đổi` |
| **FR-11** | Cập nhật issue cũ | #43 | `FR-11 — Đổi điểm loyalty lấy ưu đãi` | `# FR-11 — Đổi điểm loyalty lấy ưu đãi` |
| **FR-12** | Cập nhật issue cũ | #44 | `FR-12 — Điểm loyalty hết hạn sau 12 tháng` | `# FR-12 — Điểm loyalty hết hạn sau 12 tháng` |
| **FR-13** | Cập nhật issue cũ | #45 | `FR-13 — Admin Loyalty Configuration: Cấu hình luật loyalty cho Admin` | Cụm section từ `# FR-13` đến trước `# FR-14a` (Bao gồm cả `# FR-13a`, `# FR-13b`, phần ảnh hưởng, phạm vi không xử lý) |
| **FR-14a** | Cập nhật issue cũ | #46 | `FR-14a — Gửi khuyến mãi nhắm mục tiêu theo hạng thành viên` | `# FR-14a — Gửi khuyến mãi nhắm mục tiêu theo hạng thành viên` |
| **FR-15** | Cập nhật issue cũ | #47 | `FR-15 — Báo cáo thống kê khách hàng dành cho Admin` | `# FR-15 — Báo cáo thống kê khách hàng dành cho Admin` |
| **FR-16** | Cập nhật issue cũ | #48 | `FR-16 — Báo cáo doanh thu và lịch đặt dành cho Admin` | `# FR-16 — Báo cáo doanh thu và lịch đặt dành cho Admin` |

---

## 🗄️ Chi Tiết Lưu Trữ & Backup

* **File nội dung tạm thời (Issue Bodies)**: Được lưu tại `agent/github-issue-bodies/` dạng `<FR-code>.md`.
* **File sao lưu trước khi cập nhật (Backups)**: Được lưu tại `agent/github-issue-backup/` dưới dạng JSON (`issue-<number>-before.json`).

---

## ⚠️ Xác Nhận Tuân Thủ Yêu Cầu

Chúng tôi xác nhận đã tuân thủ nghiêm ngặt các quy tắc và ràng buộc sau:

1. **Không sửa đổi source code**: Tuyệt đối không sửa bất kỳ file mã nguồn nào của dự án.
2. **Không commit**: Không tạo bất kỳ commit nào lên Git repository của dự án.
3. **Không đóng issue**: Không thực hiện đóng bất kỳ issue nào trên GitHub.
4. **Không đổi thông tin quản lý**: Giữ nguyên toàn bộ Labels, Milestone và Assignee của từng issue trên GitHub.
5. **Đồng bộ trọn vẹn**: Nội dung các body issue được giữ nguyên văn, không tự ý cắt ngắn hoặc viết lại logic nghiệp vụ. Cụm FR-13 được đồng bộ đầy đủ các phần phụ FR-13a, FR-13b cùng các phần liên quan.
