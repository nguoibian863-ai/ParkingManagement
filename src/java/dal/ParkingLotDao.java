package dal;

import model.ParkingLot;
import java.util.*;
import java.sql.*;

public class ParkingLotDao extends DBContext {

    public List<ParkingLot> getAll() {
        List<ParkingLot> list = new ArrayList<>();
        String sql = "SELECT * FROM ParkingLot ORDER BY lotName";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public ParkingLot getById(String lotId) {
        String sql = "SELECT * FROM ParkingLot WHERE lotId = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, lotId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(ParkingLot p) {
        String sql = "INSERT INTO ParkingLot (lotId, lotName, address, note, status) VALUES (?,?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, p.getLotId());
            st.setString(2, p.getLotName());
            st.setString(3, p.getAddress());
            st.setString(4, p.getNote());
            st.setBoolean(5, p.isStatus());
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(ParkingLot p) {
        String sql = "UPDATE ParkingLot SET lotName=?, address=?, note=?, status=? WHERE lotId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, p.getLotName());
            st.setString(2, p.getAddress());
            st.setString(3, p.getNote());
            st.setBoolean(4, p.isStatus());
            st.setString(5, p.getLotId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(String lotId) {
        String sql = "DELETE FROM ParkingLot WHERE lotId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, lotId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int countSlotsByLotId(String lotId) {
        String sql = "SELECT COUNT(*) FROM ParkingSlot WHERE lotId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, lotId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public String nextLotId() {
        String sql = "SELECT TOP 1 lotId FROM ParkingLot ORDER BY lotId DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                String last = rs.getString("lotId");
                if (last != null && last.matches("LOT\\d+")) {
                    int n = Integer.parseInt(last.replace("LOT", "")) + 1;
                    return "LOT" + String.format("%02d", n);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return "LOT01";
    }

    private ParkingLot mapRow(ResultSet rs) throws SQLException {
        return new ParkingLot(
            rs.getString("lotId"),
            rs.getString("lotName"),
            rs.getString("address"),
            rs.getString("note"),
            rs.getBoolean("status"),
            rs.getTimestamp("createdAt") != null ? new java.util.Date(rs.getTimestamp("createdAt").getTime()) : null
        );
    }
}
