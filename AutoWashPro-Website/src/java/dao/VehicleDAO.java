package dao;

import dto.Vehicle;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import mylib.DBUtils;

public class VehicleDAO {

    private static final Logger LOGGER = Logger.getLogger(VehicleDAO.class.getName());
    
    public ArrayList<Vehicle> getCars(int customerId) {
        ArrayList<Vehicle> list = new ArrayList<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;
        
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT vehicle_id, customer_id, license_plate, brand, model, color FROM Vehicle WHERE customer_id = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, customerId);
                table = st.executeQuery();
                
                while (table.next()) {
                    int vId = table.getInt("vehicle_id");
                    String licensePlate = table.getString("license_plate");
                    String brand = table.getNString("brand");
                    String model = table.getNString("model");
                    String color = table.getNString("color");
                    
                    // Khởi tạo xe không có ngày tháng (vì Leader không thiết kế cột đó)
                    Vehicle v = new Vehicle(vId, customerId, licensePlate, brand, model, color);
                    list.add(v);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load vehicles for customerId=" + customerId, e);
        } finally {
            try {
                if (table != null) table.close();
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to close resources when loading vehicles for customerId=" + customerId, e);
            }
        }
        return list;
    }

    public boolean insertVehicle(Vehicle v) {
        Connection cn = null;
        PreparedStatement st = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "INSERT INTO Vehicle(customer_id, license_plate, brand, model, color) VALUES(?,?,?,?,?)";
                st = cn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
                st.setInt(1, v.getCustomerId());
                st.setString(2, v.getLicensePlate());
                st.setNString(3, v.getBrand());
                st.setNString(4, v.getModel());
                st.setNString(5, v.getColor());
                int affected = st.executeUpdate();
                if (affected > 0) {
                    try (ResultSet keys = st.getGeneratedKeys()) {
                        if (keys != null && keys.next()) {
                            v.setVehicleId(keys.getInt(1));
                        }
                    }
                    return true;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to insert vehicle for customerId=" + v.getCustomerId(), e);
        } finally {
            try {
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to close resources when inserting vehicle", e);
            }
        }
        return false;
    }

    public Vehicle getVehicleById(int vehicleId) {
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT vehicle_id, customer_id, license_plate, brand, model, color FROM Vehicle WHERE vehicle_id = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, vehicleId);
                rs = st.executeQuery();
                if (rs.next()) {
                    int customerId = rs.getInt("customer_id");
                    String licensePlate = rs.getString("license_plate");
                    String brand = rs.getNString("brand");
                    String model = rs.getNString("model");
                    String color = rs.getNString("color");
                    return new Vehicle(vehicleId, customerId, licensePlate, brand, model, color);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load vehicle id=" + vehicleId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to close resources when loading vehicle id=" + vehicleId, e);
            }
        }
        return null;
    }

    public boolean updateVehicle(Vehicle v) {
        Connection cn = null;
        PreparedStatement st = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE Vehicle SET license_plate = ?, brand = ?, model = ?, color = ? WHERE vehicle_id = ? AND customer_id = ?";
                st = cn.prepareStatement(sql);
                st.setString(1, v.getLicensePlate());
                st.setNString(2, v.getBrand());
                st.setNString(3, v.getModel());
                st.setNString(4, v.getColor());
                st.setInt(5, v.getVehicleId());
                st.setInt(6, v.getCustomerId());
                int affected = st.executeUpdate();
                return affected > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to update vehicle id=" + v.getVehicleId(), e);
        } finally {
            try {
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to close resources when updating vehicle id=" + v.getVehicleId(), e);
            }
        }
        return false;
    }

    public boolean isLicenseTaken(String licensePlate, int excludeVehicleId) {
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT vehicle_id FROM Vehicle WHERE license_plate = ? AND vehicle_id <> ?";
                st = cn.prepareStatement(sql);
                st.setString(1, licensePlate);
                st.setInt(2, excludeVehicleId);
                rs = st.executeQuery();
                if (rs.next()) return true;
                return false;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to check duplicate license plate: " + licensePlate, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to close resources when checking license plate", e);
            }
        }
        return false;
    }
}