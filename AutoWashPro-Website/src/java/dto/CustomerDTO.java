package dto;

import java.io.Serializable;
import java.util.Date;

// Lớp này tạo ra để gom các trường dữ liệu của Khách hàng thành một đối tượng
// Có implement Serializable để hệ thống truyền nhận dữ liệu qua mạng không bị lỗi
public class CustomerDTO implements Serializable {
    private int customerId;
    private String fullName;
    private String phone;
    private String email;
    private String password;
    private Date joinDate;
    private double totalSpentMoney;
    private int totalPoints;
    private int tierId;

    // Phải để một constructor trống không tham số theo đúng luật cấu trúc JavaBean
    public CustomerDTO() {
    }

    // Constructor này mình viết để tiện gọi bên Servlet khi lấy được data từ form về
    // Lúc tạo mới chỉ cần truyền mấy thông tin cơ bản này, mấy cái ngày tham gia hay điểm số thì DB tự lo
    public CustomerDTO(String fullName, String phone, String email, String password, int tierId) {
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.password = password;
        this.tierId = tierId;
    }

    // Mấy hàm getter setter phía dưới dùng để lấy dữ liệu ra hoặc gán dữ liệu vào cho các thuộc tính
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public Date getJoinDate() { return joinDate; }
    public void setJoinDate(Date joinDate) { this.joinDate = joinDate; }

    public double getTotalSpentMoney() { return totalSpentMoney; }
    public void setTotalSpentMoney(double totalSpentMoney) { this.totalSpentMoney = totalSpentMoney; }

    public int getTotalPoints() { return totalPoints; }
    public void setTotalPoints(int totalPoints) { this.totalPoints = totalPoints; }

    public int getTierId() { return tierId; }
    public void setTierId(int tierId) { this.tierId = tierId; }
}