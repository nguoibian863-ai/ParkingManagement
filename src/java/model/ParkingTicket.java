package model;

import java.util.Date;

public class ParkingTicket {
    private String ticketId;
    private String lotId;
    private String slotId;
    private String vehiclePlate;

    private Date checkInTime;
    private Date checkOutTime;

    private String staffCheckInId;
    private String staffCheckOutId;

    private String pricingId;

    private Integer totalHours;
    private Boolean isOvernight;
    private Integer totalFee;

    private String status; 
    private String note;

    public ParkingTicket() {
    }

    public ParkingTicket(String ticketId, String lotId, String slotId, String vehiclePlate, Date checkInTime, Date checkOutTime, String staffCheckInId, String staffCheckOutId, String pricingId, Integer totalHours, Boolean isOvernight, Integer totalFee, String status, String note) {
        this.ticketId = ticketId;
        this.lotId = lotId;
        this.slotId = slotId;
        this.vehiclePlate = vehiclePlate;
        this.checkInTime = checkInTime;
        this.checkOutTime = checkOutTime;
        this.staffCheckInId = staffCheckInId;
        this.staffCheckOutId = staffCheckOutId;
        this.pricingId = pricingId;
        this.totalHours = totalHours;
        this.isOvernight = isOvernight;
        this.totalFee = totalFee;
        this.status = status;
        this.note = note;
    }

    public String getTicketId() {
        return ticketId;
    }

    public void setTicketId(String ticketId) {
        this.ticketId = ticketId;
    }

    public String getLotId() {
        return lotId;
    }

    public void setLotId(String lotId) {
        this.lotId = lotId;
    }

    public String getSlotId() {
        return slotId;
    }

    public void setSlotId(String slotId) {
        this.slotId = slotId;
    }

    public String getVehiclePlate() {
        return vehiclePlate;
    }

    public void setVehiclePlate(String vehiclePlate) {
        this.vehiclePlate = vehiclePlate;
    }

    public Date getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(Date checkInTime) {
        this.checkInTime = checkInTime;
    }

    public Date getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(Date checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public String getStaffCheckInId() {
        return staffCheckInId;
    }

    public void setStaffCheckInId(String staffCheckInId) {
        this.staffCheckInId = staffCheckInId;
    }

    public String getStaffCheckOutId() {
        return staffCheckOutId;
    }

    public void setStaffCheckOutId(String staffCheckOutId) {
        this.staffCheckOutId = staffCheckOutId;
    }

    public String getPricingId() {
        return pricingId;
    }

    public void setPricingId(String pricingId) {
        this.pricingId = pricingId;
    }

    public Integer getTotalHours() {
        return totalHours;
    }

    public void setTotalHours(Integer totalHours) {
        this.totalHours = totalHours;
    }

    public Boolean getIsOvernight() {
        return isOvernight;
    }

    public void setIsOvernight(Boolean isOvernight) {
        this.isOvernight = isOvernight;
    }

    public Integer getTotalFee() {
        return totalFee;
    }

    public void setTotalFee(Integer totalFee) {
        this.totalFee = totalFee;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    
}
