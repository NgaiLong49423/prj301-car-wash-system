package service;

import dto.RedemptionDTO;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.util.*;
import mylib.DBUtils;

/** Transaction boundary for point expiry, redemption and voucher lifecycle. */
public class LoyaltyService {
    public static final String AVAILABLE="AVAILABLE", USED="USED", EXPIRED="EXPIRED", CANCELLED="CANCELLED";

    public int refreshActivePoints(int customerId) throws Exception {
        try(Connection c=DBUtils.getConnection()) { c.setAutoCommit(false); try {
            int result=refreshActivePoints(c,customerId); c.commit(); return result;
        } catch(Exception e){c.rollback();throw e;} }
    }

    private int refreshActivePoints(Connection c,int customerId)throws SQLException{
        int expired=0;
        String q="SELECT point_batch_id,remaining_points FROM LoyaltyPointBatch WITH (UPDLOCK,ROWLOCK) WHERE customer_id=? AND status='ACTIVE' AND remaining_points>0 AND expires_at<=GETDATE()";
        try(PreparedStatement p=c.prepareStatement(q)){p.setInt(1,customerId);try(ResultSet r=p.executeQuery()){
            while(r.next()){
                int id=r.getInt(1), points=r.getInt(2);
                try(PreparedStatement u=c.prepareStatement("UPDATE LoyaltyPointBatch SET status='EXPIRED' WHERE point_batch_id=? AND status='ACTIVE'")){u.setInt(1,id);if(u.executeUpdate()==1){
                    expired+=points;
                    try(PreparedStatement t=c.prepareStatement("INSERT INTO LoyaltyTransaction(customer_id,point_batch_id,points,transaction_type,description) VALUES(?,?,?,'EXPIRED',?)")){t.setInt(1,customerId);t.setInt(2,id);t.setInt(3,points);t.setString(4,"Point batch expired");t.executeUpdate();}
                }}
            }
        }}
        syncBalance(c,customerId); return expired;
    }

    private int syncBalance(Connection c,int customerId)throws SQLException{
        int balance;
        try(PreparedStatement p=c.prepareStatement("SELECT ISNULL(SUM(remaining_points),0) FROM LoyaltyPointBatch WHERE customer_id=? AND status='ACTIVE' AND expires_at>GETDATE()")){p.setInt(1,customerId);try(ResultSet r=p.executeQuery()){r.next();balance=r.getInt(1);}}
        try(PreparedStatement p=c.prepareStatement("UPDATE Customer SET active_points=?,total_points=? WHERE customer_id=?")){p.setInt(1,balance);p.setInt(2,balance);p.setInt(3,customerId);p.executeUpdate();}
        return balance;
    }

    public int getActivePoints(int customerId)throws Exception{refreshActivePoints(customerId);try(Connection c=DBUtils.getConnection();PreparedStatement p=c.prepareStatement("SELECT active_points FROM Customer WHERE customer_id=?")){p.setInt(1,customerId);try(ResultSet r=p.executeQuery()){return r.next()?r.getInt(1):0;}}}

