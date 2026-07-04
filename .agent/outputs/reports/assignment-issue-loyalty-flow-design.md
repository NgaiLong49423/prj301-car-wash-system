# Thiết Kế Luồng Mô Tả Issue Assignment - Loyalty Booking Points

**Dự án:** AutoWash Pro - PRJ301  
**Mục đích:** Ghi lại cách mô tả issue theo luồng mới đã chốt: điểm, hạng thành viên và thời hạn điểm đều gắn với booking đã hoàn thành trong vòng 12 tháng.

---

# FR-09 — Tích điểm tự động sau khi hoàn thành rửa xe

## 1. Mục tiêu chức năng

Chức năng này dùng để tự động cộng điểm loyalty cho khách hàng sau khi khách đã hoàn thành một lần rửa xe hợp lệ.

Hệ thống không chỉ cộng điểm, mà còn ghi nhận dữ liệu phục vụ cho chương trình khách hàng thân thiết, bao gồm:

* điểm khách nhận được sau lần rửa xe;
* tổng số tiền khách đã chi tiêu;
* tổng số lượt rửa xe đã hoàn thành;
* dữ liệu để hệ thống xét hạng thành viên sau này.

Chức năng này là nền tảng cho các chức năng khác như nâng hạng thành viên, đổi điểm, điểm hết hạn và báo cáo khách hàng.

---

## 2. Khi nào chức năng này chạy?

Chức năng chỉ chạy khi một booking được xác nhận là đã hoàn thành.

Nói cách khác:

* khách chỉ mới đặt lịch thì chưa được cộng điểm;
* booking đang chờ xử lý thì chưa được cộng điểm;
* booking bị hủy thì không được cộng điểm;
* chỉ khi booking chuyển sang trạng thái hoàn thành thì hệ thống mới cộng điểm.

---

## 3. Luồng hoạt động chính

### Luồng thành công

1. Khách hàng đặt lịch rửa xe.
2. Khách đến cửa hàng và sử dụng dịch vụ.
3. Nhân viên hoặc admin xác nhận booking đã hoàn thành.
4. Hệ thống kiểm tra booking này trước đó đã hoàn thành chưa.
5. Nếu booking chưa từng hoàn thành, hệ thống bắt đầu tính điểm cho khách.
6. Hệ thống tính điểm dựa trên số tiền của lần rửa xe đó.
7. Hệ thống áp dụng hệ số điểm theo hạng thành viên hiện tại của khách.
8. Hệ thống cộng điểm vào tài khoản loyalty của khách.
9. Hệ thống ghi nhận lịch sử điểm của lần rửa xe này.
10. Hệ thống cập nhật tổng chi tiêu và tổng số lượt rửa xe của khách.
11. Sau khi dữ liệu loyalty được cập nhật, hệ thống gọi chức năng xét lại hạng thành viên.
12. Hệ thống thông báo hoàn thành xử lý tích điểm.

---

## 4. Luồng không hợp lệ

### Trường hợp 1: Booking chưa hoàn thành

Nếu booking vẫn đang ở trạng thái chờ, đã đặt, đã xác nhận nhưng chưa rửa xong, hệ thống không được cộng điểm.

Lý do: khách chưa thật sự sử dụng dịch vụ.

---

### Trường hợp 2: Booking bị hủy

Nếu booking đã bị hủy, hệ thống không được cộng điểm.

Lý do: không có lượt rửa xe thực tế xảy ra.

---

### Trường hợp 3: Booking đã hoàn thành trước đó

Nếu booking đã được đánh dấu hoàn thành trước đó, hệ thống không được cộng điểm lần nữa.

Lý do: tránh lỗi một booking được cộng điểm nhiều lần.

---

## 5. Quy tắc nghiệp vụ

### Quy tắc 1: Chỉ booking hoàn thành mới sinh điểm

Điểm loyalty chỉ được tạo ra từ những booking đã hoàn thành.

---

### Quy tắc 2: Điểm dựa trên số tiền khách đã chi tiêu

Hệ thống tính điểm dựa trên giá trị thanh toán của lần rửa xe.

Theo yêu cầu đề bài:

* 1 điểm tương ứng với 1.000 VND chi tiêu.

Ví dụ:

* khách chi 100.000 VND;
* hệ thống tính được 100 điểm cơ bản.

---

### Quy tắc 3: Hạng thành viên ảnh hưởng đến điểm nhận được

Khách hàng ở hạng cao hơn sẽ nhận được nhiều điểm hơn.

Ví dụ:

* Member nhận điểm cơ bản;
* Silver được cộng thêm điểm thưởng theo hạng;
* Gold được cộng thêm điểm thưởng cao hơn Silver;
* Platinum được cộng thêm điểm thưởng cao nhất.

---

### Quy tắc 4: Mỗi lần cộng điểm phải có lịch sử

Mỗi lần khách được cộng điểm, hệ thống cần ghi nhận lại lịch sử của lần cộng điểm đó.

Lý do:

* để khách biết điểm đến từ lần rửa xe nào;
* để admin kiểm tra khi cần;
* để phục vụ chức năng điểm hết hạn sau 12 tháng;
* để tránh dữ liệu loyalty chỉ là một con số tổng không thể kiểm tra lại.

---

### Quy tắc 5: Sau khi cộng điểm phải xét lại hạng thành viên

Sau khi hệ thống cộng điểm, cập nhật tổng chi tiêu và số lượt rửa, hệ thống cần gọi chức năng xét lại hạng thành viên.

Lý do: sau lần rửa xe này, khách có thể đã đủ điều kiện lên hạng mới.

Ví dụ:

* trước booking này khách có 4 lượt rửa;
* sau khi hoàn thành booking này khách đạt 5 lượt rửa;
* hệ thống cần kiểm tra xem khách có đủ điều kiện lên Silver không.

---

## 6. Kết quả mong đợi

Sau khi chức năng hoàn thành, hệ thống phải đảm bảo:

* khách chỉ được cộng điểm sau khi booking hoàn thành;
* booking chưa hoàn thành hoặc đã hủy không sinh điểm;
* một booking không bị cộng điểm nhiều lần;
* điểm của khách được cập nhật đúng;
* tổng chi tiêu của khách được cập nhật đúng;
* tổng số lượt rửa xe của khách được cập nhật đúng;
* lịch sử điểm của lần rửa xe được ghi nhận;
* hệ thống có thể tiếp tục xét hạng thành viên sau khi cộng điểm.

---

## 7. Phạm vi không xử lý trong issue này

Issue này không trực tiếp xử lý:

* giao diện đổi điểm;
* danh sách phần thưởng;
* điểm hết hạn sau 12 tháng;
* admin tạo khuyến mãi;
* báo cáo doanh thu;
* báo cáo khách hàng.

Các phần đó sẽ được tách thành issue riêng.

---

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

---

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

---

# FR-11 — Đổi điểm loyalty lấy ưu đãi

## 1. Mục tiêu chức năng

Chức năng này cho phép khách hàng sử dụng điểm loyalty còn hiệu lực để đổi lấy các ưu đãi trong hệ thống.

Ưu đãi có thể bao gồm:

* mã giảm giá;
* dịch vụ miễn phí;
* quà tặng hoặc quyền lợi khác do hệ thống cung cấp.

Sau khi đổi thành công, ưu đãi sẽ được lưu vào tài khoản của khách hàng để sử dụng trong các lần booking sau.

---

## 2. Ý nghĩa của chức năng

Chức năng này giúp chương trình loyalty có giá trị thực tế với khách hàng.

Khách không chỉ tích điểm để xem, mà có thể dùng điểm để nhận lại lợi ích cụ thể.

Ví dụ:

* khách dùng 300 điểm để đổi dịch vụ wax miễn phí;
* khách dùng 500 điểm để đổi mã giảm giá;
* khách dùng điểm để nhận ưu đãi cho lần rửa xe tiếp theo.

---

## 3. Khi nào chức năng này chạy?

Chức năng này chạy khi khách hàng chọn đổi một ưu đãi bằng điểm loyalty.

Luồng này thường bắt đầu từ trang loyalty, trang reward hoặc trang thông tin tài khoản khách hàng.

---

## 4. Luồng đổi điểm thành công

1. Khách hàng mở danh sách ưu đãi có thể đổi bằng điểm.
2. Hệ thống hiển thị các ưu đãi hiện có.
3. Khách chọn một ưu đãi muốn đổi.
4. Hệ thống kiểm tra điểm hết hạn trước khi cho đổi.
5. Hệ thống cập nhật lại số điểm còn hiệu lực của khách.
6. Hệ thống kiểm tra khách có đủ điểm để đổi ưu đãi đã chọn không.
7. Nếu đủ điểm, hệ thống trừ điểm của khách.
8. Khi trừ điểm, hệ thống ưu tiên dùng điểm cũ trước.
9. Hệ thống tạo ưu đãi tương ứng và lưu vào tài khoản khách hàng.
10. Hệ thống thông báo đổi điểm thành công.
11. Khách có thể xem ưu đãi vừa đổi trong tài khoản của mình.

---

## 5. Luồng đổi điểm thất bại

### Trường hợp 1: Khách không đủ điểm

1. Khách chọn ưu đãi muốn đổi.
2. Hệ thống kiểm tra điểm còn hiệu lực.
3. Số điểm còn hiệu lực của khách không đủ để đổi ưu đãi.
4. Hệ thống không trừ điểm.
5. Hệ thống thông báo khách không đủ điểm để đổi ưu đãi này.

---

### Trường hợp 2: Điểm đã hết hạn sau khi kiểm tra

1. Trước khi đổi, hệ thống kiểm tra điểm hết hạn.
2. Một phần điểm của khách đã quá 12 tháng và không còn hiệu lực.
3. Sau khi cập nhật lại, khách không còn đủ điểm.
4. Hệ thống từ chối đổi ưu đãi.
5. Hệ thống hiển thị số điểm còn hiệu lực mới nhất cho khách.

---

### Trường hợp 3: Ưu đãi không còn khả dụng

