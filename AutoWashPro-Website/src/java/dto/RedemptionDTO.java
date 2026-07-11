package dto;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class RedemptionDTO {
    private int redemptionId;
    private String voucherCode;
    private String rewardName;
    private String rewardType;
    private BigDecimal rewardValue;
    private BigDecimal maximumDiscount;
    private String status;
    private Timestamp validUntil;
    public int getRedemptionId(){return redemptionId;} public void setRedemptionId(int v){redemptionId=v;}
    public String getVoucherCode(){return voucherCode;} public void setVoucherCode(String v){voucherCode=v;}
    public String getRewardName(){return rewardName;} public void setRewardName(String v){rewardName=v;}
    public String getRewardType(){return rewardType;} public void setRewardType(String v){rewardType=v;}
    public BigDecimal getRewardValue(){return rewardValue;} public void setRewardValue(BigDecimal v){rewardValue=v;}
    public BigDecimal getMaximumDiscount(){return maximumDiscount;} public void setMaximumDiscount(BigDecimal v){maximumDiscount=v;}
    public String getStatus(){return status;} public void setStatus(String v){status=v;}
    public Timestamp getValidUntil(){return validUntil;} public void setValidUntil(Timestamp v){validUntil=v;}
}
