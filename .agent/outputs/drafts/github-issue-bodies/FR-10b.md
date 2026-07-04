# FR-10b — Tự động kích hoạt xét lại hạng khi dữ liệu loyalty thay đổi

## 1. Mục tiêu chức năng

Chức năng này dùng để đảm bảo hạng thành viên của khách hàng luôn được cập nhật đúng sau khi có thay đổi liên quan đến loyalty.

FR-10b không trực tiếp quyết định khách thuộc hạng nào. Việc tính toán khách là Member, Silver, Gold hay Platinum thuộc về FR-10a.

Vai trò của FR-10b là xác định **khi nào hệ thống cần tự động gọi lại chức năng xét hạng thành viên**.

Nói cách khác:

* FR-10a là logic xét hạng;
* FR-10b là cơ chế tự động kích hoạt xét lại hạng đúng thời điểm.

---

## 2. Ý nghĩa của chức năng

Trong chương trình loyalty, hạng thành viên có thể thay đổi khi dữ liệu của khách thay đổi.

Ví dụ:

* khách hoàn thành thêm một booking và được cộng điểm;
* điểm, lượt rửa hoặc chi tiêu từ booking cũ hết hiệu lực sau 12 tháng;
* admin thay đổi luật xét hạng;
* khách hoặc admin mở thông tin loyalty và hệ thống cần hiển thị dữ liệu mới nhất.

Nếu hệ thống không tự động xét lại hạng sau các sự kiện này, khách hàng có thể bị hiển thị sai hạng.

Ví dụ:

* khách đã đủ điều kiện lên Silver nhưng hệ thống vẫn hiển thị Member;
* khách không còn đủ điều kiện Gold nhưng hệ thống vẫn giữ Gold;
* admin đổi luật hạng nhưng khách hàng chưa được cập nhật theo luật mới.

Chức năng này giúp hệ thống giữ dữ liệu loyalty nhất quán và phản ánh đúng trạng thái hiện tại của khách hàng.

---

## 3. Khi nào chức năng này chạy?

FR-10b chạy khi có sự kiện làm thay đổi hoặc cần kiểm tra lại dữ liệu loyalty.

Các thời điểm cần kích hoạt xét lại hạng gồm:

1. Sau khi booking được chuyển sang trạng thái hoàn thành và khách được cộng điểm.
2. Sau khi hệ thống xử lý dữ liệu loyalty hết hạn sau 12 tháng.
3. Sau khi khách đổi điểm lấy ưu đãi, nếu dữ liệu loyalty cần được làm mới.
4. Sau khi Admin thay đổi luật xét hạng thành viên.
5. Khi khách hoặc Admin mở thông tin loyalty và hệ thống cần đảm bảo dữ liệu hiển thị là mới nhất.

---

## 4. Luồng hoạt động chính

### Luồng 1: Booking hoàn thành

1. Khách hàng đặt lịch rửa xe.
2. Khách đến cửa hàng và sử dụng dịch vụ.
3. Nhân viên hoặc Admin xác nhận booking đã hoàn thành.
4. Hệ thống thực hiện cộng điểm loyalty cho khách.
5. Sau khi cộng điểm, hệ thống kích hoạt xét lại hạng thành viên.
6. Hệ thống dùng dữ liệu loyalty còn hiệu lực để xác định hạng phù hợp nhất.
7. Nếu khách đủ điều kiện lên hạng, hệ thống cập nhật hạng mới.
8. Nếu khách chưa đủ điều kiện lên hạng, hệ thống giữ nguyên hạng hiện tại.
9. Hệ thống hoàn tất luồng xử lý booking hoàn thành.

Ví dụ:

* khách đang là Member;
* trước booking này khách có 4 lượt rửa hợp lệ;
* sau khi booking hoàn thành, khách có 5 lượt rửa hợp lệ;
* hệ thống tự động xét lại hạng;
* khách được nâng lên Silver nếu thỏa điều kiện.

---

### Luồng 2: Dữ liệu loyalty cũ hết hiệu lực sau 12 tháng

1. Có hành động liên quan đến loyalty của khách hàng.
2. Hệ thống kiểm tra dữ liệu loyalty trong 12 tháng gần nhất.
3. Hệ thống phát hiện một số điểm, lượt rửa hoặc chi tiêu đã quá 12 tháng.
4. Dữ liệu quá hạn không còn được tính vào loyalty hiện tại.
5. Sau khi làm mới dữ liệu loyalty, hệ thống kích hoạt xét lại hạng thành viên.
6. Hệ thống tính lại hạng dựa trên dữ liệu còn hiệu lực.
7. Nếu khách không còn đủ điều kiện giữ hạng hiện tại, hệ thống hạ khách về đúng hạng phù hợp.
8. Nếu khách vẫn đủ điều kiện, hệ thống giữ nguyên hạng.