Nếu ưu đãi đã bị ngừng, hết lượt đổi hoặc không còn được áp dụng, hệ thống không cho khách đổi.

Hệ thống cần thông báo rõ rằng ưu đãi hiện không còn khả dụng.

---

## 6. Quy tắc nghiệp vụ

### Quy tắc 1: Chỉ dùng điểm còn hiệu lực

Khách chỉ được sử dụng điểm loyalty còn hiệu lực để đổi ưu đãi.

Điểm đã hết hạn sau 12 tháng không được dùng để đổi thưởng.

---

### Quy tắc 2: Phải kiểm tra điểm hết hạn trước khi đổi

Trước khi hệ thống quyết định khách có đủ điểm hay không, hệ thống phải kiểm tra và cập nhật điểm hết hạn.

Lý do: số điểm hiển thị trước đó có thể đã bao gồm điểm cũ quá 12 tháng.

---

### Quy tắc 3: Ưu tiên dùng điểm cũ trước

Khi khách đổi điểm, hệ thống ưu tiên sử dụng các điểm được tạo trước.

Cách này gọi là FIFO — First In, First Out, nghĩa là điểm nào có trước thì được dùng trước.

Ví dụ:

* booking A tạo 100 điểm vào tháng 1;
* booking B tạo 200 điểm vào tháng 3;
* khách đổi ưu đãi cần 150 điểm;
* hệ thống dùng hết 100 điểm từ booking A trước;
* sau đó dùng thêm 50 điểm từ booking B.

---

### Quy tắc 4: Ưu đãi sau khi đổi được lưu vào tài khoản khách

Sau khi đổi điểm thành công, ưu đãi không bắt buộc phải dùng ngay.

Ưu đãi được lưu vào tài khoản khách hàng để khách có thể dùng trong lần booking hoặc thanh toán sau.

Ví dụ:

* khách đổi 300 điểm lấy “Wax miễn phí”;
* hệ thống lưu ưu đãi này vào tài khoản khách;
* ở lần booking sau, khách có thể chọn sử dụng ưu đãi này nếu còn hợp lệ.

---

### Quy tắc 5: Không giới hạn reward theo hạng thành viên

Trong phạm vi chức năng này, mọi khách hàng đều có thể đổi các ưu đãi nếu đủ điểm.

Hệ thống không chặn khách theo hạng Member, Silver, Gold hay Platinum.

Điều kiện chính để đổi là:

* khách có đủ điểm còn hiệu lực;
* ưu đãi vẫn còn khả dụng.

---

## 7. Các loại ưu đãi được hỗ trợ

Chức năng đổi điểm cần hỗ trợ ít nhất hai nhóm ưu đãi:

### Nhóm 1: Mã giảm giá

Khách dùng điểm để đổi mã giảm giá cho các lần sử dụng dịch vụ sau.

Ví dụ:

* đổi điểm lấy mã giảm giá 20.000 VND;
* đổi điểm lấy mã giảm giá 10%;
* đổi điểm lấy mã giảm giá cho một loại dịch vụ cụ thể.

---

### Nhóm 2: Dịch vụ miễn phí

Khách dùng điểm để đổi một dịch vụ miễn phí hoặc dịch vụ bổ sung miễn phí.

Ví dụ:

* đổi điểm lấy wax miễn phí;
* đổi điểm lấy nâng cấp gói rửa miễn phí;
* đổi điểm lấy một lần rửa xe cơ bản miễn phí.

---

## 8. Luồng khách xem ưu đãi đã đổi

1. Khách mở trang tài khoản hoặc trang ưu đãi của tôi.
2. Hệ thống hiển thị danh sách ưu đãi khách đã đổi.
3. Mỗi ưu đãi cần thể hiện trạng thái rõ ràng, ví dụ:

   * chưa sử dụng;
   * đã sử dụng;
   * hết hạn;
   * không còn khả dụng.
4. Khách chọn ưu đãi phù hợp để sử dụng trong lần booking sau.

---

## 9. Kết quả mong đợi

Sau khi chức năng hoàn thành, hệ thống phải đảm bảo:

* khách có thể xem danh sách ưu đãi đổi bằng điểm;
* khách có thể đổi điểm lấy mã giảm giá;
* khách có thể đổi điểm lấy dịch vụ miễn phí;
* hệ thống kiểm tra điểm hết hạn trước khi cho đổi;
* khách chỉ dùng được điểm còn hiệu lực;
* nếu đủ điểm, hệ thống trừ điểm và lưu ưu đãi vào tài khoản khách;
* nếu không đủ điểm, hệ thống không trừ điểm;
* khi trừ điểm, hệ thống ưu tiên dùng điểm cũ trước;
* mọi khách hàng đủ điểm đều có thể đổi reward, không bị giới hạn theo hạng thành viên.

---

## 10. Phạm vi không xử lý trong issue này

Issue này không trực tiếp xử lý:

* cộng điểm sau booking hoàn thành;
* xét hạng thành viên;
* xử lý chi tiết điểm hết hạn;
* admin tạo chương trình khuyến mãi;
* gửi khuyến mãi theo nhóm khách;
* báo cáo khách hàng;
* báo cáo doanh thu.

Các phần đó sẽ được tách thành issue riêng.

---

# FR-12 — Điểm loyalty hết hạn sau 12 tháng

## 1. Mục tiêu chức năng

Chức năng này dùng để xử lý việc điểm loyalty của khách hàng hết hiệu lực sau 12 tháng.

Mỗi lần khách hoàn thành một booking rửa xe, hệ thống sẽ cộng điểm và ghi nhận dữ liệu loyalty từ booking đó. Tuy nhiên, dữ liệu này không có hiệu lực mãi mãi.

Sau 12 tháng, dữ liệu loyalty phát sinh từ booking đó sẽ không còn được tính vào chương trình khách hàng thân thiết nữa.

Dữ liệu hết hiệu lực bao gồm:

* điểm loyalty được cộng từ booking đó;
* lượt rửa xe phát sinh từ booking đó;
* số tiền chi tiêu phát sinh từ booking đó.

---

## 2. Ý nghĩa của chức năng

Chức năng này giúp hệ thống đảm bảo hạng thành viên và điểm hiện có của khách hàng phản ánh đúng hoạt động gần đây, thay vì tính toàn bộ lịch sử từ lúc tạo tài khoản.

Nói cách khác, chương trình loyalty chỉ tính dữ liệu còn hiệu lực trong 12 tháng gần nhất.

Ví dụ:

* khách từng là Gold vì có đủ 15 lượt rửa trong 12 tháng;
* sau một thời gian, một số lượt rửa cũ quá 12 tháng không còn được tính;
* nếu khách không còn đủ điều kiện Gold, hệ thống cần xét lại hạng của khách.

---

## 3. Khi nào chức năng này chạy?

Chức năng xử lý điểm hết hạn sẽ chạy khi có hành động liên quan đến loyalty.

Ví dụ:

* khách xem điểm loyalty;
* khách đổi điểm lấy ưu đãi;
* khách hoàn thành thêm một booking mới;
* hệ thống cần xét lại hạng thành viên;
* admin xem thông tin loyalty hoặc báo cáo liên quan.

Hệ thống không cần chạy bộ kiểm tra tự động phức tạp theo thời gian cố định. Việc kiểm tra sẽ được thực hiện khi dữ liệu loyalty được sử dụng.

---

## 4. Luồng xử lý điểm hết hạn

### Luồng chính

1. Có một hành động liên quan đến loyalty của khách hàng.
2. Hệ thống kiểm tra các điểm và dữ liệu loyalty của khách.
3. Hệ thống xác định những dữ liệu đã quá 12 tháng.
4. Những dữ liệu quá 12 tháng sẽ không còn được tính vào điểm hiện có.
5. Lượt rửa và chi tiêu từ các booking quá 12 tháng cũng không còn được tính vào điều kiện xét hạng.
6. Sau khi cập nhật dữ liệu còn hiệu lực, hệ thống gọi chức năng xét lại hạng thành viên.
7. Hệ thống hiển thị hoặc sử dụng dữ liệu loyalty mới nhất.

---

## 5. Quy tắc nghiệp vụ

### Quy tắc 1: Điểm chỉ có hiệu lực trong 12 tháng

Điểm loyalty được cộng từ một booking chỉ có hiệu lực trong vòng 12 tháng kể từ thời điểm booking đó hoàn thành.

Sau 12 tháng, phần điểm này không còn được dùng để đổi thưởng.

Ví dụ:

* ngày 01/07/2026, khách hoàn thành booking và nhận 100 điểm;
* đến ngày 01/07/2027, 100 điểm này hết hiệu lực;
* khách không thể dùng 100 điểm đó để đổi ưu đãi nữa.

---

### Quy tắc 2: Booking quá 12 tháng không còn được tính cho loyalty

Khi dữ liệu từ một booking quá 12 tháng, hệ thống không chỉ làm điểm hết hạn, mà còn không tính booking đó vào dữ liệu xét loyalty hiện hành.

Điều này có nghĩa là:

* điểm từ booking đó không còn được tính;
* số tiền chi tiêu từ booking đó không còn được tính;
* lượt rửa từ booking đó không còn được tính.

Lý do: hạng thành viên phải dựa trên dữ liệu còn hiệu lực trong 12 tháng gần nhất.

---

### Quy tắc 3: Sau khi xử lý hết hạn phải xét lại hạng

Sau khi hệ thống loại bỏ dữ liệu loyalty đã hết hiệu lực, hệ thống cần xét lại hạng thành viên của khách hàng.

Nếu khách vẫn đủ điều kiện giữ hạng hiện tại, hạng được giữ nguyên.

Nếu khách không còn đủ điều kiện, hệ thống đưa khách về đúng hạng phù hợp với dữ liệu còn hiệu lực.

Ví dụ:

* khách đang là Gold;
* sau khi một số booking cũ hết hiệu lực, khách chỉ còn đủ điều kiện Silver;
* hệ thống hạ khách từ Gold xuống Silver.

