package dal;

import model.Pricing;
import java.util.*;
import java.sql.*;

public class PricingDao extends DBContext {

    public List<Pricing> getAll() {
        List<Pricing> list = new ArrayList<>();
        String sql = "SELECT * FROM Pricing ORDER BY vehicleType";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Pricing getById(String pricingId) {
        String sql = "SELECT * FROM Pricing WHERE pricingId = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, pricingId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Pricing getByVehicleType(String vehicleType) {
        if (vehicleType == null || vehicleType.trim().isEmpty()) return null;
        String sql = "SELECT * FROM Pricing WHERE vehicleType = ? AND active = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, vehicleType.trim());
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(Pricing p) {
        String sql = "INSERT INTO Pricing (pricingId, vehicleType, pricePerHour, overnightFee, active) VALUES (?,?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, p.getPricingId());
            st.setString(2, p.getVehicleType());
            st.setInt(3, p.getPricePerHour());
            st.setInt(4, p.getOvernightFee());
            st.setBoolean(5, p.isActive());
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Pricing p) {
        String sql = "UPDATE Pricing SET vehicleType=?, pricePerHour=?, overnightFee=?, active=? WHERE pricingId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, p.getVehicleType());
            st.setInt(2, p.getPricePerHour());
            st.setInt(3, p.getOvernightFee());
            st.setBoolean(4, p.isActive());
            st.setString(5, p.getPricingId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(String pricingId) {
        String sql = "DELETE FROM Pricing WHERE pricingId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, pricingId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public String nextPricingId() {
        String sql = "SELECT TOP 1 pricingId FROM Pricing ORDER BY pricingId DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                String last = rs.getString("pricingId");
                if (last != null && last.matches("P\\d+")) {
                    int n = Integer.parseInt(last.substring(1)) + 1;
                    return "P" + String.format("%03d", n);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return "P001";
    }

    private Pricing mapRow(ResultSet rs) throws SQLException {
        return new Pricing(
            rs.getString("pricingId"),
            rs.getString("vehicleType"),
            rs.getInt("pricePerHour"),
            rs.getInt("overnightFee"),
            rs.getBoolean("active"),
            rs.getTimestamp("createdAt") != null ? new java.util.Date(rs.getTimestamp("createdAt").getTime()) : null
        );
    }
}
