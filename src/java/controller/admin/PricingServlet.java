package controller.admin;

import dal.PricingDao;
import model.Pricing;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class PricingServlet extends HttpServlet {

    private final PricingDao dao = new PricingDao();
    private static final String BASE = "/view/admin/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "add":
                request.setAttribute("nextId", dao.nextPricingId());
                request.getRequestDispatcher(BASE + "pricing-add.jsp").forward(request, response);
                break;
            case "edit":
                String editId = request.getParameter("id");
                if (editId != null) {
                    Pricing p = dao.getById(editId);
                    if (p != null) {
                        request.setAttribute("pricing", p);
                        request.getRequestDispatcher(BASE + "pricing-edit.jsp").forward(request, response);
                    } else response.sendRedirect(request.getContextPath() + "/admin/pricing");
                } else response.sendRedirect(request.getContextPath() + "/admin/pricing");
                break;
            case "delete":
                String delId = request.getParameter("id");
                if (delId != null) dao.delete(delId);
                response.sendRedirect(request.getContextPath() + "/admin/pricing");
                break;
            default:
                request.setAttribute("pricingList", dao.getAll());
                request.getRequestDispatcher(BASE + "pricing-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String pricingId = request.getParameter("pricingId");
            String vehicleType = request.getParameter("vehicleType");
            String ph = request.getParameter("pricePerHour");
            String ov = request.getParameter("overnightFee");
            boolean active = "1".equals(request.getParameter("active"));
            if (pricingId != null && vehicleType != null && ph != null) {
                int pricePerHour = 0, overnightFee = 0;
                try { pricePerHour = Integer.parseInt(ph); overnightFee = Integer.parseInt(ov != null ? ov : "0"); } catch (NumberFormatException e) {}
                Pricing p = new Pricing(pricingId, vehicleType, pricePerHour, overnightFee, active, null);
                if (dao.insert(p)) response.sendRedirect(request.getContextPath() + "/admin/pricing");
                else {
                    request.setAttribute("error", "Th\u00EAm th\u1EA5t b\u1EA1i.");
                    request.setAttribute("nextId", dao.nextPricingId());
                    request.getRequestDispatcher(BASE + "pricing-add.jsp").forward(request, response);
                }
            } else response.sendRedirect(request.getContextPath() + "/admin/pricing?action=add");
        } else if ("edit".equals(action)) {
            String pricingId = request.getParameter("pricingId");
            String vehicleType = request.getParameter("vehicleType");
            String ph = request.getParameter("pricePerHour");
            String ov = request.getParameter("overnightFee");
            boolean active = "1".equals(request.getParameter("active"));
            if (pricingId != null) {
                Pricing p = dao.getById(pricingId);
                if (p != null) {
                    p.setVehicleType(vehicleType);
                    try { p.setPricePerHour(Integer.parseInt(ph)); p.setOvernightFee(Integer.parseInt(ov != null ? ov : "0")); } catch (NumberFormatException e) {}
                    p.setActive(active);
                    if (dao.update(p)) {
                        response.sendRedirect(request.getContextPath() + "/admin/pricing");
                        return;
                    }
                    request.setAttribute("error", "C\u1EADp nh\u1EADt th\u1EA5t b\u1EA1i.");
                }
                request.setAttribute("pricing", p);
                request.getRequestDispatcher(BASE + "pricing-edit.jsp").forward(request, response);
            } else response.sendRedirect(request.getContextPath() + "/admin/pricing");
        } else doGet(request, response);
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
