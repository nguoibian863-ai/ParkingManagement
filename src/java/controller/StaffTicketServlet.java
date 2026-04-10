package controller;

import dal.ParkingLotDao;
import dal.ParkingSlotDao;
import dal.ParkingTicketDao;
import dal.PricingDao;
import model.ParkingSlot;
import model.ParkingTicket;
import model.Pricing;
import model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class StaffTicketServlet extends HttpServlet {

    private final ParkingTicketDao ticketDao = new ParkingTicketDao();
    private final ParkingSlotDao slotDao = new ParkingSlotDao();
    private final ParkingLotDao lotDao = new ParkingLotDao();
    private final PricingDao pricingDao = new PricingDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkStaff(request, response)) return;
        String action = request.getParameter("action");
        if (action == null) action = "checkin";
        String ctx = request.getContextPath();

        switch (action) {
            case "checkin":
                doCheckInForm(request, response);
                break;
            case "checkout":
                doCheckOutForm(request, response);
                break;
            case "list":
                doListParking(request, response);
                break;
            case "history":
                doHistory(request, response);
                break;
            case "invoice":
                doInvoice(request, response);
                break;
            default:
                response.sendRedirect(ctx + "/staff/ticket?action=checkin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkStaff(request, response)) return;
        String action = request.getParameter("action");
        String ctx = request.getContextPath();

        if ("checkin".equals(action)) {
            doCheckInSubmit(request, response);
        } else if ("checkout".equals(action)) {
            doCheckOutSubmit(request, response);
        } else {
            response.sendRedirect(ctx + "/staff/ticket?action=checkin");
        }
    }

    private void doCheckInForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ParkingSlot> emptySlots = new ArrayList<>();
        for (ParkingSlot s : slotDao.getAll()) {
            if ("EMPTY".equals(s.getStatus())) emptySlots.add(s);
        }
        request.setAttribute("lotList", lotDao.getAll());
        request.setAttribute("emptySlots", emptySlots);
        request.setAttribute("lotDao", lotDao);
        request.setAttribute("pricingList", pricingDao.getAll());
        request.getRequestDispatcher("/view/staff/check-in.jsp").forward(request, response);
    }

    private void doCheckInSubmit(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String ctx = request.getContextPath();
        String vehiclePlate = request.getParameter("vehiclePlate");
        String vehicleType = request.getParameter("vehicleType");
        String slotId = request.getParameter("slotId");

        if (vehiclePlate == null || vehiclePlate.trim().isEmpty()
                || slotId == null || slotId.trim().isEmpty()
                || vehicleType == null || vehicleType.trim().isEmpty()) {
            response.sendRedirect(ctx + "/staff/ticket?action=checkin&err=missing");
            return;
        }
        vehiclePlate = vehiclePlate.trim().toUpperCase();
        slotId = slotId.trim();

        if (ticketDao.getByPlateParking(vehiclePlate) != null) {
            response.sendRedirect(ctx + "/staff/ticket?action=checkin&err=plate");
            return;
        }

        ParkingSlot slot = slotDao.getById(slotId);
        if (slot == null || !"EMPTY".equals(slot.getStatus())) {
            response.sendRedirect(ctx + "/staff/ticket?action=checkin&err=slot");
            return;
        }

        Pricing pricing = pricingDao.getByVehicleType(vehicleType.trim());
        if (pricing == null) {
            response.sendRedirect(ctx + "/staff/ticket?action=checkin&err=pricing");
            return;
        }

        User acc = (User) request.getSession().getAttribute("account");
        ParkingTicket t = new ParkingTicket();
        t.setTicketId(ticketDao.nextTicketId());
        t.setLotId(slot.getLotId());
        t.setSlotId(slotId);
        t.setVehiclePlate(vehiclePlate);
        t.setCheckInTime(new Date());
        t.setStaffCheckInId(acc.getUserId());
        t.setPricingId(pricing.getPricingId());
        t.setStatus("PARKING");

        if (ticketDao.insert(t)) {
            slotDao.updateStatus(slotId, "OCCUPIED");
            response.sendRedirect(ctx + "/staff/ticket?action=checkin&ok=1");
            return;
        }
        String detail = dal.ParkingTicketDao.getLastInsertError();
        if (detail != null && (detail.contains("2627") || detail.contains("duplicate key"))) {
            t.setTicketId(ticketDao.nextTicketId());
            if (ticketDao.insert(t)) {
                slotDao.updateStatus(slotId, "OCCUPIED");
                response.sendRedirect(ctx + "/staff/ticket?action=checkin&ok=1");
                return;
            }
        }
        if (detail != null && !detail.isEmpty())
            request.getSession().setAttribute("checkInErrorDetail", detail);
        response.sendRedirect(ctx + "/staff/ticket?action=checkin&err=db");
    }

    private void doCheckOutForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/view/staff/check-out.jsp").forward(request, response);
    }

    private void doCheckOutSubmit(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String ctx = request.getContextPath();
        String vehiclePlate = request.getParameter("vehiclePlate");
        if (vehiclePlate == null || vehiclePlate.trim().isEmpty()) {
            response.sendRedirect(ctx + "/staff/ticket?action=checkout&err=missing");
            return;
        }
        vehiclePlate = vehiclePlate.trim().toUpperCase();

        ParkingTicket t = ticketDao.getByPlateParking(vehiclePlate);
        if (t == null) {
            response.sendRedirect(ctx + "/staff/ticket?action=checkout&err=notfound");
            return;
        }

        Pricing pricing = pricingDao.getById(t.getPricingId());
        if (pricing == null) {
            response.sendRedirect(ctx + "/staff/ticket?action=checkout&err=pricing");
            return;
        }

        Date checkOut = new Date();
        Date checkIn = t.getCheckInTime();
        long diffMs = checkOut.getTime() - checkIn.getTime();
        int totalHours = (int) Math.max(1, Math.ceil(diffMs / (1000.0 * 60 * 60)));

        Calendar calIn = Calendar.getInstance();
        calIn.setTime(checkIn);
        Calendar calOut = Calendar.getInstance();
        calOut.setTime(checkOut);
        boolean isOvernight = calIn.get(Calendar.DATE) != calOut.get(Calendar.DATE)
                || calIn.get(Calendar.MONTH) != calOut.get(Calendar.MONTH)
                || calIn.get(Calendar.YEAR) != calOut.get(Calendar.YEAR);

        int totalFee = totalHours * pricing.getPricePerHour();
        if (isOvernight) totalFee += pricing.getOvernightFee();

        User acc = (User) request.getSession().getAttribute("account");
        t.setCheckOutTime(checkOut);
        t.setStaffCheckOutId(acc.getUserId());
        t.setTotalHours(totalHours);
        t.setIsOvernight(isOvernight);
        t.setTotalFee(totalFee);
        t.setStatus("FINISHED");

        if (ticketDao.update(t)) {
            slotDao.updateStatus(t.getSlotId(), "EMPTY");
            response.sendRedirect(ctx + "/staff/ticket?action=invoice&id=" + t.getTicketId());
        } else {
            response.sendRedirect(ctx + "/staff/ticket?action=checkout&err=db");
        }
    }

    private void doListParking(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String plate = request.getParameter("plate");
        List<ParkingTicket> list = ticketDao.getParking(plate);
        request.setAttribute("ticketList", list);
        request.setAttribute("lotDao", lotDao);
        request.getRequestDispatcher("/view/staff/list-parking.jsp").forward(request, response);
    }

    private void doHistory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User acc = (User) request.getSession().getAttribute("account");
        List<ParkingTicket> list = ticketDao.search(null, null, null, acc.getUserId());
        request.setAttribute("ticketList", list);
        request.setAttribute("lotDao", lotDao);
        request.getRequestDispatcher("/view/staff/ticket-history.jsp").forward(request, response);
    }

    private void doInvoice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/staff/ticket?action=checkout");
            return;
        }
        ParkingTicket t = ticketDao.getById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/staff/ticket?action=checkout");
            return;
        }
        request.setAttribute("ticket", t);
        request.setAttribute("lotDao", lotDao);
        request.setAttribute("pricingDao", pricingDao);
        request.getRequestDispatcher("/view/staff/invoice.jsp").forward(request, response);
    }

    private boolean checkStaff(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        User acc = (User) session.getAttribute("account");
        if (!"STAFF".equalsIgnoreCase(acc.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
