# FR-10a — Xét hạng thành viên tự động

## 1. Mục tiêu chức năng

Chức năng này dùng để tự động xác định hạng thành viên hiện tại của khách hàng dựa trên dữ liệu loyalty còn hiệu lực.

Hệ thống sẽ xét hạng dựa trên:

* tổng số lượt rửa xe hợp lệ trong 12 tháng gần nhất;
* tổng số tiền chi tiêu hợp lệ trong 12 tháng gần nhất;
* điều kiện phân hạng của từng cấp thành viên.

Chức năng này giúp hệ thống tự động nâng hạng hoặc hạ hạng khách hàng khi dữ liệu loyalty thay đổi.

---

## 2. Các hạng thành viên

Hệ thống có các hạng thành viên sau:

* Member;
* Silver;
* Gold;
* Platinum.

Khách hàng mới đăng ký sẽ được hiển thị là Member để dễ sử dụng hệ thống.

Tuy nhiên, dữ liệu loyalty của khách chỉ thật sự bắt đầu có ý nghĩa sau khi khách hoàn thành ít nhất một lần rửa xe.

---

## 3. Quy tắc xét hạng

Hệ thống xét hạng dựa trên dữ liệu còn hiệu lực trong 12 tháng gần nhất.

Các dữ liệu được dùng để xét hạng gồm:

* số lượt rửa xe đã hoàn thành;
* tổng số tiền khách đã chi tiêu.

Điều kiện phân hạng:

* Member: khách đã đăng ký tài khoản và có thể bắt đầu tham gia chương trình loyalty;
* Silver: đạt ít nhất 5 lượt rửa xe hoặc tổng chi tiêu đạt 2.000.000 VND;
* Gold: đạt ít nhất 15 lượt rửa xe hoặc tổng chi tiêu đạt 6.000.000 VND;
* Platinum: đạt ít nhất 30 lượt rửa xe hoặc tổng chi tiêu đạt 15.000.000 VND.

Từ “hoặc” có nghĩa là khách chỉ cần đạt một trong hai điều kiện: số lượt rửa hoặc tổng chi tiêu.

Ví dụ:

* khách có 5 lượt rửa nhưng chưa chi đủ 2.000.000 VND vẫn được lên Silver;
* khách mới có 3 lượt rửa nhưng đã chi đủ 2.000.000 VND vẫn được lên Silver.

---

## 4. Luồng nâng hạng

### Trường hợp khách đủ điều kiện lên hạng

1. Khách hoàn thành một booking rửa xe.
2. Hệ thống cộng điểm và cập nhật dữ liệu loyalty của khách.
3. Hệ thống kiểm tra lại tổng lượt rửa và tổng chi tiêu còn hiệu lực trong 12 tháng gần nhất.
4. Hệ thống so sánh dữ liệu hiện tại với điều kiện của từng hạng.
5. Nếu khách đủ điều kiện lên hạng cao hơn, hệ thống cập nhật hạng mới cho khách.
6. Khách được hưởng quyền lợi theo hạng mới từ các lần sử dụng sau.

Ví dụ:

* trước booking này, khách là Member và có 4 lượt rửa hợp lệ;
* sau khi booking hoàn thành, khách có 5 lượt rửa hợp lệ;
* hệ thống xét thấy khách đủ điều kiện Silver;
* khách được nâng từ Member lên Silver.

---

## 5. Luồng hạ hạng

### Trường hợp dữ liệu cũ hết hiệu lực

1. Một hoặc nhiều dữ liệu loyalty từ booking cũ quá 12 tháng không còn được tính vào chương trình thành viên.
2. Hệ thống tính lại tổng lượt rửa và tổng chi tiêu còn hiệu lực của khách.
3. Hệ thống kiểm tra khách còn đủ điều kiện giữ hạng hiện tại không.
4. Nếu khách không còn đủ điều kiện, hệ thống tính lại từ đầu để xác định hạng phù hợp nhất.
5. Khách được đưa về đúng hạng tương ứng với dữ liệu còn hiệu lực.

Ví dụ:

* khách đang là Gold;
* trước đó khách có 15 lượt rửa hợp lệ;
* sau khi một booking cũ quá 12 tháng không còn được tính, khách chỉ còn 14 lượt rửa hợp lệ;
* tổng chi tiêu còn hiệu lực cũng chưa đủ điều kiện Gold;
* hệ thống tính lại và xác định khách chỉ còn đủ điều kiện Silver;
* khách được hạ từ Gold xuống Silver.

---

## 6. Nguyên tắc khi hạ hạng

Khi khách không còn đủ điều kiện giữ hạng hiện tại, hệ thống không hạ từng bậc một.

Thay vào đó, hệ thống tính lại toàn bộ dữ liệu còn hiệu lực và đưa khách về đúng hạng mà khách đang đủ điều kiện.

Ví dụ:

* khách đang là Platinum;
* sau khi dữ liệu cũ hết hiệu lực, khách chỉ còn đủ điều kiện Silver;
* hệ thống hạ trực tiếp từ Platinum xuống Silver.

Lý do: hạng thành viên phải phản ánh đúng dữ liệu loyalty còn hiệu lực của khách.

---

## 7. Luồng giữ nguyên hạng

Nếu sau khi tính lại, khách vẫn đủ điều kiện cho hạng hiện tại, hệ thống giữ nguyên hạng.

Ví dụ:

* khách đang là Gold;
* một booking cũ hết hiệu lực;
* sau khi tính lại, khách vẫn còn đủ 15 lượt rửa hoặc đủ 6.000.000 VND chi tiêu;
* hệ thống giữ nguyên hạng Gold.

---

## 8. Luồng khách mới đăng ký

1. Khách đăng ký tài khoản thành công.
2. Hệ thống hiển thị khách là Member.
3. Khách chưa có điểm, chưa có lượt rửa, chưa có chi tiêu loyalty.
4. Khi khách hoàn thành lần rửa xe đầu tiên, hệ thống bắt đầu ghi nhận điểm, lượt rửa và chi tiêu.
5. Từ đó, khách bắt đầu được xét điều kiện để lên các hạng cao hơn.

---

## 9. Kết quả mong đợi

Sau khi chức năng hoàn thành, hệ thống phải đảm bảo:

* khách được xét hạng dựa trên dữ liệu loyalty còn hiệu lực trong 12 tháng gần nhất;
* khách đủ điều kiện hạng cao hơn thì được nâng hạng;
* khách không còn đủ điều kiện giữ hạng hiện tại thì bị hạ về đúng hạng phù hợp;
* khách không bị hạ từng bậc giả tạo, mà được tính lại theo dữ liệu thực tế;
* khách mới đăng ký được hiển thị là Member;
* dữ liệu loyalty chỉ thật sự bắt đầu sau khi khách hoàn thành lần rửa xe đầu tiên;
* hệ thống có thể xét lại hạng sau khi booking hoàn thành hoặc sau khi dữ liệu cũ hết hiệu lực.

---

## 10. Phạm vi không xử lý trong issue này

Issue này không trực tiếp xử lý:

* cộng điểm sau booking;
* đổi điểm lấy ưu đãi;
* điểm hết hạn chi tiết;
* quản lý khuyến mãi;
* gửi khuyến mãi theo hạng;
* báo cáo khách hàng;
* báo cáo doanh thu.

Các phần đó sẽ được tách thành issue riêng.
