package dao;

import dto.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import mylib.DBUtils;

public class CustomerDAO {
    
    // Hàm kéo thông tin cá nhân và hạng thành viên
    public Customer getCustomerProfile(int customerId) {
        Customer cus = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;
        
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Lệnh JOIN bảng Customer và Tier theo đúng thiết kế của Leader
                String sql = "SELECT c.customer_id, c.full_name, c.phone, c.email, c.join_date, c.total_points, t.tier_name "
                           + "FROM Customer c "
                           + "LEFT JOIN MembershipTier t ON c.tier_id = t.tier_id "
                           + "WHERE c.customer_id = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, customerId);
                table = st.executeQuery();
                
                if (table.next()) {
                    cus = new Customer();
                    cus.setCustomerId(table.getInt("customer_id"));
                    cus.setFullName(table.getNString("full_name"));
                    cus.setPhone(table.getString("phone"));
                    cus.setEmail(table.getString("email"));
                    cus.setJoinDate(table.getDate("join_date"));
                    cus.setTotalPoints(table.getInt("total_points"));
                    
                    String tier = table.getString("tier_name");
                    cus.setTierName(tier != null ? tier : "Thành viên mới");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (table != null) table.close();
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return cus;
    }
}