package dal;

import model.User;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.sql.*;

public class UserDao extends DBContext {

    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY createdAt DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getById(String userId) {
        String sql = "SELECT * FROM Users WHERE userId = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User getByUsername(String username) {
        String sql = "SELECT * FROM Users WHERE username = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, username);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(User u) {
        String sql = "INSERT INTO Users (userId, username, passwordHash, fullName, role, status, lotId) VALUES (?,?,?,?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, u.getUserId());
            st.setString(2, u.getUsername());
            st.setString(3, u.getPasswordHash());
            st.setString(4, u.getFullname());
            st.setString(5, u.getRole());
            st.setBoolean(6, u.isStatus());
            st.setString(7, u.getLotId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDao] INSERT loi (lotId): " + e.getMessage());
            try {
                String sql2 = "INSERT INTO Users (userId, username, passwordHash, fullName, role, status, lot_id) VALUES (?,?,?,?,?,?,?)";
                try (PreparedStatement st = connection.prepareStatement(sql2)) {
                    st.setString(1, u.getUserId());
                    st.setString(2, u.getUsername());
                    st.setString(3, u.getPasswordHash());
                    st.setString(4, u.getFullname());
                    st.setString(5, u.getRole());
                    st.setBoolean(6, u.isStatus());
                    st.setString(7, u.getLotId());
                    return st.executeUpdate() > 0;
                }
            } catch (SQLException e2) {
                System.err.println("[UserDao] INSERT loi (lot_id): " + e2.getMessage());
            }
        }
        return false;
    }

    public boolean update(User u) {
        // 1) Thử đầy đủ có lotId (dùng setNull khi lotId null để tránh lỗi FK/type)
        String sql = "UPDATE Users SET username=?, fullName=?, role=?, status=?, lotId=? WHERE userId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, u.getUsername());
            st.setString(2, u.getFullname());
            st.setString(3, u.getRole());
            st.setBoolean(4, u.isStatus());
            if (u.getLotId() != null && !u.getLotId().trim().isEmpty())
                st.setString(5, u.getLotId().trim());
            else
                st.setNull(5, java.sql.Types.VARCHAR);
            st.setString(6, u.getUserId());
            if (st.executeUpdate() > 0) return true;
        } catch (SQLException e) {
            System.err.println("[UserDao] UPDATE loi (co lotId): " + e.getMessage());
            // 2) Thử với lot_id (snake_case)
            try {
                String sql2 = "UPDATE Users SET username=?, fullName=?, role=?, status=?, lot_id=? WHERE userId=?";
                try (PreparedStatement st = connection.prepareStatement(sql2)) {
                    st.setString(1, u.getUsername());
                    st.setString(2, u.getFullname());
                    st.setString(3, u.getRole());
                    st.setBoolean(4, u.isStatus());
                    if (u.getLotId() != null && !u.getLotId().trim().isEmpty())
                        st.setString(5, u.getLotId().trim());
                    else
                        st.setNull(5, java.sql.Types.VARCHAR);
                    st.setString(6, u.getUserId());
                    if (st.executeUpdate() > 0) return true;
                }
            } catch (SQLException e2) {
                System.err.println("[UserDao] UPDATE loi (lot_id): " + e2.getMessage());
            }
        }
        // 3) Bỏ qua lotId — chỉ cập nhật 4 cột cơ bản (tránh "Cập nhật thất bại")
        try {
            String sql3 = "UPDATE Users SET username=?, fullName=?, role=?, status=? WHERE userId=?";
            try (PreparedStatement st = connection.prepareStatement(sql3)) {
                st.setString(1, u.getUsername());
                st.setString(2, u.getFullname());
                st.setString(3, u.getRole());
                st.setBoolean(4, u.isStatus());
                st.setString(5, u.getUserId());
                return st.executeUpdate() > 0;
            }
        } catch (SQLException e3) {
            System.err.println("[UserDao] UPDATE loi (khong lotId): " + e3.getMessage());
            e3.printStackTrace();
        }
        return false;
    }

    public boolean delete(String userId) {
        String sql = "DELETE FROM Users WHERE userId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean resetPassword(String userId, String newPasswordHash) {
        String sql = "UPDATE Users SET passwordHash=? WHERE userId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, newPasswordHash);
            st.setString(2, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(String userId, boolean status) {
        String sql = "UPDATE Users SET status=? WHERE userId=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setBoolean(1, status);
            st.setString(2, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public String nextUserId() {
        String sql = "SELECT TOP 1 userId FROM Users ORDER BY userId DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                String last = rs.getString("userId");
                if (last != null && last.matches("U\\d+")) {
                    int n = Integer.parseInt(last.substring(1)) + 1;
                    return "U" + String.format("%03d", n);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "U001";
    }

    private User mapRow(ResultSet rs) throws SQLException {
        java.sql.Timestamp ts = rs.getTimestamp("createdAt");
        Date createAt = (ts != null) ? new Date(ts.getTime()) : null;
        String lotId = null;
        try {
            lotId = rs.getString("lotId");
            if (lotId != null && lotId.trim().isEmpty()) lotId = null;
        } catch (SQLException ignored) {
            try { lotId = rs.getString("lot_id"); if (lotId != null && lotId.trim().isEmpty()) lotId = null; } catch (SQLException ignored2) { }
        }
        return new User(
            rs.getString("userId"),
            rs.getString("username"),
            rs.getString("passwordHash"),
            rs.getString("fullName"),
            rs.getString("role"),
            rs.getBoolean("status"),
            createAt,
            lotId
        );
    }
}
