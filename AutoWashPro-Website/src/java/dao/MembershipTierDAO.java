package dao;

import dto.MembershipTierDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import mylib.DBUtils;

public class MembershipTierDAO {

    private static final Logger LOGGER = Logger.getLogger(MembershipTierDAO.class.getName());

    public MembershipTierDTO getTierByCustomerId(int customerId) {
        String sql = "SELECT mt.tier_id, mt.tier_name, mt.min_points, mt.discount_percent, mt.benefits, "
                + "ISNULL(mt.priority_score, 10) AS priority_score, "
                + "ISNULL(mt.advance_booking_days, 3) AS advance_booking_days, "
                + "ISNULL(mt.reserved_slot_eligible, 0) AS reserved_slot_eligible "
                + "FROM Customer c "
                + "JOIN MembershipTier mt ON c.tier_id = mt.tier_id "
                + "WHERE c.customer_id = ?";

        try (Connection cn = DBUtils.getConnection();
                PreparedStatement st = cn.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapTier(rs);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load tier for customerId=" + customerId, e);
        }

        MembershipTierDTO fallback = new MembershipTierDTO();
        fallback.setTierName("Member");
        fallback.setPriorityScore(10);
        fallback.setAdvanceBookingDays(3);
        fallback.setReservedSlotEligible(false);
        return fallback;
    }

    public int getDefaultTierId() {
        String sql = "SELECT tier_id FROM MembershipTier WHERE tier_order = 0";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement st = cn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("tier_id");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to get default tier ID", e);
        }
        return 1; // Fallback to 1 if not found
    }

    private MembershipTierDTO mapTier(ResultSet rs) throws Exception {
        return new MembershipTierDTO(
                rs.getInt("tier_id"),
                rs.getString("tier_name"),
                rs.getInt("min_points"),
                rs.getBigDecimal("discount_percent"),
                rs.getString("benefits"),
                rs.getInt("priority_score"),
                rs.getInt("advance_booking_days"),
                rs.getBoolean("reserved_slot_eligible"));
    }
}
