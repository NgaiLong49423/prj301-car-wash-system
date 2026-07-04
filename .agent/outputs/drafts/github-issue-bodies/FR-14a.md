# FR-14a — Gửi khuyến mãi nhắm mục tiêu theo hạng thành viên

## 1. Mục tiêu chức năng

Chức năng này cho phép Admin gửi khuyến mãi đến một nhóm khách hàng được chọn theo hạng thành viên.

Admin không gửi khuyến mãi cho toàn bộ khách hàng một cách ngẫu nhiên, mà có thể chọn nhóm khách theo cấp hạng loyalty.

Trong phạm vi issue này, hệ thống hỗ trợ cách gửi theo dạng:

> gửi cho khách hàng từ một hạng được chọn trở lên.

Ví dụ:

* chọn Silver+ thì khách Silver, Gold và Platinum nhận khuyến mãi;
* chọn Gold+ thì khách Gold và Platinum nhận khuyến mãi;
* chọn Platinum thì chỉ khách Platinum nhận khuyến mãi.

---

## 2. Ý nghĩa của chức năng

Chức năng này giúp Admin chạy các chiến dịch khuyến mãi có mục tiêu, thay vì gửi cùng một ưu đãi cho tất cả khách hàng.

Điều này phù hợp với chương trình loyalty vì khách hàng ở hạng cao thường là nhóm có giá trị cao hơn, quay lại thường xuyên hơn hoặc có tổng chi tiêu lớn hơn.

Ví dụ:

* cửa hàng muốn tri ân khách hàng thân thiết từ Silver trở lên;
* cửa hàng muốn gửi ưu đãi cao cấp cho Gold và Platinum;
* cửa hàng muốn tạo chiến dịch riêng cho Platinum để giữ chân nhóm VIP.

Chức năng này giúp hệ thống dùng dữ liệu hạng thành viên để hỗ trợ hoạt động marketing.

Marketing là hoạt động quảng bá, chăm sóc và giữ chân khách hàng.

---

## 3. Khi nào chức năng này chạy?

Chức năng này chạy khi Admin tạo hoặc gửi một chương trình khuyến mãi nhắm mục tiêu theo hạng thành viên.

Luồng thường bắt đầu từ trang Admin Controls.

Admin sẽ chọn:

* nội dung khuyến mãi;
* hạng thành viên thấp nhất được nhận khuyến mãi;
* thời điểm hoặc thao tác gửi khuyến mãi.

---

## 4. Đối tượng sử dụng

Chỉ Admin hoặc Manager mới được sử dụng chức năng này.

Khách hàng không được tự tạo hoặc tự gửi khuyến mãi.

Khách hàng chỉ là người nhận khuyến mãi nếu hạng thành viên của họ thỏa điều kiện mà Admin đã chọn.

---

## 5. Luồng hoạt động chính

### Luồng gửi khuyến mãi thành công

1. Admin mở trang gửi khuyến mãi nhắm mục tiêu.
2. Hệ thống hiển thị form gửi khuyến mãi.
3. Admin nhập nội dung khuyến mãi.
4. Admin chọn hạng thành viên thấp nhất được nhận khuyến mãi.
5. Hệ thống xác định nhóm khách hàng đủ điều kiện theo nguyên tắc “từ hạng được chọn trở lên”.
6. Hệ thống hiển thị số lượng khách hàng dự kiến sẽ nhận khuyến mãi.
7. Admin xác nhận gửi khuyến mãi.
8. Hệ thống gửi khuyến mãi đến đúng nhóm khách hàng đủ điều kiện.
9. Hệ thống ghi nhận kết quả gửi khuyến mãi.
10. Hệ thống thông báo cho Admin rằng chiến dịch đã được gửi thành công.

---

## 6. Ví dụ luồng theo từng hạng

### Trường hợp 1: Admin chọn Silver+

Nếu Admin chọn Silver+, hệ thống gửi khuyến mãi cho:

* Silver;
* Gold;
* Platinum.

Hệ thống không gửi cho Member.

Ví dụ:

* Member: không nhận;
* Silver: nhận;
* Gold: nhận;
* Platinum: nhận.

