/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Admin
 */
public class Pricing {
    private String pricingId;
    private String vehicleType;
    private int pricePerHour;
    private int overnightFee;
    private boolean active;
    private Date createAt;

    public Pricing() {
    }

    public Pricing(String pricingId, String vehicleType, int pricePerHour, int overnightFee, boolean active, Date createAt) {
        this.pricingId = pricingId;
        this.vehicleType = vehicleType;
        this.pricePerHour = pricePerHour;
        this.overnightFee = overnightFee;
        this.active = active;
        this.createAt = createAt;
    }

    public String getPricingId() {
        return pricingId;
    }

    public void setPricingId(String pricingId) {
        this.pricingId = pricingId;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public int getPricePerHour() {
        return pricePerHour;
    }

    public void setPricePerHour(int pricePerHour) {
        this.pricePerHour = pricePerHour;
    }

    public int getOvernightFee() {
        return overnightFee;
    }

    public void setOvernightFee(int overnightFee) {
        this.overnightFee = overnightFee;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }
    
    
}