---

### Quy tắc 4: Khi đổi điểm, ưu tiên dùng điểm cũ trước

Khi khách dùng điểm để đổi ưu đãi, hệ thống ưu tiên sử dụng các điểm cũ hơn trước.

Cách này gọi là FIFO — First In, First Out, nghĩa là điểm nào được tạo trước thì được dùng trước.

Lý do:

* giảm khả năng điểm cũ bị hết hạn trong khi điểm mới đã bị dùng;
* giúp việc tính điểm còn hiệu lực rõ ràng hơn;
* công bằng hơn cho khách hàng.

Ví dụ:

* booking A tạo 100 điểm vào tháng 01;
* booking B tạo 200 điểm vào tháng 03;
* khách đổi 150 điểm;
* hệ thống dùng hết 100 điểm từ booking A trước, sau đó dùng thêm 50 điểm từ booking B.

---

## 6. Luồng khi khách xem điểm loyalty

1. Khách mở trang xem điểm hoặc thông tin loyalty.
2. Hệ thống kiểm tra điểm nào đã quá 12 tháng.
3. Hệ thống loại các điểm đã hết hiệu lực khỏi điểm hiện có.
4. Hệ thống kiểm tra lại hạng thành viên nếu dữ liệu loyalty thay đổi.
5. Hệ thống hiển thị số điểm và hạng thành viên mới nhất cho khách.

---

## 7. Luồng khi khách đổi điểm

1. Khách chọn ưu đãi muốn đổi.
2. Trước khi cho đổi, hệ thống kiểm tra điểm hết hạn.
3. Hệ thống cập nhật lại số điểm còn hiệu lực.
4. Nếu khách không đủ điểm sau khi xử lý hết hạn, hệ thống không cho đổi.
5. Nếu khách đủ điểm, hệ thống trừ điểm theo nguyên tắc dùng điểm cũ trước.
6. Hệ thống ghi nhận việc đổi điểm thành công.
7. Hệ thống hiển thị số điểm còn lại cho khách.

---

## 8. Luồng khi booking mới hoàn thành

1. Khách hoàn thành một booking mới.
2. Hệ thống cộng điểm từ booking mới.
3. Trước hoặc sau khi cập nhật loyalty, hệ thống kiểm tra các dữ liệu cũ đã quá 12 tháng.
4. Hệ thống loại dữ liệu đã hết hiệu lực khỏi dữ liệu loyalty hiện hành.
5. Hệ thống xét lại hạng thành viên dựa trên dữ liệu còn hiệu lực.
6. Hệ thống cập nhật điểm và hạng mới nhất cho khách.

---

## 9. Các trường hợp cần xử lý

### Trường hợp 1: Khách không có điểm hết hạn

Nếu khách không có điểm hoặc dữ liệu loyalty nào quá 12 tháng, hệ thống giữ nguyên điểm và hạng hiện tại.

---

### Trường hợp 2: Khách có một phần điểm hết hạn

Nếu chỉ một phần điểm của khách hết hạn, hệ thống chỉ loại bỏ phần điểm đó.

Các điểm còn hiệu lực vẫn được giữ lại.

---

### Trường hợp 3: Khách bị thiếu điểm sau khi xử lý hết hạn

Nếu khách muốn đổi thưởng nhưng sau khi loại bỏ điểm hết hạn thì không còn đủ điểm, hệ thống không cho đổi thưởng.

---

### Trường hợp 4: Khách không còn đủ điều kiện giữ hạng

Nếu sau khi dữ liệu cũ hết hiệu lực, khách không còn đủ điều kiện giữ hạng hiện tại, hệ thống xét lại và đưa khách về đúng hạng phù hợp.

---

## 10. Kết quả mong đợi

Sau khi chức năng hoàn thành, hệ thống phải đảm bảo:

* điểm loyalty chỉ có hiệu lực trong 12 tháng;
* điểm hết hạn không thể dùng để đổi ưu đãi;
* lượt rửa và chi tiêu từ booking quá 12 tháng không còn được tính cho loyalty;
* hạng thành viên được xét lại sau khi dữ liệu cũ hết hiệu lực;
* khi đổi điểm, hệ thống ưu tiên dùng điểm cũ trước;
* khách luôn nhìn thấy số điểm còn hiệu lực mới nhất khi sử dụng chức năng loyalty;
* hệ thống không cần scheduler phức tạp, chỉ kiểm tra khi có hành động liên quan đến loyalty.

---

## 11. Phạm vi không xử lý trong issue này

Issue này không trực tiếp xử lý:

* cộng điểm mới sau booking hoàn thành;
* thuật toán xét hạng chi tiết;
* giao diện danh sách phần thưởng;
* admin tạo khuyến mãi;
* gửi khuyến mãi theo hạng;
* báo cáo doanh thu;
* báo cáo khách hàng.

Các phần đó sẽ được tách thành issue riêng.

---

# FR-13 — Admin Loyalty Configuration: Cấu hình luật loyalty cho Admin

## 1. Mục tiêu chức năng

Chức năng này cho phép Admin cấu hình các luật quan trọng của chương trình khách hàng thân thiết trong hệ thống AutoWash Pro.

FR-13 được tách thành 2 phần chính:

* **FR-13a — Admin cấu hình luật hạng thành viên**
* **FR-13b — Admin cấu hình tỷ lệ điểm theo hạng**

Mục tiêu của chức năng là giúp hệ thống loyalty linh hoạt hơn. Khi cửa hàng muốn thay đổi chính sách hạng thành viên hoặc cách cộng điểm, Admin có thể chỉnh trong hệ thống mà không cần sửa trực tiếp trong code.

---

# FR-13a — Admin cấu hình luật hạng thành viên

## 1. Mục tiêu chức năng

Chức năng này cho phép Admin cấu hình điều kiện xét hạng thành viên trong chương trình loyalty.

Admin có thể chỉnh điều kiện để khách hàng đạt các hạng:

* Silver;
* Gold;
* Platinum.

Các điều kiện được cấu hình gồm:

* số lượt rửa xe yêu cầu;
* tổng số tiền chi tiêu yêu cầu.

Hạng Member là hạng mặc định của khách hàng mới đăng ký, nên Admin không được chỉnh điều kiện của hạng Member trong chức năng này.

---

## 2. Ý nghĩa của chức năng

Chức năng này giúp cửa hàng thay đổi chính sách khách hàng thân thiết linh hoạt hơn.

Ví dụ:

* ban đầu Silver cần 5 lượt rửa hoặc 2.000.000 VND;
* sau này cửa hàng muốn Silver cần 6 lượt rửa hoặc 2.500.000 VND;
* Admin có thể cập nhật luật mới trên hệ thống.

Sau khi luật hạng được thay đổi, hệ thống cần xét lại hạng của toàn bộ khách hàng để đảm bảo hạng hiện tại phản ánh đúng luật mới.

---

## 3. Phạm vi Admin được cấu hình

Admin được cấu hình:

* số lượt rửa yêu cầu để đạt Silver;
* tổng chi tiêu yêu cầu để đạt Silver;
* số lượt rửa yêu cầu để đạt Gold;
* tổng chi tiêu yêu cầu để đạt Gold;
* số lượt rửa yêu cầu để đạt Platinum;
* tổng chi tiêu yêu cầu để đạt Platinum.

Admin không được cấu hình điều kiện của hạng Member.

Lý do: Member là hạng mặc định, dùng để đại diện cho khách hàng mới đăng ký hoặc khách chưa đủ điều kiện lên hạng cao hơn.

---

## 4. Luồng Admin xem luật hạng hiện tại

1. Admin mở trang cấu hình loyalty.
2. Admin chọn khu vực cấu hình luật hạng thành viên.
3. Hệ thống hiển thị danh sách hạng có thể cấu hình gồm Silver, Gold và Platinum.
4. Hệ thống hiển thị điều kiện hiện tại của từng hạng:

   * số lượt rửa yêu cầu;
   * tổng chi tiêu yêu cầu.
5. Admin xem các luật hiện tại trước khi quyết định chỉnh sửa.

Ví dụ hiển thị:

* Silver: 5 lượt rửa hoặc 2.000.000 VND;
* Gold: 15 lượt rửa hoặc 6.000.000 VND;
* Platinum: 30 lượt rửa hoặc 15.000.000 VND.

---

## 5. Luồng Admin cập nhật luật hạng thành công

1. Admin mở trang cấu hình loyalty.
2. Admin chọn phần cấu hình luật hạng thành viên.
3. Admin chỉnh điều kiện của Silver, Gold hoặc Platinum.
4. Admin bấm lưu thay đổi.
5. Hệ thống kiểm tra dữ liệu Admin nhập có hợp lệ không.
6. Nếu dữ liệu hợp lệ, hệ thống lưu luật hạng mới.
7. Hệ thống ghi lại lịch sử thay đổi cấu hình.
8. Sau khi lưu luật mới, hệ thống gọi chức năng xét lại hạng thành viên.
9. Hệ thống xét lại hạng của toàn bộ khách hàng dựa trên dữ liệu loyalty còn hiệu lực và luật mới.
10. Khách hàng nào đủ điều kiện hạng cao hơn sẽ được nâng hạng.
11. Khách hàng nào không còn đủ điều kiện giữ hạng hiện tại sẽ bị hạ về đúng hạng phù hợp.
12. Hệ thống thông báo Admin rằng luật hạng đã được cập nhật thành công.

---

## 6. Luồng cấu hình luật hạng không hợp lệ

### Trường hợp 1: Hạng cao có điều kiện thấp hơn hạng thấp

Hệ thống không cho phép Admin lưu luật khiến hạng cao dễ đạt hơn hạng thấp.

Ví dụ không hợp lệ:

* Silver cần 10 lượt rửa;
* Gold cần 5 lượt rửa.

Trường hợp này sai vì Gold là hạng cao hơn Silver nhưng lại yêu cầu số lượt rửa thấp hơn.

