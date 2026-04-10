package dal;

import model.ParkingTicket;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.sql.*;

public class ParkingTicketDao extends DBContext {

    private static volatile String lastInsertError;

    public static String getLastInsertError() {
        String e = lastInsertError;
        lastInsertError = null;
        return e;
    }

    public List<ParkingTicket> getAll() {
        List<ParkingTicket> list = new ArrayList<>();
        String sql = "SELECT * FROM ParkingTicket ORDER BY checkInTime DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public ParkingTicket getById(String ticketId) {
        String sql = "SELECT * FROM ParkingTicket WHERE ticketId = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, ticketId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<ParkingTicket> search(String plate, String dateFrom, String dateTo, String staffId) {
        List<ParkingTicket> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM ParkingTicket WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (plate != null && !plate.trim().isEmpty()) {
            sql.append(" AND vehiclePlate LIKE ?");
            params.add("%" + plate.trim() + "%");
        }
        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND CAST(checkInTime AS DATE) >= ?");
            params.add(dateFrom);
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND CAST(checkInTime AS DATE) <= ?");
            params.add(dateTo);
        }
        if (staffId != null && !staffId.isEmpty()) {
            sql.append(" AND (staffCheckInId = ? OR staffCheckOutId = ?)");
            params.add(staffId);
            params.add(staffId);
        }
        sql.append(" ORDER BY checkInTime DESC");
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<ParkingTicket> getParking(String plate) {
        List<ParkingTicket> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM ParkingTicket WHERE status = 'PARKING'");
        List<Object> params = new ArrayList<>();
        if (plate != null && !plate.trim().isEmpty()) {
            sql.append(" AND vehiclePlate LIKE ?");
            params.add("%" + plate.trim() + "%");
        }
        sql.append(" ORDER BY checkInTime DESC");
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public ParkingTicket getByPlateParking(String vehiclePlate) {
        if (vehiclePlate == null || vehiclePlate.trim().isEmpty()) return null;
        String sql = "SELECT * FROM ParkingTicket WHERE status = 'PARKING' AND vehiclePlate = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, vehiclePlate.trim());
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /** Sinh mã vé tiếp theo. Sắp xếp theo số (T001=1, T0002=2) để tránh trùng khi có cả T001 và T0002. */
    public String nextTicketId() {
        String sql = "SELECT TOP 1 ticketId FROM ParkingTicket WHERE ticketId LIKE 'T[0-9]%' ORDER BY CAST(SUBSTRING(ticketId, 2, 20) AS INT) DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                String last = rs.getString("ticketId");
                if (last != null && last.length() > 1) {
                    String numPart = last.substring(1).replaceFirst("^0+", "");
                    int n = (numPart.isEmpty() ? 0 : Integer.parseInt(numPart)) + 1;
                    if (n <= 0) n = 1;
                    return "T" + String.format("%04d", n);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return "T0001";
    }

    public boolean insert(ParkingTicket t) {
        String sql = "INSERT INTO ParkingTicket (ticketId, lotId, slotId, vehiclePlate, checkInTime, staffCheckInId, pricingId, status, note) VALUES (?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, t.getTicketId());
            st.setString(2, t.getLotId());
            st.setString(3, t.getSlotId());
            st.setString(4, t.getVehiclePlate());
            st.setTimestamp(5, t.getCheckInTime() != null ? new java.sql.Timestamp(t.getCheckInTime().getTime()) : null);
            st.setString(6, t.getStaffCheckInId());
            st.setString(7, t.getPricingId());
            st.setString(8, t.getStatus() != null ? t.getStatus() : "PARKING");
            if (t.getNote() != null && !t.getNote().trim().isEmpty())
                st.setString(9, t.getNote().trim());
            else
                st.setNull(9, java.sql.Types.VARCHAR);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            lastInsertError = e.getMessage() + " (SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode() + ")";
            System.err.println("[ParkingTicketDao] INSERT loi: " + e.getMessage());
            System.err.println("  SQLState=" + e.getSQLState() + " ErrorCode=" + e.getErrorCode());
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(ParkingTicket t) {
        String sql = "UPDATE ParkingTicket SET checkOutTime=?, staffCheckOutId=?, totalHours=?, isOvernight=?, totalFee=?, status=? WHERE ticketId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setTimestamp(1, t.getCheckOutTime() != null ? new java.sql.Timestamp(t.getCheckOutTime().getTime()) : null);
            st.setString(2, t.getStaffCheckOutId());
            st.setObject(3, t.getTotalHours());
            st.setObject(4, t.getIsOvernight());
            st.setObject(5, t.getTotalFee());
            st.setString(6, t.getStatus());
            st.setString(7, t.getTicketId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int countParking() {
        String sql = "SELECT COUNT(*) FROM ParkingTicket WHERE status = 'PARKING'";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int countEmptySlots() {
        String sql = "SELECT COUNT(*) FROM ParkingSlot WHERE status = 'EMPTY'";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Integer revenueToday() {
        String sql = "SELECT ISNULL(SUM(totalFee),0) FROM ParkingTicket WHERE status='FINISHED' AND CAST(checkOutTime AS DATE) = CAST(GETDATE() AS DATE)";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Integer revenueByMonth(int year, int month) {
        String sql = "SELECT ISNULL(SUM(totalFee),0) FROM ParkingTicket WHERE status='FINISHED' AND YEAR(checkOutTime)=? AND MONTH(checkOutTime)=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, year);
            st.setInt(2, month);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private ParkingTicket mapRow(ResultSet rs) throws SQLException {
        ParkingTicket t = new ParkingTicket();
        t.setTicketId(rs.getString("ticketId"));
        t.setLotId(rs.getString("lotId"));
        t.setSlotId(rs.getString("slotId"));
        t.setVehiclePlate(rs.getString("vehiclePlate"));
        java.sql.Timestamp tsIn = rs.getTimestamp("checkInTime");
        java.sql.Timestamp tsOut = rs.getTimestamp("checkOutTime");
        t.setCheckInTime(tsIn != null ? new Date(tsIn.getTime()) : null);
        t.setCheckOutTime(tsOut != null ? new Date(tsOut.getTime()) : null);
        t.setStaffCheckInId(rs.getString("staffCheckInId"));
        t.setStaffCheckOutId(rs.getString("staffCheckOutId"));
        t.setPricingId(rs.getString("pricingId"));
        Object oh = rs.getObject("totalHours");
        t.setTotalHours(oh != null ? rs.getInt("totalHours") : null);
        Object io = rs.getObject("isOvernight");
        t.setIsOvernight(io != null ? rs.getBoolean("isOvernight") : null);
        Object tf = rs.getObject("totalFee");
        t.setTotalFee(tf != null ? rs.getInt("totalFee") : null);
        t.setStatus(rs.getString("status"));
        t.setNote(rs.getString("note"));
        return t;
    }
}
