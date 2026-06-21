package dto;

import java.math.BigDecimal;

public class MembershipTierDTO {
    private int tierId;
    private String tierName;
    private int minPoints;
    private BigDecimal discountPercent;
    private String benefits;
    private int priorityScore;
    private int advanceBookingDays;
    private boolean reservedSlotEligible;

    public MembershipTierDTO() {
    }

    public MembershipTierDTO(int tierId, String tierName, int minPoints, BigDecimal discountPercent,
            String benefits, int priorityScore, int advanceBookingDays, boolean reservedSlotEligible) {
        this.tierId = tierId;
        this.tierName = tierName;
        this.minPoints = minPoints;
        this.discountPercent = discountPercent;
        this.benefits = benefits;
        this.priorityScore = priorityScore;
        this.advanceBookingDays = advanceBookingDays;
        this.reservedSlotEligible = reservedSlotEligible;
    }

    public int getTierId() {
        return tierId;
    }

    public void setTierId(int tierId) {
        this.tierId = tierId;
    }

    public String getTierName() {
        return tierName;
    }

    public void setTierName(String tierName) {
        this.tierName = tierName;
    }

    public int getMinPoints() {
        return minPoints;
    }

    public void setMinPoints(int minPoints) {
        this.minPoints = minPoints;
    }

    public BigDecimal getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(BigDecimal discountPercent) {
        this.discountPercent = discountPercent;
    }

    public String getBenefits() {
        return benefits;
    }

    public void setBenefits(String benefits) {
        this.benefits = benefits;
    }

    public int getPriorityScore() {
        return priorityScore;
    }

    public void setPriorityScore(int priorityScore) {
        this.priorityScore = priorityScore;
    }

    public int getAdvanceBookingDays() {
        return advanceBookingDays;
    }

    public void setAdvanceBookingDays(int advanceBookingDays) {
        this.advanceBookingDays = advanceBookingDays;
    }

    public boolean isReservedSlotEligible() {
        return reservedSlotEligible;
    }

    public void setReservedSlotEligible(boolean reservedSlotEligible) {
        this.reservedSlotEligible = reservedSlotEligible;
    }
}