Hệ thống phải từ chối lưu và thông báo lỗi cho Admin.

---

### Trường hợp 2: Tổng chi tiêu của hạng cao thấp hơn hạng thấp

Ví dụ không hợp lệ:

* Silver cần 2.000.000 VND;
* Gold cần 1.000.000 VND.

Trường hợp này sai vì Gold là hạng cao hơn Silver nhưng lại yêu cầu tổng chi tiêu thấp hơn.

Hệ thống phải từ chối lưu và thông báo lỗi cho Admin.

---

### Trường hợp 3: Admin nhập giá trị không hợp lệ

Hệ thống không cho phép Admin lưu các giá trị không hợp lệ, ví dụ:

* số lượt rửa nhỏ hơn 0;
* tổng chi tiêu nhỏ hơn 0;
* bỏ trống điều kiện bắt buộc;
* nhập chữ vào ô yêu cầu số;
* nhập dữ liệu không có ý nghĩa với luật hạng.

Hệ thống phải thông báo rõ phần nào đang sai để Admin sửa lại.

---

## 7. Quy tắc nghiệp vụ của FR-13a

### Quy tắc 1: Member là hạng mặc định

Member là hạng mặc định của khách hàng mới đăng ký.

Admin không được chỉnh điều kiện của hạng Member.

---

### Quy tắc 2: Điều kiện xét hạng dùng logic “hoặc”

Một khách hàng được đạt hạng nếu thỏa mãn một trong hai điều kiện:

* đủ số lượt rửa yêu cầu;
* hoặc đủ tổng chi tiêu yêu cầu.

Ví dụ:

* Silver yêu cầu 5 lượt rửa hoặc 2.000.000 VND;
* khách có 5 lượt rửa nhưng chưa đủ 2.000.000 VND vẫn được lên Silver;
* khách chưa đủ 5 lượt rửa nhưng đã chi đủ 2.000.000 VND vẫn được lên Silver.

---

### Quy tắc 3: Hạng cao phải có điều kiện cao hơn hạng thấp

Luật cấu hình phải đảm bảo thứ tự hợp lý:

* Silver thấp hơn Gold;
* Gold thấp hơn Platinum.

Vì vậy:

* điều kiện của Gold không được thấp hơn Silver;
* điều kiện của Platinum không được thấp hơn Gold.

---

### Quy tắc 4: Sau khi đổi luật hạng phải xét lại toàn bộ khách hàng

Khi Admin thay đổi luật hạng thành viên, hệ thống phải xét lại hạng của toàn bộ khách hàng dựa trên luật mới.

Lý do: luật mới có thể làm một số khách đủ điều kiện lên hạng, hoặc làm một số khách không còn đủ điều kiện giữ hạng hiện tại.

Ví dụ:

* trước đây Gold cần 15 lượt rửa;
* Admin đổi Gold thành 20 lượt rửa;
* khách đang Gold nhưng chỉ có 16 lượt rửa còn hiệu lực;
* hệ thống cần xét lại và đưa khách về đúng hạng phù hợp.

---

### Quy tắc 5: Phải lưu lịch sử thay đổi luật hạng

Mỗi lần Admin thay đổi luật hạng, hệ thống cần lưu lịch sử thay đổi.

Thông tin lịch sử cần có:

* Admin nào thay đổi;
* thời điểm thay đổi;
* loại cấu hình bị thay đổi;
* giá trị cũ;
* giá trị mới.

Lý do:

* giúp kiểm tra lại khi có lỗi;
* giúp giải thích vì sao hạng khách hàng thay đổi;
* giúp Admin biết ai đã thay đổi chính sách loyalty.

---

## 8. Kết quả mong đợi của FR-13a

Sau khi chức năng hoàn thành, hệ thống phải đảm bảo:

* Admin xem được luật hạng hiện tại;
* Admin chỉnh được điều kiện của Silver, Gold và Platinum;
* Admin không chỉnh được điều kiện của Member;
* hệ thống chặn luật cấu hình sai;
* hạng cao không thể có điều kiện thấp hơn hạng thấp;
* sau khi lưu luật mới, hệ thống xét lại hạng của toàn bộ khách hàng;
* khách hàng được cập nhật về đúng hạng phù hợp theo luật mới;
* hệ thống lưu lịch sử thay đổi cấu hình;
* hệ thống thông báo rõ kết quả cập nhật cho Admin.

---

# FR-13b — Admin cấu hình tỷ lệ điểm theo hạng

## 1. Mục tiêu chức năng

Chức năng này cho phép Admin cấu hình tỷ lệ cộng điểm loyalty trong hệ thống AutoWash Pro.

Admin có thể cấu hình:

* tỷ lệ điểm cơ bản theo số tiền khách chi tiêu;
* hệ số cộng thêm điểm theo từng hạng thành viên.

Ví dụ:

* 1 điểm tương ứng với 1.000 VND chi tiêu;
* Silver được cộng thêm 10% điểm;
* Gold được cộng thêm 20% điểm;
* Platinum được cộng thêm 30% điểm.

Mục tiêu của FR này là giúp luật cộng điểm có thể được điều chỉnh bởi Admin, thay vì bị cố định cứng trong hệ thống.

---

## 2. Ý nghĩa của chức năng

Trong chương trình loyalty, điểm thưởng là yếu tố quan trọng để giữ chân khách hàng.

Nếu cửa hàng muốn thay đổi chính sách tích điểm, Admin cần có khả năng cấu hình lại tỷ lệ điểm.

Ví dụ:

* giai đoạn bình thường: 1 điểm = 1.000 VND;
* giai đoạn khuyến khích khách quay lại: 1 điểm = 800 VND;
* Silver từ +10% điểm đổi thành +15% điểm;
* Gold từ +20% điểm đổi thành +25% điểm.

Chức năng này giúp hệ thống linh hoạt hơn khi cửa hàng muốn thay đổi chính sách loyalty.

---

## 3. Mối liên hệ với các FR khác

FR-13b không trực tiếp cộng điểm cho khách.

FR-13b chỉ quản lý luật cộng điểm.

Việc cộng điểm thật sự diễn ra ở FR-09 khi booking được hoàn thành.

Nói cách khác:

* FR-13b: Admin cấu hình tỷ lệ điểm;
* FR-09: hệ thống dùng tỷ lệ đó để tính điểm sau booking hoàn thành;
* FR-10a: sau khi cộng điểm, hệ thống xét lại hạng thành viên;
* FR-10b: tự động kích hoạt xét lại hạng khi dữ liệu loyalty thay đổi.

---

## 4. Đối tượng sử dụng

Chỉ Admin hoặc Manager mới được sử dụng chức năng này.

Khách hàng không được quyền xem hoặc chỉnh tỷ lệ cộng điểm của hệ thống.

Khách hàng chỉ nhìn thấy điểm nhận được sau mỗi lần hoàn thành booking hoặc trong lịch sử loyalty cá nhân.

---

## 5. Khi nào chức năng này chạy?

Chức năng này chạy khi Admin mở trang cấu hình tỷ lệ điểm trong khu vực quản trị.

Admin có thể:

* xem tỷ lệ điểm hiện tại;
* chỉnh tỷ lệ điểm cơ bản;
* chỉnh hệ số cộng điểm theo hạng;
* lưu chính sách điểm mới.

---

## 6. Phạm vi Admin được cấu hình

Admin được cấu hình hai nhóm luật chính.

### Nhóm 1: Tỷ lệ điểm cơ bản

Tỷ lệ điểm cơ bản là luật quy đổi từ số tiền chi tiêu sang điểm loyalty.

Ví dụ:

* 1 điểm = 1.000 VND;
* 1 điểm = 2.000 VND;
* 1 điểm = 500 VND.

Tỷ lệ này áp dụng trước cho mọi khách hàng khi phát sinh booking hoàn thành.

---

### Nhóm 2: Hệ số cộng điểm theo hạng

Sau khi tính điểm cơ bản, hệ thống áp dụng thêm hệ số điểm theo hạng thành viên hiện tại của khách.

Ví dụ:

* Member: không cộng thêm;
* Silver: cộng thêm 10%;
* Gold: cộng thêm 20%;
* Platinum: cộng thêm 30%.

Ví dụ nghiệp vụ:

* khách chi 100.000 VND;
* tỷ lệ cơ bản là 1 điểm = 1.000 VND;
* điểm cơ bản là 100 điểm;
* khách Gold được cộng thêm 20%;
* tổng điểm khách nhận là 120 điểm.

---

## 7. Luồng hoạt động chính

### Luồng Admin xem tỷ lệ điểm hiện tại

1. Admin đăng nhập vào hệ thống.
2. Admin mở trang cấu hình tỷ lệ điểm loyalty.
3. Hệ thống kiểm tra quyền truy cập của Admin.
4. Nếu hợp lệ, hệ thống hiển thị luật cộng điểm hiện tại.
5. Admin xem được tỷ lệ điểm cơ bản và hệ số cộng điểm theo từng hạng.

Ví dụ hiển thị:

* điểm cơ bản: 1 điểm = 1.000 VND;
* Member: +0%;
* Silver: +10%;
* Gold: +20%;
* Platinum: +30%.

---

### Luồng Admin cập nhật tỷ lệ điểm thành công

1. Admin mở trang cấu hình tỷ lệ điểm loyalty.
2. Admin chỉnh tỷ lệ điểm cơ bản.
3. Admin chỉnh hệ số cộng điểm theo hạng nếu cần.
4. Admin bấm lưu thay đổi.
5. Hệ thống kiểm tra luật mới có hợp lệ không.
6. Nếu luật hợp lệ, hệ thống lưu chính sách điểm mới.
7. Từ các booking hoàn thành sau thời điểm thay đổi, hệ thống áp dụng tỷ lệ điểm mới.
8. Hệ thống thông báo Admin rằng tỷ lệ cộng điểm đã được cập nhật thành công.

---

## 8. Luồng lỗi và trường hợp không hợp lệ

### Trường hợp 1: Người dùng không phải Admin hoặc Manager

