package dto;

import java.math.BigDecimal;

public class CustomerRewardSummary {

    private final int customerId;
    private final String fullName;
    private final String email;
    private final BigDecimal totalSpentMoney;
    private final int totalPoints;

    public CustomerRewardSummary(int customerId, String fullName, String email, BigDecimal totalSpentMoney, int totalPoints) {
        this.customerId = customerId;
        this.fullName = fullName;
        this.email = email;
        this.totalSpentMoney = totalSpentMoney;
        this.totalPoints = totalPoints;
    }

    public int getCustomerId() {
        return customerId;
    }

    public String getFullName() {
        return fullName;
    }

    public String getEmail() {
        return email;
    }

    public BigDecimal getTotalSpentMoney() {
        return totalSpentMoney;
    }

    public int getTotalPoints() {
        return totalPoints;
    }
}