---

### Trường hợp 2: Admin chọn Gold+

Nếu Admin chọn Gold+, hệ thống gửi khuyến mãi cho:

* Gold;
* Platinum.

Hệ thống không gửi cho Member và Silver.

Ví dụ:

* Member: không nhận;
* Silver: không nhận;
* Gold: nhận;
* Platinum: nhận.

---

### Trường hợp 3: Admin chọn Platinum

Nếu Admin chọn Platinum, hệ thống chỉ gửi khuyến mãi cho khách hàng hạng Platinum.

Ví dụ:

* Member: không nhận;
* Silver: không nhận;
* Gold: không nhận;
* Platinum: nhận.

---

### Trường hợp 4: Admin chọn Member+

Nếu hệ thống cho phép chọn Member+, khuyến mãi sẽ được gửi cho tất cả khách hàng có tài khoản loyalty.

Ví dụ:

* Member: nhận;
* Silver: nhận;
* Gold: nhận;
* Platinum: nhận.

Trường hợp này dùng khi Admin muốn gửi khuyến mãi rộng rãi cho toàn bộ khách hàng.

---

## 7. Luồng lỗi và trường hợp không hợp lệ

### Trường hợp 1: Admin chưa chọn hạng mục tiêu

Nếu Admin chưa chọn hạng thành viên thấp nhất, hệ thống không cho gửi khuyến mãi.

Hệ thống cần thông báo rõ rằng Admin phải chọn nhóm khách hàng mục tiêu trước khi gửi.

---

### Trường hợp 2: Admin chưa nhập nội dung khuyến mãi

Nếu Admin chưa nhập nội dung hoặc thông tin khuyến mãi, hệ thống không cho gửi.

Lý do: khách hàng cần biết họ nhận được ưu đãi gì.

---

### Trường hợp 3: Không có khách hàng nào thỏa điều kiện

Nếu hệ thống kiểm tra và không có khách hàng nào thuộc nhóm được chọn, hệ thống không gửi khuyến mãi.

Hệ thống cần thông báo cho Admin rằng hiện không có khách hàng phù hợp với điều kiện đã chọn.

Ví dụ:

* Admin chọn Platinum;
* hệ thống chưa có khách hàng Platinum nào;
* hệ thống không gửi và thông báo cho Admin.

---

### Trường hợp 4: Khách hàng bị hạ hạng trước thời điểm gửi

Hệ thống phải dựa trên hạng thành viên hiện tại tại thời điểm gửi khuyến mãi.

Ví dụ:

* trước đó khách là Gold;
* sau khi điểm cũ hết hạn, khách bị hạ xuống Silver;
* Admin gửi chiến dịch Gold+;
* khách này không được nhận vì hiện tại không còn thuộc Gold+.

---

### Trường hợp 5: Khách hàng được nâng hạng trước thời điểm gửi

Nếu khách vừa được nâng hạng trước khi Admin gửi khuyến mãi, hệ thống phải dùng hạng mới nhất của khách.

Ví dụ:

* khách vừa được nâng từ Member lên Silver;
* Admin gửi chiến dịch Silver+;
* khách được nhận khuyến mãi vì hiện tại đã là Silver.

---

## 8. Quy tắc nghiệp vụ

### Quy tắc 1: Chọn hạng thấp nhất để gửi khuyến mãi

Admin chọn một hạng thấp nhất làm điều kiện nhận khuyến mãi.

Khách hàng ở hạng đó hoặc hạng cao hơn sẽ được nhận.

Ví dụ:

* chọn Silver+ nghĩa là Silver trở lên;
* chọn Gold+ nghĩa là Gold trở lên;
* chọn Platinum nghĩa là chỉ Platinum.

---

### Quy tắc 2: Dựa trên hạng hiện tại của khách hàng

Hệ thống phải dùng hạng thành viên hiện tại của khách tại thời điểm gửi khuyến mãi.

Không dùng hạng cũ, hạng lịch sử hoặc hạng chưa được cập nhật.

Lý do: khuyến mãi theo hạng phải phản ánh đúng trạng thái loyalty mới nhất.

