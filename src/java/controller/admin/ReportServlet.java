package controller.admin;

import dal.ParkingTicketDao;
import model.User;
import java.io.IOException;
import java.util.Calendar;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class ReportServlet extends HttpServlet {

    private final ParkingTicketDao ticketDao = new ParkingTicketDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        int revenueToday = ticketDao.revenueToday() != null ? ticketDao.revenueToday() : 0;
        Calendar c = Calendar.getInstance();
        int revenueMonth = ticketDao.revenueByMonth(c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1) != null ? ticketDao.revenueByMonth(c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1) : 0;
        int countParking = ticketDao.countParking();
        int countEmpty = ticketDao.countEmptySlots();
        request.setAttribute("revenueToday", revenueToday);
        request.setAttribute("revenueMonth", revenueMonth);
        request.setAttribute("countParking", countParking);
        request.setAttribute("countEmptySlots", countEmpty);
        request.getRequestDispatcher("/view/admin/report.jsp").forward(request, response);
    }

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        User acc = (User) session.getAttribute("account");
        if (!"ADMIN".equalsIgnoreCase(acc.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