Ví dụ:

* khách đang là Gold;
* sau khi một số booking cũ quá 12 tháng, khách chỉ còn đủ điều kiện Silver;
* hệ thống tự động xét lại;
* khách được hạ từ Gold xuống Silver.

---

### Luồng 3: Admin thay đổi luật xét hạng

1. Admin mở chức năng cấu hình luật hạng thành viên.
2. Admin thay đổi điều kiện xét hạng của Silver, Gold hoặc Platinum.
3. Hệ thống kiểm tra luật mới có hợp lệ không.
4. Nếu luật hợp lệ, hệ thống lưu luật mới.
5. Sau khi luật mới được lưu, hệ thống kích hoạt xét lại hạng cho toàn bộ khách hàng.
6. Mỗi khách hàng được xét lại dựa trên dữ liệu loyalty còn hiệu lực và luật mới.
7. Khách đủ điều kiện hạng cao hơn sẽ được nâng hạng.
8. Khách không còn đủ điều kiện giữ hạng hiện tại sẽ bị hạ về đúng hạng phù hợp.
9. Hệ thống thông báo Admin rằng luật hạng đã được cập nhật và khách hàng đã được xét lại.

Ví dụ:

* trước đây Gold cần 15 lượt rửa;
* Admin đổi Gold thành 20 lượt rửa;
* khách đang Gold nhưng chỉ có 16 lượt rửa còn hiệu lực;
* hệ thống xét lại và đưa khách về hạng phù hợp.

---

### Luồng 4: Khách hoặc Admin xem thông tin loyalty

1. Khách hoặc Admin mở trang thông tin loyalty.
2. Trước khi hiển thị dữ liệu, hệ thống kiểm tra xem dữ liệu loyalty có cần làm mới không.
3. Nếu có điểm, lượt rửa hoặc chi tiêu đã hết hiệu lực, hệ thống cập nhật lại dữ liệu còn hiệu lực.
4. Sau khi làm mới dữ liệu, hệ thống kích hoạt xét lại hạng.
5. Hệ thống hiển thị điểm, lượt rửa, chi tiêu và hạng thành viên mới nhất.

Ví dụ:

* khách mở trang loyalty sau một thời gian dài không sử dụng;
* một số điểm cũ đã quá 12 tháng;
* hệ thống cập nhật lại điểm còn hiệu lực;
* hệ thống xét lại hạng;
* khách nhìn thấy hạng và điểm chính xác ở thời điểm hiện tại.

---

## 5. Luồng không hợp lệ hoặc không cần xử lý

### Trường hợp 1: Không có dữ liệu loyalty thay đổi

Nếu hệ thống kiểm tra và thấy dữ liệu loyalty không thay đổi, hạng thành viên được giữ nguyên.

Ví dụ:

* khách xem thông tin loyalty;
* không có điểm nào hết hạn;
* không có booking mới;
* không có luật hạng mới;
* hệ thống không cần thay đổi hạng.

---

### Trường hợp 2: Booking chưa hoàn thành

Nếu booking chưa chuyển sang trạng thái hoàn thành, hệ thống không kích hoạt xét lại hạng từ booking đó.

Lý do: booking chưa hoàn thành chưa tạo ra dữ liệu loyalty hợp lệ.

---

### Trường hợp 3: Booking bị hủy

Nếu booking bị hủy, hệ thống không kích hoạt xét lại hạng từ booking đó.

Lý do: không có lượt rửa thực tế, không có chi tiêu hợp lệ và không có điểm loyalty phát sinh.

---

### Trường hợp 4: Admin nhập luật hạng không hợp lệ

Nếu Admin thay đổi luật hạng nhưng luật mới không hợp lệ, hệ thống không lưu luật mới và không xét lại hạng khách hàng.

Ví dụ luật không hợp lệ:

* Gold có điều kiện thấp hơn Silver;
* Platinum có điều kiện thấp hơn Gold;
* điều kiện bị bỏ trống;
* giá trị nhập vào không hợp lệ.

---

## 6. Quy tắc nghiệp vụ

### Quy tắc 1: FR-10b không tự tính hạng

FR-10b không quyết định khách thuộc hạng nào.

Việc tính hạng cụ thể thuộc về FR-10a.

FR-10b chỉ chịu trách nhiệm xác định thời điểm cần gọi lại việc xét hạng.

---

### Quy tắc 2: Hạng phải được xét lại sau khi loyalty thay đổi

Bất kỳ sự kiện nào làm thay đổi dữ liệu loyalty đều phải dẫn đến việc xét lại hạng.

Các dữ liệu loyalty có thể ảnh hưởng đến hạng gồm:

