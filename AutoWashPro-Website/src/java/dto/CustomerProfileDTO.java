package dto;

public class CustomerProfileDTO {
    // 5 thông tin chúng ta cần lấy từ Database để hiện lên HTML
    private String fullName;
    private String phone;
    private String licensePlate;
    private String tierName;
    private int totalPoints;

    // Hàm khởi tạo (Constructor) rỗng
    public CustomerProfileDTO() {
    }

    // Hàm khởi tạo có đầy đủ thông tin
    public CustomerProfileDTO(String fullName, String phone, String licensePlate, String tierName, int totalPoints) {
        this.fullName = fullName;
        this.phone = phone;
        this.licensePlate = licensePlate;
        this.tierName = tierName;
        this.totalPoints = totalPoints;
    }

    // Các hàm Getter để lấy dữ liệu ra
    public String getFullName() { return fullName; }
    public String getPhone() { return phone; }
    public String getLicensePlate() { return licensePlate; }
    public String getTierName() { return tierName; }
    public int getTotalPoints() { return totalPoints; }
}