Nếu người dùng không có quyền quản trị, hệ thống không cho truy cập chức năng cấu hình tỷ lệ điểm.

Kết quả mong đợi:

* hệ thống từ chối truy cập;
* người dùng không xem được trang cấu hình;
* người dùng không sửa được tỷ lệ điểm.

---

### Trường hợp 2: Tỷ lệ điểm cơ bản không hợp lệ

Hệ thống không cho phép Admin lưu tỷ lệ điểm cơ bản không hợp lệ.

Ví dụ không hợp lệ:

* số tiền quy đổi nhỏ hơn hoặc bằng 0;
* bỏ trống tỷ lệ điểm;
* nhập giá trị không có ý nghĩa nghiệp vụ.

Ví dụ:

* 1 điểm = 0 VND là không hợp lệ;
* 1 điểm = -1.000 VND là không hợp lệ.

---

### Trường hợp 3: Hệ số cộng điểm theo hạng không hợp lệ

Hệ thống không cho phép Admin lưu hệ số cộng điểm không hợp lệ.

Ví dụ không hợp lệ:

* phần trăm cộng điểm nhỏ hơn 0;
* bỏ trống hệ số bắt buộc;
* nhập giá trị quá bất thường nếu hệ thống có giới hạn nghiệp vụ.

Ví dụ:

* Silver = -10% là không hợp lệ;
* Gold bị bỏ trống là không hợp lệ.

---

### Trường hợp 4: Hạng cao có hệ số thấp hơn hạng thấp

Hệ thống không nên cho phép luật điểm khiến hạng cao nhận ít điểm hơn hạng thấp.

Ví dụ không hợp lệ:

* Silver: +20%;
* Gold: +10%.

Trường hợp này sai về mặt loyalty vì Gold là hạng cao hơn Silver nhưng lại nhận ít điểm thưởng hơn.

Hệ thống cần từ chối lưu và thông báo Admin sửa lại.

---

### Trường hợp 5: Admin hủy thay đổi

Nếu Admin chỉnh thông tin nhưng không lưu, hệ thống không áp dụng thay đổi.

Tỷ lệ điểm hiện tại vẫn được giữ nguyên.

---

## 9. Quy tắc nghiệp vụ

### Quy tắc 1: Chỉ Admin hoặc Manager được cấu hình tỷ lệ điểm

Tỷ lệ điểm ảnh hưởng trực tiếp đến loyalty và chi phí ưu đãi của cửa hàng.

Vì vậy, khách hàng thông thường không được phép chỉnh hoặc truy cập chức năng này.

---

### Quy tắc 2: Tỷ lệ điểm mới chỉ áp dụng cho booking hoàn thành sau khi thay đổi

Khi Admin cập nhật tỷ lệ điểm, hệ thống áp dụng luật mới cho các booking hoàn thành sau thời điểm thay đổi.

Các điểm đã cộng trong quá khứ không bị tính lại.

Lý do:

* tránh thay đổi lịch sử điểm của khách;
* giữ dữ liệu loyalty đã phát sinh được ổn định;
* tránh gây tranh cãi khi điểm cũ bị thay đổi.

Ví dụ:

* ngày 01/07, khách hoàn thành booking và nhận 100 điểm theo luật cũ;
* ngày 02/07, Admin đổi tỷ lệ điểm;
* 100 điểm đã cộng trước đó vẫn giữ nguyên;
* các booking hoàn thành từ sau ngày 02/07 mới áp dụng luật mới.

---

### Quy tắc 3: Hạng cao phải có hệ số điểm bằng hoặc cao hơn hạng thấp

Luật điểm phải phản ánh đúng giá trị của hạng thành viên.

Hạng càng cao thì quyền lợi điểm không được thấp hơn hạng thấp.

Thứ tự hợp lệ:

* Member thấp hơn hoặc bằng Silver;
* Silver thấp hơn hoặc bằng Gold;
* Gold thấp hơn hoặc bằng Platinum.

Ví dụ hợp lệ:

* Member: +0%;
* Silver: +10%;
* Gold: +20%;
* Platinum: +30%.

Ví dụ không hợp lệ:

* Member: +0%;
* Silver: +20%;
* Gold: +10%;
* Platinum: +30%.

---

### Quy tắc 4: Tỷ lệ điểm cơ bản phải lớn hơn 0

Hệ thống chỉ cho phép tỷ lệ điểm cơ bản có giá trị hợp lệ.

Nếu tỷ lệ điểm cơ bản bằng 0 hoặc âm, hệ thống không thể tính điểm có ý nghĩa.

Ví dụ hợp lệ:

* 1 điểm = 1.000 VND;
* 1 điểm = 2.000 VND.

Ví dụ không hợp lệ:

* 1 điểm = 0 VND;
* 1 điểm = -500 VND.

---

### Quy tắc 5: FR-13b không tự cộng điểm lại cho dữ liệu cũ

FR-13b chỉ thay đổi luật cộng điểm cho các lần phát sinh mới.

FR này không xử lý việc tính lại điểm cho booking cũ.

Điểm đã được cộng trước đó vẫn giữ nguyên theo lịch sử đã ghi nhận.

---

### Quy tắc 6: FR-13b không thay đổi điều kiện xét hạng

FR-13b chỉ cấu hình tỷ lệ điểm.

Điều kiện để khách đạt Silver, Gold hoặc Platinum thuộc về FR-13a.

Ví dụ FR-13b được chỉnh:

* Silver +15% điểm;
* Gold +25% điểm.

Ví dụ FR-13b không chỉnh:

* Silver cần 5 lượt rửa;
* Gold cần 15 lượt rửa;
* Platinum cần 30 lượt rửa.

---

### Quy tắc 7: FR-09 phải dùng tỷ lệ điểm đang có hiệu lực

Khi booking hoàn thành và hệ thống cộng điểm cho khách, hệ thống phải dùng tỷ lệ điểm hiện tại đang có hiệu lực.

Không được hardcode tỷ lệ điểm trong luồng cộng điểm.

Hardcode nghĩa là viết cố định một giá trị trong hệ thống, khiến Admin không thể thay đổi qua cấu hình.

---

### Quy tắc 8: Phải lưu lịch sử thay đổi tỷ lệ điểm

Mỗi lần Admin thay đổi tỷ lệ điểm, hệ thống cần lưu lịch sử thay đổi.

Thông tin lịch sử cần có:

* Admin nào thay đổi;
* thời điểm thay đổi;
* loại cấu hình bị thay đổi;
* giá trị cũ;
* giá trị mới.

Lý do:

* giúp kiểm tra lại chính sách tính điểm tại từng thời điểm;
* giúp giải thích vì sao booking mới nhận số điểm khác booking cũ;
* giúp Admin truy vết thay đổi nếu có lỗi.

---

## 10. Kết quả mong đợi

Sau khi chức năng hoàn thành, hệ thống phải đảm bảo:

* Admin xem được tỷ lệ điểm hiện tại;
* Admin chỉnh được tỷ lệ quy đổi tiền sang điểm;
* Admin chỉnh được hệ số cộng điểm theo hạng;
* hệ thống chặn tỷ lệ điểm không hợp lệ;
* hạng cao không được có tỷ lệ điểm thấp hơn hạng thấp;
* tỷ lệ điểm mới chỉ áp dụng cho booking hoàn thành sau thời điểm thay đổi;
* điểm đã cộng trong quá khứ không bị tính lại;
* FR-09 sử dụng tỷ lệ điểm hiện tại khi cộng điểm;
* hệ thống lưu lịch sử thay đổi cấu hình;
* khách hàng thông thường không truy cập được chức năng cấu hình tỷ lệ điểm.

---

## 11. Phạm vi không xử lý trong issue này

Issue này không trực tiếp xử lý:

* cộng điểm sau booking hoàn thành;
* xét hạng thành viên;
* cấu hình điều kiện lên hạng;
* đổi điểm lấy ưu đãi;
* điểm hết hạn sau 12 tháng;
* gửi khuyến mãi theo hạng;
* báo cáo khách hàng;
* báo cáo doanh thu;
* tính lại điểm lịch sử;
* hoàn điểm thủ công;
* tạo chương trình khuyến mãi;
* quản lý voucher phức tạp.

Các phần trên nếu cần sẽ được tách thành issue riêng.

---

## 12. Ghi chú cho nhóm phát triển

FR-13b nên được hiểu là chức năng quản lý luật cộng điểm.

Chức năng này không tạo điểm trực tiếp cho khách hàng.

Nó chỉ quyết định hệ thống sẽ dùng tỷ lệ nào khi FR-09 cộng điểm sau booking hoàn thành.

Các FR liên quan gồm:

* FR-09: dùng tỷ lệ điểm hiện tại để cộng điểm sau booking hoàn thành;
* FR-10a: xét lại hạng sau khi loyalty thay đổi;
* FR-10b: kích hoạt xét lại hạng khi dữ liệu loyalty thay đổi;
* FR-13a: cấu hình điều kiện xét hạng thành viên.

Mục tiêu cuối cùng là giúp Admin kiểm soát chính sách cộng điểm của chương trình loyalty một cách linh hoạt và rõ ràng.

---

## 9. Ảnh hưởng đến các chức năng khác

FR-13 ảnh hưởng trực tiếp đến các chức năng loyalty khác.

### 9.1. Ảnh hưởng đến FR-09 — Tích điểm tự động

FR-09 cần dùng tỷ lệ điểm hiện tại để tính điểm cho booking mới hoàn thành.

Nếu Admin thay đổi tỷ lệ điểm trong FR-13b, FR-09 phải dùng tỷ lệ mới cho các booking hoàn thành sau thời điểm thay đổi.

---

### 9.2. Ảnh hưởng đến FR-10a — Xét hạng thành viên

FR-10a cần dùng luật hạng hiện tại để xét khách thuộc Member, Silver, Gold hay Platinum.

Nếu Admin thay đổi luật hạng trong FR-13a, FR-10a phải xét lại hạng khách hàng dựa trên luật mới.

