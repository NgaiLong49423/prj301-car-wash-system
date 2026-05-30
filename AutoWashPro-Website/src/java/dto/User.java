package dto;

import java.math.BigDecimal;

public class User {

    private int id;
    private String fullName;
    private String phone;
    private String email;
    private String password;
    private BigDecimal totalSpentMoney;
    private int totalPoints;

    public User() {
    }

    public User(int id, String fullName, String phone, String email, String password, BigDecimal totalSpentMoney, int totalPoints) {
        this.id = id;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.password = password;
        this.totalSpentMoney = totalSpentMoney;
        this.totalPoints = totalPoints;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public BigDecimal getTotalSpentMoney() {
        return totalSpentMoney;
    }

    public void setTotalSpentMoney(BigDecimal totalSpentMoney) {
        this.totalSpentMoney = totalSpentMoney;
    }

    public int getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(int totalPoints) {
        this.totalPoints = totalPoints;
    }

    public String getUsername() {
        return email;
    }

    public void setUsername(String username) {
        this.email = username;
    }
}