---

### Quy tắc 3: Trước khi gửi nên đảm bảo hạng đã được cập nhật

Trước khi xác định danh sách khách nhận khuyến mãi, hệ thống cần đảm bảo dữ liệu hạng thành viên đang là mới nhất.

Nếu có dữ liệu loyalty cần làm mới, hệ thống cần kích hoạt việc xét lại hạng trước khi gửi.

Ví dụ:

* có điểm/lượt rửa/chi tiêu đã quá 12 tháng;
* hệ thống xử lý dữ liệu hết hạn;
* hệ thống xét lại hạng;
* sau đó mới lọc khách nhận khuyến mãi.

---

### Quy tắc 4: Member không nhận khuyến mãi Silver+

Nếu Admin chọn Silver+, khách hàng hạng Member không được nhận khuyến mãi.

Lý do: chiến dịch này chỉ dành cho khách hàng đã đạt từ Silver trở lên.

---

### Quy tắc 5: Khuyến mãi phải có nội dung rõ ràng

Một khuyến mãi được gửi cho khách cần có nội dung đủ rõ để khách hiểu họ nhận được gì.

Ví dụ:

* giảm 10% cho lần rửa tiếp theo;
* tặng wax miễn phí;
* giảm 50.000 VND cho booking tiếp theo;
* ưu đãi riêng cho khách Gold+ trong tháng này.

---

### Quy tắc 6: Hệ thống cần ghi nhận kết quả gửi

Sau khi gửi khuyến mãi, hệ thống cần ghi nhận kết quả để Admin có thể kiểm tra lại.

Thông tin cần thể hiện ở mức nghiệp vụ gồm:

* khuyến mãi đã gửi là gì;
* gửi cho nhóm hạng nào;
* thời điểm gửi;
* số lượng khách hàng được gửi;
* trạng thái gửi thành công hoặc thất bại.

---

## 9. Kết quả mong đợi

Sau khi chức năng hoàn thành, hệ thống phải đảm bảo:

* Admin có thể gửi khuyến mãi theo nhóm hạng thành viên;
* Admin chọn được hạng thấp nhất được nhận khuyến mãi;
* hệ thống hiểu đúng logic Silver+, Gold+, Platinum;
* khách hàng dưới hạng được chọn không nhận khuyến mãi;
* khách hàng ở hạng được chọn hoặc cao hơn được nhận khuyến mãi;
* hệ thống dùng hạng hiện tại của khách tại thời điểm gửi;
* hệ thống không gửi nếu thiếu nội dung khuyến mãi hoặc thiếu nhóm mục tiêu;
* hệ thống thông báo rõ kết quả gửi cho Admin;
* hệ thống ghi nhận lại lịch sử gửi khuyến mãi ở mức nghiệp vụ.

---

## 10. Phạm vi không xử lý trong issue này

Issue này không trực tiếp xử lý:

* CRUD đầy đủ chương trình khuyến mãi;
* tạo hệ thống voucher phức tạp;
* quản lý số lượng mã giảm giá;
* quản lý tồn kho quà tặng;
* cá nhân hóa bằng AI;
* gửi khuyến mãi theo hành vi từng khách hàng;
* gửi khuyến mãi theo sinh nhật;
* báo cáo hiệu quả chiến dịch;
* báo cáo doanh thu;
* báo cáo khách hàng;
* công thức xét hạng thành viên;
* cộng điểm hoặc đổi điểm loyalty.

Các phần trên nếu cần sẽ được tách thành issue riêng.

---

## 11. Ghi chú cho nhóm phát triển

FR-14a nên được hiểu là chức năng gửi khuyến mãi theo phân khúc loyalty.

Phân khúc là nhóm khách hàng được chia theo điều kiện chung, ví dụ cùng hạng thành viên.

Trong issue này, phân khúc được xác định bằng hạng thành viên:

* Member+;
* Silver+;
* Gold+;
* Platinum.

Mục tiêu chính là đảm bảo Admin gửi đúng ưu đãi cho đúng nhóm khách theo hạng hiện tại.
