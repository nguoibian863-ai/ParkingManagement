package controller.admin;

import dal.ParkingTicketDao;
import dal.UserDao;
import model.ParkingTicket;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class TicketServlet extends HttpServlet {

    private final ParkingTicketDao ticketDao = new ParkingTicketDao();
    private final UserDao userDao = new UserDao();
    private static final String BASE = "/view/admin/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        String action = request.getParameter("action");
        if (action == null) action = "list";
        if ("detail".equals(action)) {
            String id = request.getParameter("id");
            if (id != null) {
                ParkingTicket t = ticketDao.getById(id);
                if (t != null) {
                    request.setAttribute("ticket", t);
                    request.setAttribute("userDao", userDao);
                    request.getRequestDispatcher(BASE + "ticket-detail.jsp").forward(request, response);
                } else response.sendRedirect(request.getContextPath() + "/admin/ticket");
            } else response.sendRedirect(request.getContextPath() + "/admin/ticket");
            return;
        }
        String plate = request.getParameter("plate");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");
        String staffId = request.getParameter("staffId");
        List<ParkingTicket> list;
        if ((plate != null && !plate.trim().isEmpty()) || (dateFrom != null && !dateFrom.isEmpty()) || (dateTo != null && !dateTo.isEmpty()) || (staffId != null && !staffId.isEmpty())) {
            list = ticketDao.search(plate, dateFrom, dateTo, staffId);
        } else {
            list = ticketDao.getAll();
        }
        request.setAttribute("ticketList", list);
        request.setAttribute("staffList", userDao.getAll());
        request.getRequestDispatcher(BASE + "ticket-list.jsp").forward(request, response);
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
