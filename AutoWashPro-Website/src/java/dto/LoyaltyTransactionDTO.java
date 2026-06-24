package dto;

import java.sql.Timestamp;

public class LoyaltyTransactionDTO {
    private int transactionId;
    private int customerId;
    private Integer bookingId; // Có thể NULL vì định nghĩa là khách hàng đã dùng điểm để đổi một món quà nên điểm biến đồng
                               // nếu có số thì đó là một book mà khách hàng đặt để sử dụng dịch vụ điểm thay đổi
    private int points;
    private String transactionType;
    private Timestamp createdAt;

     // 1. Hàm khởi tạo rỗng
    public LoyaltyTransactionDTO() {
    }
    // 2. Hàm khởi tạo đầy đủ tham số
    public LoyaltyTransactionDTO(int transactionId, int customerId, Integer bookingId, int points, String transactionType, Timestamp createdAt) {
        this.transactionId = transactionId;
        this.customerId = customerId;
        this.bookingId = bookingId;
        this.points = points;
        this.transactionType = transactionType;
        this.createdAt = createdAt;
    }

      // 3. Các hàm Getter và Setter
    public int getTransactionId() { return transactionId; }
    public void setTransactionId(int transactionId) { this.transactionId = transactionId; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public Integer getBookingId() { return bookingId; }
    public void setBookingId(Integer bookingId) { this.bookingId = bookingId; }
    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }
    public String getTransactionType() { return transactionType; }
    public void setTransactionType(String transactionType) { this.transactionType = transactionType; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
}