---

### 9.3. Ảnh hưởng đến FR-10b — Tự động kích hoạt xét lại hạng

Sau khi Admin thay đổi luật hạng trong FR-13a, FR-10b cần kích hoạt quá trình xét lại hạng cho toàn bộ khách hàng.

Tuy nhiên, nếu Admin chỉ thay đổi tỷ lệ điểm trong FR-13b, hệ thống không cần xét lại toàn bộ khách hàng ngay, vì tỷ lệ điểm mới chỉ áp dụng cho booking mới.

---

### 9.4. Ảnh hưởng đến FR-12 — Điểm hết hạn sau 12 tháng

Điểm được tạo ra từ booking vẫn hết hạn sau 12 tháng theo thời điểm booking hoàn thành.

Việc Admin thay đổi tỷ lệ điểm không làm thay đổi hạn sử dụng của điểm cũ.

---

## 10. Phạm vi không xử lý trong FR-13

FR-13 không trực tiếp xử lý:

* cộng điểm sau booking hoàn thành;
* xét hạng chi tiết cho từng khách hàng;
* đổi điểm lấy ưu đãi;
* xử lý điểm hết hạn sau 12 tháng;
* gửi khuyến mãi theo hạng;
* báo cáo khách hàng;
* báo cáo doanh thu;
* quản lý chi tiết nội dung promotion nếu nhóm tách promotion thành issue riêng.

Các phần trên sẽ được xử lý ở các issue khác.

---

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

---

# FR-15 — Báo cáo thống kê khách hàng dành cho Admin

## 1. Mục tiêu chức năng

Chức năng này cho phép Admin xem báo cáo tổng quan về khách hàng trong hệ thống AutoWash Pro.

Báo cáo tập trung vào tình trạng khách hàng và chương trình loyalty, bao gồm:

* tổng số khách hàng;
* số khách hàng mới;
* số khách hàng theo từng hạng thành viên;
* số khách hàng có điểm loyalty;
* số khách hàng đã đổi ưu đãi;
* số khách hàng được nâng hoặc hạ hạng gần đây.

Mục tiêu của FR này là giúp Admin hiểu được tình hình khách hàng hiện tại và đánh giá chương trình loyalty có đang hoạt động hiệu quả hay không.

---

## 2. Ý nghĩa của chức năng

Sau khi hệ thống có các chức năng tích điểm, xét hạng, đổi điểm và gửi khuyến mãi theo hạng, Admin cần một nơi để xem các số liệu tổng quan.

Nếu không có báo cáo khách hàng, Admin chỉ biết hệ thống đang chạy nhưng không biết:

* hiện có bao nhiêu khách hàng;
* khách hàng chủ yếu đang ở hạng nào;
* có bao nhiêu khách thật sự tham gia loyalty;
* có bao nhiêu khách đã dùng điểm để đổi ưu đãi;
* chương trình loyalty có giúp khách lên hạng hay không.

FR-15 giúp Admin có cái nhìn rõ hơn về dữ liệu khách hàng để hỗ trợ quản lý và ra quyết định.

Ví dụ:

* nếu phần lớn khách vẫn ở Member, Admin có thể xem lại chương trình khuyến mãi hoặc reward;
* nếu số khách Silver, Gold tăng lên, loyalty program đang có hiệu quả;
* nếu nhiều khách có điểm nhưng không đổi ưu đãi, reward có thể chưa đủ hấp dẫn.

---

## 3. Đối tượng sử dụng

Chức năng này dành cho Admin hoặc Manager.

Khách hàng không được truy cập báo cáo tổng quan của toàn bộ hệ thống.

Khách hàng chỉ được xem thông tin loyalty cá nhân của chính họ ở chức năng khác.

---

## 4. Khi nào chức năng này chạy?

Chức năng này chạy khi Admin mở trang báo cáo khách hàng trong khu vực quản trị.

Trước khi hiển thị báo cáo, hệ thống cần đảm bảo dữ liệu loyalty đang phản ánh trạng thái mới nhất ở mức cần thiết.

Nếu dữ liệu hạng, điểm hoặc loyalty đã thay đổi do các chức năng khác, báo cáo phải dùng dữ liệu mới nhất đã được cập nhật.

---

## 5. Các nhóm số liệu cần hiển thị

### Nhóm 1: Tổng quan khách hàng

Admin cần xem được các chỉ số cơ bản:

* tổng số khách hàng trong hệ thống;
* số khách hàng mới;
* số khách hàng đang có tài khoản loyalty;
* số khách hàng từng hoàn thành ít nhất một lần rửa xe.

Ý nghĩa:

* tổng số khách hàng cho biết quy mô hệ thống;
* khách hàng mới cho biết tốc độ tăng trưởng;
* khách có loyalty cho biết mức độ tham gia chương trình khách hàng thân thiết;
* khách từng hoàn thành rửa xe cho biết số khách thật sự sử dụng dịch vụ.

---

### Nhóm 2: Phân bổ khách hàng theo hạng thành viên

Admin cần xem số lượng khách hàng theo từng hạng:

* Member;
* Silver;
* Gold;
* Platinum.

Ví dụ báo cáo:

* Member: 120 khách;
* Silver: 50 khách;
* Gold: 25 khách;
* Platinum: 5 khách.

Ý nghĩa:

* giúp Admin biết đa số khách đang ở hạng nào;
* giúp đánh giá điều kiện lên hạng có quá dễ hoặc quá khó không;
* giúp hỗ trợ các chiến dịch khuyến mãi theo hạng.

---

### Nhóm 3: Hoạt động loyalty cơ bản

Admin cần xem các số liệu loyalty ở mức tổng quan:

* số khách hàng có điểm loyalty;
* số khách hàng đã từng đổi ưu đãi;
* số lượt đổi ưu đãi;
* số khách có điểm nhưng chưa từng đổi ưu đãi.

Ý nghĩa:

* nếu nhiều khách có điểm nhưng không đổi ưu đãi, có thể reward chưa hấp dẫn;
* nếu nhiều khách đổi ưu đãi, chương trình loyalty đang có tác dụng;
* nếu ít khách có điểm, có thể lượng booking hoàn thành còn thấp hoặc loyalty chưa được dùng nhiều.

---

### Nhóm 4: Biến động hạng thành viên gần đây

Admin cần xem được biến động hạng ở mức cơ bản:

* số khách được nâng hạng gần đây;
* số khách bị hạ hạng gần đây;
* số khách giữ nguyên hạng.

Ý nghĩa:

* nâng hạng cho thấy khách quay lại và chi tiêu nhiều hơn;
* hạ hạng cho thấy dữ liệu loyalty cũ đã hết hiệu lực hoặc khách ít quay lại;
* giữ nguyên hạng cho thấy khách chưa có thay đổi đáng kể.

---

## 6. Luồng hoạt động chính

### Luồng xem báo cáo thành công

1. Admin đăng nhập vào hệ thống.
2. Admin mở trang báo cáo khách hàng.
3. Hệ thống kiểm tra quyền truy cập của người dùng.
4. Nếu người dùng là Admin hoặc Manager, hệ thống cho phép truy cập báo cáo.
5. Hệ thống lấy các số liệu khách hàng cần thiết.
6. Hệ thống tổng hợp số lượng khách hàng theo từng nhóm báo cáo.
7. Hệ thống hiển thị báo cáo cho Admin.
8. Admin xem được tình trạng khách hàng và loyalty ở mức tổng quan.

---

## 7. Luồng lỗi và trường hợp không hợp lệ

### Trường hợp 1: Người dùng không phải Admin hoặc Manager

Nếu người dùng không có quyền quản trị, hệ thống không cho xem báo cáo khách hàng.

Lý do: báo cáo khách hàng là dữ liệu quản trị, không dành cho khách hàng thông thường.

Kết quả mong đợi:

* hệ thống từ chối truy cập;
* người dùng không xem được dữ liệu khách hàng toàn hệ thống.

---

### Trường hợp 2: Chưa có dữ liệu khách hàng

Nếu hệ thống chưa có khách hàng nào, báo cáo vẫn phải hiển thị được.

Thay vì báo lỗi, hệ thống nên hiển thị số liệu bằng 0.

Ví dụ:

* tổng số khách hàng: 0;
* Member: 0;
* Silver: 0;
* Gold: 0;
* Platinum: 0;
* số khách đã đổi ưu đãi: 0.

---

### Trường hợp 3: Chưa có dữ liệu loyalty

Nếu đã có khách hàng nhưng chưa có ai hoàn thành booking hoặc chưa phát sinh điểm loyalty, hệ thống vẫn hiển thị báo cáo khách hàng cơ bản.

Các số liệu loyalty có thể hiển thị là 0.

Ví dụ:

* tổng khách hàng: 20;
* khách có điểm loyalty: 0;
* khách đã đổi ưu đãi: 0.

---

### Trường hợp 4: Dữ liệu loyalty chưa được làm mới

Nếu có dữ liệu loyalty cũ đã hết hiệu lực hoặc hạng khách hàng chưa được cập nhật, báo cáo có thể bị sai.

Vì vậy, hệ thống cần dùng dữ liệu loyalty mới nhất đã được xử lý bởi các chức năng liên quan trước khi hiển thị báo cáo.

Ví dụ:

* khách đã bị hạ từ Gold xuống Silver do dữ liệu cũ hết hiệu lực;
* báo cáo phải tính khách này vào Silver, không còn tính vào Gold.

---

## 8. Quy tắc nghiệp vụ

### Quy tắc 1: Báo cáo chỉ dành cho Admin hoặc Manager

Chỉ người dùng có quyền quản trị mới được xem báo cáo khách hàng.

Khách hàng thông thường không được xem:

* tổng số khách toàn hệ thống;
* danh sách hoặc phân bổ khách theo hạng;
* thống kê đổi ưu đãi của toàn hệ thống.

---

### Quy tắc 2: Báo cáo phải dùng hạng hiện tại của khách hàng