* số lượt rửa còn hiệu lực;
* tổng chi tiêu còn hiệu lực;
* luật xét hạng hiện tại;
* dữ liệu booking đã hoàn thành;
* dữ liệu loyalty hết hạn sau 12 tháng.

---

### Quy tắc 3: Không dùng scheduler hàng tháng trong phạm vi issue này

Chức năng này không triển khai cơ chế tự động chạy nền theo tháng.

Hệ thống không cần tự quét toàn bộ khách hàng vào ngày đầu tháng.

Thay vào đó, hệ thống xét lại hạng khi có hành động hoặc sự kiện liên quan đến loyalty.

Lý do:

* giảm độ phức tạp cho bài assignment;
* tránh phụ thuộc vào tiến trình chạy nền;
* tránh lỗi chạy trùng hoặc chạy sai thời điểm;
* phù hợp với luồng xử lý điểm hết hạn đã chốt.

---

### Quy tắc 4: Khi Admin đổi luật hạng, phải xét lại toàn bộ khách hàng

Nếu Admin thay đổi điều kiện xét hạng, hệ thống phải xét lại hạng của toàn bộ khách hàng.

Lý do: luật mới có thể làm thay đổi hạng của nhiều khách cùng lúc.

Ví dụ:

* một số khách được nâng hạng vì luật mới dễ hơn;
* một số khách bị hạ hạng vì luật mới khó hơn.

---

### Quy tắc 5: Khi dữ liệu cũ hết hiệu lực, phải xét lại đúng hạng hiện tại

Khi điểm, lượt rửa hoặc chi tiêu cũ quá 12 tháng không còn hiệu lực, hệ thống phải xét lại hạng dựa trên dữ liệu còn hiệu lực.

Nếu khách không còn đủ điều kiện giữ hạng hiện tại, hệ thống đưa khách về đúng hạng phù hợp.

Không hạ từng bậc giả tạo.

Ví dụ:

* khách đang Platinum;
* sau khi dữ liệu cũ hết hiệu lực, khách chỉ còn đủ điều kiện Silver;
* hệ thống hạ trực tiếp từ Platinum xuống Silver.

---

### Quy tắc 6: Hạng sau khi xét lại phải phản ánh dữ liệu mới nhất

Sau mỗi lần xét lại, hạng thành viên hiển thị cho khách và Admin phải là hạng mới nhất theo dữ liệu còn hiệu lực.

Không được để trường hợp:

* dữ liệu đã thay đổi nhưng hạng vẫn cũ;
* khách đủ điều kiện lên hạng nhưng chưa được nâng;
* khách không đủ điều kiện giữ hạng nhưng vẫn giữ hạng cao.

---

## 7. Kết quả mong đợi

Sau khi chức năng hoàn thành, hệ thống phải đảm bảo:

* hệ thống biết khi nào cần tự động xét lại hạng thành viên;
* booking hoàn thành và cộng điểm xong thì hạng được xét lại;
* dữ liệu loyalty hết hạn sau 12 tháng thì hạng được xét lại;
* Admin đổi luật hạng thì toàn bộ khách hàng được xét lại;
* khách hoặc Admin xem loyalty thì dữ liệu được làm mới nếu cần;
* hạng thành viên luôn phản ánh đúng dữ liệu loyalty còn hiệu lực;
* không triển khai scheduler hàng tháng trong phạm vi issue này;
* FR-10b đóng vai trò kết nối giữa FR-09, FR-10a, FR-12 và FR-13a.

---

## 8. Phạm vi không xử lý trong issue này

Issue này không trực tiếp xử lý:

* công thức xét khách thuộc Member, Silver, Gold hay Platinum;
* cộng điểm sau booking hoàn thành;
* đổi điểm lấy ưu đãi;
* xử lý chi tiết điểm hết hạn;
* Admin cấu hình luật hạng;
* Admin tạo chương trình khuyến mãi;
* gửi khuyến mãi theo nhóm khách;
* báo cáo khách hàng;
* báo cáo doanh thu;
* scheduler tự động chạy nền hàng tháng.

Các phần trên sẽ thuộc các issue riêng tương ứng.

---

## 9. Ghi chú cho nhóm phát triển

FR-10b nên được hiểu là chức năng điều phối nghiệp vụ.

Khi một chức năng khác làm thay đổi dữ liệu loyalty, chức năng đó cần kích hoạt xét lại hạng thành viên.

Các chức năng liên quan gồm:

* FR-09: cộng điểm sau khi booking hoàn thành;
* FR-10a: xét hạng thành viên;
* FR-12: xử lý dữ liệu loyalty hết hạn sau 12 tháng;
* FR-13a: Admin cấu hình luật hạng thành viên.

Mục tiêu cuối cùng là đảm bảo hạng thành viên của khách hàng luôn đúng theo dữ liệu loyalty mới nhất.
