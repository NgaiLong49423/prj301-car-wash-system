package dto;

import java.math.BigDecimal;

public class RewardDTO {
    private int rewardId;
    private String rewardName;
    private int pointsRequired;
    private String description;
    private String rewardType;
    private BigDecimal rewardValue;
    private int validDays;

    // Constructor (Hàm khởi tạo) rỗng và đầy đủ
    public RewardDTO() {
    }

    public RewardDTO(int rewardId, String rewardName, int pointsRequired, String description) {
        this(rewardId, rewardName, pointsRequired, description, null, BigDecimal.ZERO, 0);
    }

    public RewardDTO(int rewardId, String rewardName, int pointsRequired, String description,
            String rewardType, BigDecimal rewardValue, int validDays) {
        this.rewardId = rewardId;
        this.rewardName = rewardName;
        this.pointsRequired = pointsRequired;
        this.description = description;
        this.rewardType = rewardType;
        this.rewardValue = rewardValue;
        this.validDays = validDays;
    }



    public int getRewardId() { return rewardId; }
    public void setRewardId(int rewardId) { this.rewardId = rewardId; }

    public String getRewardName() { return rewardName; }
    public void setRewardName(String rewardName) { this.rewardName = rewardName; }

    public int getPointsRequired() { return pointsRequired; }
    public void setPointsRequired(int pointsRequired) { this.pointsRequired = pointsRequired; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getRewardType() { return rewardType; }
    public void setRewardType(String rewardType) { this.rewardType = rewardType; }

    public BigDecimal getRewardValue() { return rewardValue; }
    public void setRewardValue(BigDecimal rewardValue) { this.rewardValue = rewardValue; }

    public int getValidDays() { return validDays; }
    public void setValidDays(int validDays) { this.validDays = validDays; }
}