Khi thống kê khách theo hạng, hệ thống phải dùng hạng hiện tại của khách.

Không dùng hạng cũ hoặc hạng lịch sử để tính vào báo cáo hiện tại.

Ví dụ:

* khách trước đây là Gold;
* hiện tại đã bị hạ xuống Silver;
* báo cáo hiện tại phải tính khách đó là Silver.

---

### Quy tắc 3: Khách mới mặc định thuộc Member

Khách mới đăng ký được tính vào nhóm Member.

Tuy nhiên, loyalty của khách chỉ thật sự có ý nghĩa sau khi khách hoàn thành ít nhất một lần rửa xe.

Vì vậy, báo cáo có thể phân biệt giữa:

* khách Member mới đăng ký;
* khách Member đã từng phát sinh hoạt động loyalty.

---

### Quy tắc 4: Số liệu loyalty phải dựa trên dữ liệu còn hiệu lực

Các thống kê liên quan đến điểm, hạng, lượt rửa và chi tiêu loyalty cần dựa trên dữ liệu còn hiệu lực.

Dữ liệu từ booking quá 12 tháng không còn được tính cho loyalty hiện tại.

Ví dụ:

* khách từng có nhiều điểm nhưng điểm đã hết hạn;
* báo cáo điểm hiện tại không được tính các điểm đã hết hạn.

---

### Quy tắc 5: Báo cáo không thay thế chức năng xét hạng

FR-15 chỉ hiển thị báo cáo.

FR-15 không trực tiếp quyết định khách thuộc hạng nào.

Việc xét khách là Member, Silver, Gold hay Platinum thuộc về FR-10a.

Việc kích hoạt xét lại hạng khi dữ liệu loyalty thay đổi thuộc về FR-10b.

---

### Quy tắc 6: Báo cáo phải dễ hiểu cho Admin

Số liệu cần được trình bày rõ ràng để Admin hiểu nhanh tình hình khách hàng.

Admin không nên phải tự tính toán thủ công từ dữ liệu thô.

Ví dụ báo cáo nên trả lời được các câu hỏi:

* hệ thống hiện có bao nhiêu khách?
* hạng nào có nhiều khách nhất?
* có bao nhiêu khách đã tham gia loyalty?
* có bao nhiêu khách đã đổi ưu đãi?
* gần đây có bao nhiêu khách được nâng hoặc hạ hạng?

---

## 9. Kết quả mong đợi

Sau khi chức năng hoàn thành, hệ thống phải đảm bảo:

* Admin xem được báo cáo tổng quan về khách hàng;
* Admin xem được tổng số khách hàng;
* Admin xem được số khách hàng mới;
* Admin xem được số lượng khách theo từng hạng Member, Silver, Gold và Platinum;
* Admin xem được số khách có điểm loyalty;
* Admin xem được số khách đã đổi ưu đãi;
* Admin xem được biến động hạng cơ bản như nâng hạng và hạ hạng gần đây;
* khách hàng thông thường không truy cập được báo cáo toàn hệ thống;
* khi chưa có dữ liệu, báo cáo vẫn hiển thị ổn định với số liệu bằng 0;
* báo cáo dùng hạng hiện tại và dữ liệu loyalty còn hiệu lực;
* báo cáo giúp Admin đánh giá tình trạng khách hàng và loyalty ở mức tổng quan.

---

## 10. Phạm vi không xử lý trong issue này

Issue này không trực tiếp xử lý:

* báo cáo doanh thu;
* báo cáo booking chi tiết;
* báo cáo dịch vụ bán chạy;
* báo cáo hiệu quả từng chiến dịch khuyến mãi;
* dự đoán khách hàng rời bỏ;
* cá nhân hóa bằng AI;
* gửi khuyến mãi theo hạng;
* cộng điểm loyalty;
* đổi điểm lấy ưu đãi;
* xét hạng thành viên;
* cấu hình luật hạng;
* xuất file báo cáo nâng cao.

Các phần trên nếu cần sẽ được tách thành issue riêng.

---

## 11. Ghi chú cho nhóm phát triển

FR-15 nên được hiểu là chức năng báo cáo khách hàng ở mức quản trị.

Chức năng này không tạo điểm, không đổi điểm, không xét hạng và không gửi khuyến mãi.

Nó chỉ tổng hợp dữ liệu đã có để Admin xem được tình hình khách hàng và loyalty.

Các FR liên quan gồm:

* FR-09: tạo dữ liệu điểm, lượt rửa và chi tiêu;
* FR-10a: xác định hạng thành viên;
* FR-10b: đảm bảo hạng được cập nhật khi dữ liệu loyalty thay đổi;
* FR-11: tạo dữ liệu đổi ưu đãi;
* FR-12: xử lý dữ liệu loyalty hết hạn;
* FR-14a: dùng phân nhóm hạng để gửi khuyến mãi.

Mục tiêu cuối cùng là giúp Admin nhìn được bức tranh tổng quan về khách hàng trong hệ thống AutoWash Pro.

---

# FR-16 — Báo cáo doanh thu và lịch đặt dành cho Admin

## 1. Mục tiêu chức năng

Chức năng này cho phép Admin xem báo cáo tổng quan về doanh thu và tình hình booking của hệ thống AutoWash Pro.

Báo cáo tập trung vào hai nhóm dữ liệu chính:

* doanh thu từ các booking đã hoàn thành;
* tình trạng hoạt động của lịch đặt trong hệ thống.

Mục tiêu của FR này là giúp Admin biết cửa hàng đang vận hành như thế nào, doanh thu đang ở mức nào và booking có đang được xử lý hiệu quả hay không.

---

## 2. Ý nghĩa của chức năng

Sau khi hệ thống có chức năng booking, hoàn thành dịch vụ, loyalty và reward, Admin cần báo cáo để theo dõi hiệu quả kinh doanh.

Nếu không có báo cáo doanh thu và booking, Admin sẽ khó trả lời các câu hỏi như:

* hôm nay cửa hàng có bao nhiêu booking?
* bao nhiêu booking đã hoàn thành?
* bao nhiêu booking bị hủy?
* doanh thu hôm nay là bao nhiêu?
* tháng này doanh thu tăng hay giảm?
* dịch vụ nào được khách đặt nhiều?
* hạng thành viên nào mang lại nhiều doanh thu hơn?

FR-16 giúp Admin nhìn được tình hình vận hành và doanh thu ở mức tổng quan, từ đó hỗ trợ việc quản lý cửa hàng.

---

## 3. Đối tượng sử dụng

Chức năng này dành cho Admin hoặc Manager.

Khách hàng không được truy cập báo cáo doanh thu và booking toàn hệ thống.

Khách hàng chỉ được xem lịch sử booking và thông tin cá nhân của chính họ ở chức năng khác.

---

## 4. Khi nào chức năng này chạy?

Chức năng này chạy khi Admin mở trang báo cáo doanh thu và booking trong khu vực quản trị.

Admin có thể xem báo cáo theo các khoảng thời gian khác nhau, ví dụ:

* hôm nay;
* tuần này;
* tháng này;
* năm nay;
* một khoảng thời gian được chọn.

Trong phạm vi issue này, báo cáo chỉ cần tập trung vào dữ liệu tổng quan, không cần phân tích nâng cao hoặc dự đoán doanh thu.

---

## 5. Các nhóm số liệu cần hiển thị

### Nhóm 1: Doanh thu tổng quan

Admin cần xem được các chỉ số doanh thu cơ bản:

* tổng doanh thu;
* doanh thu theo ngày;
* doanh thu theo tháng;
* doanh thu theo năm;
* doanh thu trong khoảng thời gian được chọn.

Chỉ các booking đã hoàn thành và có phát sinh thanh toán hợp lệ mới được tính vào doanh thu.

Ý nghĩa:

* giúp Admin biết cửa hàng đang thu được bao nhiêu tiền;
* giúp theo dõi tăng trưởng doanh thu theo thời gian;
* giúp phát hiện thời điểm doanh thu thấp hoặc cao bất thường.

---

### Nhóm 2: Thống kê booking theo trạng thái

Admin cần xem số lượng booking theo từng trạng thái nghiệp vụ, ví dụ:

* booking đã hoàn thành;
* booking đang chờ xử lý;
* booking đã xác nhận;
* booking bị hủy;
* booking không đến nếu hệ thống có ghi nhận.

Ý nghĩa:

* booking hoàn thành cho biết số lượt rửa thực tế;
* booking bị hủy cho biết mức độ thất thoát lịch đặt;
* booking đang chờ hoặc đã xác nhận giúp Admin nắm tình hình vận hành hiện tại.

---

### Nhóm 3: Tỷ lệ hoàn thành và hủy booking

Admin cần xem các chỉ số tổng quan như:

* tổng số booking trong khoảng thời gian;
* số booking hoàn thành;
* số booking bị hủy;
* tỷ lệ booking hoàn thành;
* tỷ lệ booking bị hủy.

Tỷ lệ hoàn thành là phần trăm booking đã hoàn thành trên tổng số booking trong kỳ.

Tỷ lệ hủy là phần trăm booking bị hủy trên tổng số booking trong kỳ.

Ý nghĩa:

* nếu tỷ lệ hủy cao, cửa hàng cần xem lại quy trình đặt lịch;
* nếu tỷ lệ hoàn thành cao, hệ thống booking đang hoạt động ổn định;
* nếu nhiều booking chờ xử lý, Admin cần kiểm tra khả năng vận hành.

---

### Nhóm 4: Dịch vụ được đặt nhiều

Admin cần xem các dịch vụ có nhiều booking nhất trong khoảng thời gian được chọn.

Ví dụ:

* rửa xe cơ bản;
* rửa xe cao cấp;
* wax;
* vệ sinh nội thất;
* nâng cấp gói dịch vụ.

Ý nghĩa:

* giúp Admin biết dịch vụ nào được khách quan tâm nhiều;
* hỗ trợ quyết định chạy khuyến mãi;
* hỗ trợ điều chỉnh nhân lực hoặc thời gian phục vụ;
* giúp phát hiện dịch vụ ít người dùng để cải thiện.

