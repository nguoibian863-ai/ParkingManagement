package dal;

import model.ParkingSlot;
import java.util.*;
import java.sql.*;

public class ParkingSlotDao extends DBContext {

    public List<ParkingSlot> getAll() {
        List<ParkingSlot> list = new ArrayList<>();
        String sql = "SELECT * FROM ParkingSlot ORDER BY lotId, slotCode";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<ParkingSlot> getByLotId(String lotId) {
        List<ParkingSlot> list = new ArrayList<>();
        String sql = "SELECT * FROM ParkingSlot WHERE lotId = ? ORDER BY slotCode";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, lotId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public ParkingSlot getById(String slotId) {
        String sql = "SELECT * FROM ParkingSlot WHERE slotId = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, slotId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(ParkingSlot p) {
        String sql = "INSERT INTO ParkingSlot (slotId, lotId, slotCode, status, note) VALUES (?,?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, p.getSlotId());
            st.setString(2, p.getLotId());
            st.setString(3, p.getSlotCode());
            st.setString(4, p.getStatus() != null ? p.getStatus() : "EMPTY");
            st.setString(5, p.getNote());
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(ParkingSlot p) {
        String sql = "UPDATE ParkingSlot SET lotId=?, slotCode=?, status=?, note=? WHERE slotId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, p.getLotId());
            st.setString(2, p.getSlotCode());
            st.setString(3, p.getStatus());
            st.setString(4, p.getNote());
            st.setString(5, p.getSlotId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(String slotId, String status) {
        String sql = "UPDATE ParkingSlot SET status=? WHERE slotId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            st.setString(2, slotId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(String slotId) {
        String sql = "DELETE FROM ParkingSlot WHERE slotId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, slotId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public String nextSlotId() {
        String sql = "SELECT TOP 1 slotId FROM ParkingSlot ORDER BY slotId DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                String last = rs.getString("slotId");
                if (last != null && last.matches("S\\d+")) {
                    int n = Integer.parseInt(last.substring(1)) + 1;
                    return "S" + String.format("%03d", n);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return "S001";
    }

    private ParkingSlot mapRow(ResultSet rs) throws SQLException {
        return new ParkingSlot(
            rs.getString("slotId"),
            rs.getString("lotId"),
            rs.getString("slotCode"),
            rs.getString("status"),
            rs.getString("note"),
            rs.getTimestamp("createdAt") != null ? new java.util.Date(rs.getTimestamp("createdAt").getTime()) : null
        );
    }
}
