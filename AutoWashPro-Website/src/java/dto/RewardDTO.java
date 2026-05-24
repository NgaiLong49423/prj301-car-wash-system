package dto;

public class RewardDTO {
    private int rewardId;
    private String rewardName;
    private int pointsRequired;
    private String description;

    // Constructor (Hàm khởi tạo) rỗng và đầy đủ
    public RewardDTO() {
    }

    public RewardDTO(int rewardId, String rewardName, int pointsRequired, String description) {
        this.rewardId = rewardId;
        this.rewardName = rewardName;
        this.pointsRequired = pointsRequired;
        this.description = description;
    }



    public int getRewardId() { return rewardId; }
    public void setRewardId(int rewardId) { this.rewardId = rewardId; }

    public String getRewardName() { return rewardName; }
    public void setRewardName(String rewardName) { this.rewardName = rewardName; }

    public int getPointsRequired() { return pointsRequired; }
    public void setPointsRequired(int pointsRequired) { this.pointsRequired = pointsRequired; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}