---

### Nhóm 5: Doanh thu theo hạng thành viên

Nếu hệ thống có dữ liệu hạng thành viên tại thời điểm booking, Admin có thể xem doanh thu theo nhóm khách hàng:

* Member;
* Silver;
* Gold;
* Platinum.

Ý nghĩa:

* giúp Admin biết nhóm khách nào đóng góp doanh thu nhiều;
* hỗ trợ việc đánh giá chương trình loyalty;
* giúp Admin thiết kế khuyến mãi phù hợp cho từng nhóm hạng.

Ví dụ:

* Platinum ít khách nhưng doanh thu cao;
* Member đông nhưng doanh thu trung bình thấp;
* Gold có tỷ lệ hoàn thành booking cao.

---

## 6. Luồng hoạt động chính

### Luồng xem báo cáo thành công

1. Admin đăng nhập vào hệ thống.
2. Admin mở trang báo cáo doanh thu và booking.
3. Hệ thống kiểm tra quyền truy cập của người dùng.
4. Nếu người dùng là Admin hoặc Manager, hệ thống cho phép truy cập báo cáo.
5. Admin chọn khoảng thời gian muốn xem báo cáo.
6. Hệ thống tổng hợp dữ liệu booking và doanh thu trong khoảng thời gian đó.
7. Hệ thống hiển thị các số liệu doanh thu tổng quan.
8. Hệ thống hiển thị thống kê booking theo trạng thái.
9. Hệ thống hiển thị tỷ lệ hoàn thành và hủy booking.
10. Hệ thống hiển thị các dịch vụ được đặt nhiều.
11. Nếu có dữ liệu phù hợp, hệ thống hiển thị doanh thu theo hạng thành viên.
12. Admin xem được tình hình kinh doanh và vận hành ở mức tổng quan.

---

## 7. Luồng lỗi và trường hợp không hợp lệ

### Trường hợp 1: Người dùng không phải Admin hoặc Manager

Nếu người dùng không có quyền quản trị, hệ thống không cho xem báo cáo doanh thu và booking.

Lý do: đây là dữ liệu quản trị, không dành cho khách hàng thông thường.

Kết quả mong đợi:

* hệ thống từ chối truy cập;
* người dùng không xem được dữ liệu doanh thu toàn hệ thống;
* người dùng không xem được thống kê booking toàn hệ thống.

---

### Trường hợp 2: Chưa có booking trong hệ thống

Nếu hệ thống chưa có booking nào, báo cáo vẫn phải hiển thị được.

Thay vì báo lỗi, hệ thống nên hiển thị số liệu bằng 0.

Ví dụ:

* tổng doanh thu: 0 VND;
* tổng booking: 0;
* booking hoàn thành: 0;
* booking bị hủy: 0;
* tỷ lệ hoàn thành: 0%;
* tỷ lệ hủy: 0%.

---

### Trường hợp 3: Có booking nhưng chưa có booking hoàn thành

Nếu đã có booking nhưng chưa có booking nào hoàn thành, hệ thống không được tính doanh thu từ các booking đó.

Ví dụ:

* có 10 booking đang chờ hoặc đã xác nhận;
* chưa có booking nào hoàn thành;
* doanh thu hiển thị là 0 VND;
* tổng booking vẫn hiển thị là 10.

Lý do: chỉ booking hoàn thành mới phản ánh doanh thu thực tế.

---

### Trường hợp 4: Booking bị hủy

Booking bị hủy không được tính vào doanh thu.

Tuy nhiên, booking bị hủy vẫn được tính vào thống kê vận hành để Admin biết tỷ lệ hủy.

Ví dụ:

* có 20 booking;
* 15 booking hoàn thành;
* 5 booking bị hủy;
* doanh thu chỉ tính từ 15 booking hoàn thành;
* tỷ lệ hủy được tính từ 5 booking bị hủy.

---

### Trường hợp 5: Khoảng thời gian lọc không hợp lệ

Nếu Admin chọn khoảng thời gian không hợp lệ, hệ thống không hiển thị báo cáo sai.

Ví dụ không hợp lệ:

* ngày bắt đầu sau ngày kết thúc;
* khoảng thời gian bị bỏ trống nếu hệ thống bắt buộc nhập;
* khoảng thời gian không có ý nghĩa nghiệp vụ.

Kết quả mong đợi:

* hệ thống thông báo lỗi rõ ràng;
* Admin cần chọn lại khoảng thời gian hợp lệ.

---

## 8. Quy tắc nghiệp vụ

### Quy tắc 1: Chỉ Admin hoặc Manager được xem báo cáo

Báo cáo doanh thu và booking là dữ liệu quản trị.

Khách hàng thông thường không được xem:

* tổng doanh thu;
* doanh thu theo ngày/tháng/năm;
* thống kê booking toàn hệ thống;
* tỷ lệ hủy booking toàn hệ thống;
* dịch vụ bán chạy toàn hệ thống.

---

### Quy tắc 2: Doanh thu chỉ tính từ booking đã hoàn thành

Doanh thu chỉ được tính từ các booking đã hoàn thành và có thanh toán hợp lệ.

Booking đang chờ, đã xác nhận nhưng chưa hoàn thành, hoặc bị hủy không được tính vào doanh thu.

Ví dụ:

* booking đang chờ: không tính doanh thu;
* booking đã xác nhận nhưng chưa rửa xong: không tính doanh thu;
* booking bị hủy: không tính doanh thu;
* booking đã hoàn thành: được tính doanh thu.

---

### Quy tắc 3: Booking bị hủy vẫn được tính vào thống kê vận hành

Booking bị hủy không tạo doanh thu nhưng vẫn có ý nghĩa trong báo cáo vận hành.

Lý do:

* giúp Admin biết tỷ lệ hủy;
* giúp đánh giá chất lượng quy trình booking;
* giúp phát hiện vấn đề nếu khách đặt nhưng hủy nhiều.

---

### Quy tắc 4: Báo cáo phải theo khoảng thời gian

Admin cần xem báo cáo theo khoảng thời gian cụ thể.

Ví dụ:

* hôm nay;
* tháng này;
* năm nay;
* từ ngày A đến ngày B.

Dữ liệu hiển thị phải tương ứng với khoảng thời gian Admin đang xem.

---

### Quy tắc 5: Báo cáo doanh thu không thay thế báo cáo khách hàng

FR-16 chỉ tập trung vào doanh thu và booking.

Các thống kê như tổng số khách hàng, phân bổ khách hàng theo hạng, số khách đổi ưu đãi thuộc về FR-15.

FR-16 có thể hiển thị doanh thu theo hạng thành viên nếu dữ liệu có sẵn, nhưng không biến thành báo cáo khách hàng chi tiết.

---

### Quy tắc 6: Báo cáo phải dễ hiểu cho Admin

Báo cáo cần trình bày rõ ràng để Admin hiểu nhanh tình hình kinh doanh.

Admin không nên phải tự cộng tay từ danh sách booking.

Báo cáo nên trả lời được các câu hỏi:

* cửa hàng thu được bao nhiêu tiền?
* có bao nhiêu booking đã hoàn thành?
* có bao nhiêu booking bị hủy?
* tỷ lệ hoàn thành booking là bao nhiêu?
* dịch vụ nào được đặt nhiều?
* doanh thu đến từ nhóm hạng nào nhiều nhất?

---

## 9. Kết quả mong đợi

Sau khi chức năng hoàn thành, hệ thống phải đảm bảo:

* Admin xem được báo cáo doanh thu tổng quan;
* Admin xem được doanh thu theo ngày, tháng, năm hoặc khoảng thời gian được chọn;
* Admin xem được tổng số booking trong khoảng thời gian;
* Admin xem được số booking hoàn thành;
* Admin xem được số booking bị hủy;
* Admin xem được tỷ lệ hoàn thành booking;
* Admin xem được tỷ lệ hủy booking;
* Admin xem được các dịch vụ được đặt nhiều;
* nếu có dữ liệu phù hợp, Admin xem được doanh thu theo hạng thành viên;
* booking chưa hoàn thành không bị tính vào doanh thu;
* booking bị hủy không bị tính vào doanh thu nhưng vẫn được tính trong thống kê vận hành;
* khi chưa có dữ liệu, báo cáo vẫn hiển thị ổn định với số liệu bằng 0;
* khách hàng thông thường không truy cập được báo cáo doanh thu và booking toàn hệ thống.

---

## 10. Phạm vi không xử lý trong issue này

Issue này không trực tiếp xử lý:

* báo cáo khách hàng chi tiết;
* phân bổ khách hàng theo hạng;
* số khách đổi ưu đãi;
* dự đoán doanh thu bằng AI;
* báo cáo hiệu quả từng chiến dịch khuyến mãi;
* xuất file báo cáo nâng cao;
* kế toán chi tiết;
* hoàn tiền;
* xử lý thanh toán phức tạp;
* cấu hình giá dịch vụ;
* tạo booking;
* hủy booking;
* cộng điểm loyalty;
* đổi điểm lấy ưu đãi;
* xét hạng thành viên.

Các phần trên nếu cần sẽ được tách thành issue riêng.

---

## 11. Ghi chú cho nhóm phát triển

FR-16 nên được hiểu là chức năng báo cáo kinh doanh và vận hành ở mức tổng quan.

Chức năng này không tạo booking, không hủy booking, không xử lý thanh toán và không tính loyalty.

Nó chỉ tổng hợp dữ liệu đã có để Admin xem được tình hình doanh thu và lịch đặt.

Các FR liên quan gồm:

* FR-06: tạo booking;
* FR-07: lịch sử booking;
* FR-08: ưu tiên booking theo hạng;
* FR-09: cộng điểm sau booking hoàn thành;
* FR-15: báo cáo khách hàng.

Mục tiêu cuối cùng là giúp Admin hiểu cửa hàng đang vận hành ra sao và doanh thu đến từ đâu.