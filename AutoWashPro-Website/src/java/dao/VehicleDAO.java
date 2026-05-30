package dao;

import dto.Vehicle;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import mylib.DBUtils;

public class VehicleDAO {
    
    public ArrayList<Vehicle> getCars(int customerId) {
        ArrayList<Vehicle> list = new ArrayList<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;
        
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT * FROM Vehicle WHERE customer_id = ?";
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
        return list;
    }
}