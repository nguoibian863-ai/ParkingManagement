/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
import java.util.Date;

public class User {
    private String userId;
    private String username;
    private String passwordHash;
    private String fullname;
    private String role;
    private boolean status;
    private Date createAt;
    private String lotId;

    public User() {
    }

    public User(String userId, String username, String passwordHash, String fullname, String role, boolean status, Date createAt) {
        this(userId, username, passwordHash, fullname, role, status, createAt, null);
    }

    public User(String userId, String username, String passwordHash, String fullname, String role, boolean status, Date createAt, String lotId) {
        this.userId = userId;
        this.username = username;
        this.passwordHash = passwordHash;
        this.fullname = fullname;
        this.role = role;
        this.status = status;
        this.createAt = createAt;
        this.lotId = lotId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

    public String getLotId() {
        return lotId;
    }

    public void setLotId(String lotId) {
        this.lotId = lotId;
    }
}
