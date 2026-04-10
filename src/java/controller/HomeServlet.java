package controller;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import dal.PricingDao;
import dal.ParkingTicketDao;
import model.ParkingTicket;
import model.Pricing;

public class HomeServlet extends HttpServlet {

    private final ParkingTicketDao ticketDao = new ParkingTicketDao();
    private final PricingDao pricingDao = new PricingDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String plate = request.getParameter("plate");
        if (plate != null) plate = plate.trim().toUpperCase();
        if (plate == null || plate.isEmpty()) {
            request.setAttribute("lookupError", "Vui l\u00F2ng nh\u1EADp bi\u1EC3n s\u1ED1 xe.");
            request.getRequestDispatcher("view/home.jsp").forward(request, response);
            return;
        }

        ParkingTicket t = ticketDao.getByPlateParking(plate);
        if (t == null) {
            request.setAttribute("lookupError", "Kh\u00F4ng t\u00ECm th\u1EA5y xe \u0111ang g\u1EEDi v\u1EDBi bi\u1EC3n s\u1ED1 n\u00E0y.");
            request.setAttribute("lookupPlate", plate);
            request.getRequestDispatcher("view/home.jsp").forward(request, response);
            return;
        }

        Pricing pricing = pricingDao.getById(t.getPricingId());
        if (pricing == null) {
            request.setAttribute("lookupError", "Kh\u00F4ng c\u00F3 b\u1EA3ng gi\u00E1 cho v\u00E9 n\u00E0y.");
            request.setAttribute("lookupPlate", plate);
            request.getRequestDispatcher("view/home.jsp").forward(request, response);
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

        request.setAttribute("lookupPlate", plate);
        request.setAttribute("lookupFee", totalFee);
        request.setAttribute("lookupHours", totalHours);
        request.setAttribute("lookupCheckIn", checkIn);
        request.setAttribute("lookupTicketId", t.getTicketId());
        request.getRequestDispatcher("view/home.jsp").forward(request, response);
    }
}