    public String redeem(int customerId,int rewardId,String requestToken)throws Exception{
        try(Connection c=DBUtils.getConnection()){c.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);c.setAutoCommit(false);try{
            if(requestToken!=null&&!requestToken.isEmpty()){try(PreparedStatement p=c.prepareStatement("SELECT voucher_code FROM Redemption WHERE customer_id=? AND request_token=?")){p.setInt(1,customerId);p.setString(2,requestToken);try(ResultSet r=p.executeQuery()){if(r.next()){c.commit();return r.getString(1);}}}}
            refreshActivePoints(c,customerId);
            int cost,days; String name,type; BigDecimal value,max;
            try(PreparedStatement p=c.prepareStatement("SELECT reward_name,required_points,reward_type,reward_value,valid_days,maximum_discount FROM Reward WITH (UPDLOCK,ROWLOCK) WHERE reward_id=? AND is_active=1")){p.setInt(1,rewardId);try(ResultSet r=p.executeQuery()){if(!r.next())throw new IllegalArgumentException("Phần thưởng hiện không còn khả dụng.");name=r.getString(1);cost=r.getInt(2);type=r.getString(3);value=r.getBigDecimal(4);days=r.getInt(5);max=r.getBigDecimal(6);}}
            int balance=syncBalance(c,customerId);if(balance<cost)throw new IllegalArgumentException("Bạn không đủ điểm để đổi phần thưởng này.");
            int left=cost;
            try(PreparedStatement p=c.prepareStatement("SELECT point_batch_id,remaining_points FROM LoyaltyPointBatch WITH (UPDLOCK,ROWLOCK) WHERE customer_id=? AND status='ACTIVE' AND remaining_points>0 AND expires_at>GETDATE() ORDER BY expires_at,earned_at,point_batch_id")){p.setInt(1,customerId);try(ResultSet r=p.executeQuery()){while(r.next()&&left>0){int id=r.getInt(1),remain=r.getInt(2),take=Math.min(left,remain),after=remain-take;try(PreparedStatement u=c.prepareStatement("UPDATE LoyaltyPointBatch SET remaining_points=?,status=? WHERE point_batch_id=?")){u.setInt(1,after);u.setString(2,after==0?"USED_UP":"ACTIVE");u.setInt(3,id);u.executeUpdate();}left-=take;}}}
            if(left!=0)throw new SQLException("Point balance changed during redemption");
            String code="LW-"+UUID.randomUUID().toString().replace("-","").substring(0,12).toUpperCase(Locale.ENGLISH);int redemptionId;
            String ins="INSERT INTO Redemption(customer_id,reward_id,points_used,valid_until,status,voucher_code,reward_name_snapshot,reward_type_snapshot,reward_value_snapshot,maximum_discount_snapshot,request_token) VALUES(?,?,?,DATEADD(day,?,GETDATE()),'AVAILABLE',?,?,?,?,?,?)";
            try(PreparedStatement p=c.prepareStatement(ins,Statement.RETURN_GENERATED_KEYS)){p.setInt(1,customerId);p.setInt(2,rewardId);p.setInt(3,cost);p.setInt(4,days);p.setString(5,code);p.setString(6,name);p.setString(7,type);p.setBigDecimal(8,value);p.setBigDecimal(9,max);p.setString(10,requestToken);p.executeUpdate();try(ResultSet r=p.getGeneratedKeys()){if(!r.next())throw new SQLException("No redemption id");redemptionId=r.getInt(1);}}
            try(PreparedStatement p=c.prepareStatement("INSERT INTO LoyaltyTransaction(customer_id,redemption_id,points,transaction_type,description) VALUES(?,?,?,'REDEEMED',?)")){p.setInt(1,customerId);p.setInt(2,redemptionId);p.setInt(3,cost);p.setString(4,"Redeemed "+name);p.executeUpdate();}
            syncBalance(c,customerId);c.commit();return code;
        }catch(Exception e){c.rollback();throw e;}}
    }

    public List<RedemptionDTO> listVouchers(int customerId)throws Exception{refreshVoucherExpiry(customerId);List<RedemptionDTO> out=new ArrayList<>();String q="SELECT redemption_id,voucher_code,reward_name_snapshot,reward_type_snapshot,reward_value_snapshot,maximum_discount_snapshot,status,valid_until FROM Redemption WHERE customer_id=? ORDER BY redeem_date DESC";try(Connection c=DBUtils.getConnection();PreparedStatement p=c.prepareStatement(q)){p.setInt(1,customerId);try(ResultSet r=p.executeQuery()){while(r.next()){RedemptionDTO d=new RedemptionDTO();d.setRedemptionId(r.getInt(1));d.setVoucherCode(r.getString(2));d.setRewardName(r.getString(3));d.setRewardType(r.getString(4));d.setRewardValue(r.getBigDecimal(5));d.setMaximumDiscount(r.getBigDecimal(6));d.setStatus(r.getString(7));d.setValidUntil(r.getTimestamp(8));out.add(d);}}}return out;}

    public void refreshVoucherExpiry(int customerId)throws Exception{try(Connection c=DBUtils.getConnection();PreparedStatement p=c.prepareStatement("UPDATE Redemption SET status='EXPIRED' WHERE customer_id=? AND status='AVAILABLE' AND applied_booking_id IS NULL AND valid_until<=GETDATE()")){p.setInt(1,customerId);p.executeUpdate();}}

    public BigDecimal applyVoucher(int customerId,int bookingId,String voucherCode)throws Exception{
        try(Connection c=DBUtils.getConnection()){c.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);c.setAutoCommit(false);try{
            int redemptionId;String type;BigDecimal value,max;
            String vq="SELECT redemption_id,reward_type_snapshot,reward_value_snapshot,maximum_discount_snapshot FROM Redemption WITH (UPDLOCK,ROWLOCK) WHERE voucher_code=? AND customer_id=? AND status='AVAILABLE' AND valid_from<=GETDATE() AND valid_until>GETDATE() AND applied_booking_id IS NULL";
            try(PreparedStatement p=c.prepareStatement(vq)){p.setString(1,voucherCode);p.setInt(2,customerId);try(ResultSet r=p.executeQuery()){if(!r.next())throw new IllegalArgumentException("Voucher không hợp lệ hoặc không còn khả dụng.");redemptionId=r.getInt(1);type=r.getString(2);value=r.getBigDecimal(3);max=r.getBigDecimal(4);}}
            BigDecimal subtotal;try(PreparedStatement p=c.prepareStatement("SELECT ISNULL(SUM(bs.price*bs.quantity),0) FROM Booking b WITH (UPDLOCK,ROWLOCK) JOIN BookingService bs ON b.booking_id=bs.booking_id WHERE b.booking_id=? AND b.customer_id=? AND b.status IN ('PENDING','CONFIRMED') AND b.applied_redemption_id IS NULL")){p.setInt(1,bookingId);p.setInt(2,customerId);try(ResultSet r=p.executeQuery()){if(!r.next())throw new IllegalArgumentException("Booking không hợp lệ.");subtotal=r.getBigDecimal(1);}}
            if(subtotal==null||subtotal.signum()<=0)throw new IllegalArgumentException("Booking không có dịch vụ hợp lệ.");BigDecimal discount;
            if("PERCENT_DISCOUNT".equals(type))discount=subtotal.multiply(value).divide(new BigDecimal("100"),2,RoundingMode.HALF_UP);else if("FIXED_DISCOUNT".equals(type))discount=value;else discount=subtotal;
            if(max!=null&&max.signum()>0)discount=discount.min(max);discount=discount.max(BigDecimal.ZERO).min(subtotal);BigDecimal total=subtotal.subtract(discount);
            try(PreparedStatement p=c.prepareStatement("UPDATE Booking SET applied_redemption_id=?,original_amount=?,discount_amount=?,final_amount=?,total_price=? WHERE booking_id=? AND customer_id=? AND applied_redemption_id IS NULL")){p.setInt(1,redemptionId);p.setBigDecimal(2,subtotal);p.setBigDecimal(3,discount);p.setBigDecimal(4,total);p.setBigDecimal(5,total);p.setInt(6,bookingId);p.setInt(7,customerId);if(p.executeUpdate()!=1)throw new SQLException("Booking voucher conflict");}
            try(PreparedStatement p=c.prepareStatement("UPDATE Redemption SET applied_booking_id=? WHERE redemption_id=? AND applied_booking_id IS NULL")){p.setInt(1,bookingId);p.setInt(2,redemptionId);if(p.executeUpdate()!=1)throw new SQLException("Voucher conflict");}c.commit();return total;
        }catch(Exception e){c.rollback();throw e;}}
    }

    public void transitionBooking(int bookingId,String newStatus)throws Exception{if(!"COMPLETED".equals(newStatus)&&!"CANCELLED".equals(newStatus))throw new IllegalArgumentException("Unsupported transition");try(Connection c=DBUtils.getConnection()){c.setAutoCommit(false);try{Integer rid=null;try(PreparedStatement p=c.prepareStatement("SELECT applied_redemption_id FROM Booking WITH (UPDLOCK,ROWLOCK) WHERE booking_id=?")){p.setInt(1,bookingId);try(ResultSet r=p.executeQuery()){if(!r.next())throw new IllegalArgumentException("Booking not found");rid=(Integer)r.getObject(1);}}try(PreparedStatement p=c.prepareStatement("UPDATE Booking SET status=? WHERE booking_id=? AND status IN ('PENDING','CONFIRMED')")){p.setString(1,newStatus);p.setInt(2,bookingId);if(p.executeUpdate()!=1)throw new IllegalArgumentException("Invalid booking transition");}if(rid!=null){if("COMPLETED".equals(newStatus)){try(PreparedStatement p=c.prepareStatement("UPDATE Redemption SET status='USED',used_at=GETDATE() WHERE redemption_id=? AND status='AVAILABLE'")){p.setInt(1,rid);p.executeUpdate();}}else{try(PreparedStatement p=c.prepareStatement("UPDATE Redemption SET status=CASE WHEN valid_until<=GETDATE() THEN 'EXPIRED' ELSE 'AVAILABLE' END,applied_booking_id=NULL WHERE redemption_id=? AND status='AVAILABLE'")){p.setInt(1,rid);p.executeUpdate();}try(PreparedStatement p=c.prepareStatement("UPDATE Booking SET applied_redemption_id=NULL,discount_amount=0,final_amount=original_amount,total_price=original_amount WHERE booking_id=?")){p.setInt(1,bookingId);p.executeUpdate();}}}if("COMPLETED".equals(newStatus))awardPoints(c,bookingId);c.commit();}catch(Exception e){c.rollback();throw e;}}}

    private void awardPoints(Connection c,int bookingId)throws SQLException{
        int customer,rate,months;BigDecimal amount,multiplier;
        String q="SELECT b.customer_id,b.final_amount,mt.point_multiplier FROM Booking b JOIN Customer cu ON b.customer_id=cu.customer_id JOIN MembershipTier mt ON cu.tier_id=mt.tier_id WHERE b.booking_id=? AND b.loyalty_points_awarded=0";
        try(PreparedStatement p=c.prepareStatement(q)){p.setInt(1,bookingId);try(ResultSet r=p.executeQuery()){if(!r.next())return;customer=r.getInt(1);amount=r.getBigDecimal(2);multiplier=r.getBigDecimal(3);}}
        try(PreparedStatement p=c.prepareStatement("SELECT CAST(config_value AS INT) FROM LoyaltyConfig WHERE config_key='POINT_CONVERSION_RATE'");ResultSet r=p.executeQuery()){if(!r.next())throw new SQLException("Missing POINT_CONVERSION_RATE");rate=r.getInt(1);if(rate<=0)throw new SQLException("Invalid POINT_CONVERSION_RATE");}
        try(PreparedStatement p=c.prepareStatement("SELECT CAST(config_value AS INT) FROM LoyaltyConfig WHERE config_key='POINT_EXPIRY_MONTHS'" );ResultSet r=p.executeQuery()){if(!r.next())throw new SQLException("Missing POINT_EXPIRY_MONTHS");months=r.getInt(1);if(months<=0)throw new SQLException("Invalid POINT_EXPIRY_MONTHS");}
        int points=amount.divide(new BigDecimal(rate),0,RoundingMode.DOWN).multiply(multiplier).setScale(0,RoundingMode.DOWN).intValue();
        if(points>0){int batch;try(PreparedStatement p=c.prepareStatement("INSERT LoyaltyPointBatch(customer_id,source_booking_id,earned_points,remaining_points,expires_at) VALUES(?,?,?,?,DATEADD(month,?,GETDATE()))",Statement.RETURN_GENERATED_KEYS)){p.setInt(1,customer);p.setInt(2,bookingId);p.setInt(3,points);p.setInt(4,points);p.setInt(5,months);p.executeUpdate();try(ResultSet r=p.getGeneratedKeys()){r.next();batch=r.getInt(1);}}try(PreparedStatement p=c.prepareStatement("INSERT LoyaltyTransaction(customer_id,booking_id,point_batch_id,points,transaction_type,description) VALUES(?,?,?,?, 'EARNED','Completed booking')")){p.setInt(1,customer);p.setInt(2,bookingId);p.setInt(3,batch);p.setInt(4,points);p.executeUpdate();}}
        try(PreparedStatement p=c.prepareStatement("UPDATE Booking SET loyalty_points_awarded=1,loyalty_awarded_at=GETDATE() WHERE booking_id=? AND loyalty_points_awarded=0")){p.setInt(1,bookingId);p.executeUpdate();}syncBalance(c,customer);
        try(PreparedStatement p=c.prepareStatement("UPDATE Customer SET tier_id=(SELECT TOP 1 tier_id FROM MembershipTier WHERE is_active=1 AND min_points<=Customer.total_points ORDER BY min_points DESC,tier_order DESC) WHERE customer_id=?")){p.setInt(1,customer);p.executeUpdate();}
    }
}
