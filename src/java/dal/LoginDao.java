/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.User;
import java.util.Date;
import java.sql.*;
import util.PasswordUtil;
/**
 *
 * @author Admin
 */
public class LoginDao extends DBContext {
    
    //Check Login
    public User checkLogin(String username, String password) {
        String sql ="SELECT * FROM Users WHERE username = ? AND status = 1";
        
        try{
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            
            if(rs.next()){
                String stored = rs.getString("passwordHash");
                if (!PasswordUtil.verifyPassword(password, stored)) return null;

                String userId = rs.getString("userId");
                if (PasswordUtil.needsUpgrade(stored)) {
                    new UserDao().resetPassword(userId, PasswordUtil.hashPassword(password));
                }

                java.sql.Timestamp ts = rs.getTimestamp("createdAt");
                Date createAt = (ts != null) ? new Date(ts.getTime()) : null;
                User u = new User(
                        userId,
                        rs.getString("username"),
                        stored,
                        rs.getString("fullName"),
                        rs.getString("role"),
                        rs.getBoolean("status"),
                        createAt
                );
                String lotId = null;
                try { lotId = rs.getString("lotId"); if (lotId != null && lotId.trim().isEmpty()) lotId = null; } catch (SQLException ignored) { }
                u.setLotId(lotId);
                return u;
            }
        }catch(SQLException e){
            e.printStackTrace();
        }
        return null;
    }
    
    
    
}
