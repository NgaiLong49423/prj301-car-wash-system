package dao;

import dto.ServiceDTO;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import mylib.DBUtils;

public class ServiceDAO {

    private static final Logger LOGGER = Logger.getLogger(ServiceDAO.class.getName());

    public List<ServiceDTO> getAllServices() {
        List<ServiceDTO> list = new ArrayList<>();
        String sql = "SELECT service_id, service_name, price, duration FROM Service ORDER BY service_name";

        try (Connection cn = DBUtils.getConnection();
                PreparedStatement st = cn.prepareStatement(sql);
                ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapService(rs));
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load services", e);
        }
        return list;
    }

    public List<ServiceDTO> getServicesByIds(int[] serviceIds) {
        List<ServiceDTO> services = new ArrayList<>();
        if (serviceIds == null || serviceIds.length == 0) {
            return services;
        }

        StringBuilder sql = new StringBuilder("SELECT service_id, service_name, price, duration FROM Service WHERE service_id IN (");
        for (int i = 0; i < serviceIds.length; i++) {
            if (i > 0) {
                sql.append(",");
            }
            sql.append("?");
        }
        sql.append(")");

        try (Connection cn = DBUtils.getConnection();
                PreparedStatement st = cn.prepareStatement(sql.toString())) {
            for (int i = 0; i < serviceIds.length; i++) {
                st.setInt(i + 1, serviceIds[i]);
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    services.add(mapService(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load selected services", e);
        }
        return services;
    }

    public BigDecimal calculateTotalPrice(List<ServiceDTO> services) {
        BigDecimal total = BigDecimal.ZERO;
        if (services == null) {
            return total;
        }
        for (ServiceDTO service : services) {
            if (service.getPrice() != null) {
                total = total.add(service.getPrice());
            }
        }
        return total;
    }

    public int calculateTotalDuration(List<ServiceDTO> services) {
        int total = 0;
        if (services == null) {
            return total;
        }
        for (ServiceDTO service : services) {
            total += Math.max(service.getDuration(), 0);
        }
        return total;
    }

    private ServiceDTO mapService(ResultSet rs) throws Exception {
        return new ServiceDTO(
                rs.getInt("service_id"),
                rs.getNString("service_name"),
                rs.getBigDecimal("price"),
                rs.getInt("duration"));
    }
}
