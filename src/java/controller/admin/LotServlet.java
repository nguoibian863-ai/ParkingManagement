package controller.admin;

import dal.ParkingLotDao;
import model.ParkingLot;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class LotServlet extends HttpServlet {

    private final ParkingLotDao dao = new ParkingLotDao();
    private static final String BASE = "/view/admin/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "add":
                request.setAttribute("nextId", dao.nextLotId());
                request.getRequestDispatcher(BASE + "lot-add.jsp").forward(request, response);
                break;
            case "edit":
                String editId = request.getParameter("id");
                if (editId != null) {
                    ParkingLot p = dao.getById(editId);
                    if (p != null) {
                        request.setAttribute("lot", p);
                        request.getRequestDispatcher(BASE + "lot-edit.jsp").forward(request, response);
                    } else response.sendRedirect(request.getContextPath() + "/admin/lot");
                } else response.sendRedirect(request.getContextPath() + "/admin/lot");
                break;
            case "delete":
                String delId = request.getParameter("id");
                if (delId != null) dao.delete(delId);
                response.sendRedirect(request.getContextPath() + "/admin/lot");
                break;
            default:
                List<ParkingLot> list = dao.getAll();
                request.setAttribute("lotList", list);
                request.setAttribute("lotDao", dao);
                request.getRequestDispatcher(BASE + "lot-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String lotId = request.getParameter("lotId");
            String lotName = request.getParameter("lotName");
            String address = request.getParameter("address");
            String note = request.getParameter("note");
            boolean status = "1".equals(request.getParameter("status"));
            if (lotId != null && lotName != null) {
                ParkingLot p = new ParkingLot(lotId, lotName, address, note, status, null);
                if (dao.insert(p)) response.sendRedirect(request.getContextPath() + "/admin/lot");
                else {
                    request.setAttribute("error", "Th\u00EAm th\u1EA5t b\u1EA1i.");
                    request.setAttribute("nextId", dao.nextLotId());
                    request.getRequestDispatcher(BASE + "lot-add.jsp").forward(request, response);
                }
            } else response.sendRedirect(request.getContextPath() + "/admin/lot?action=add");
        } else if ("edit".equals(action)) {
            String lotId = request.getParameter("lotId");
            String lotName = request.getParameter("lotName");
            String address = request.getParameter("address");
            String note = request.getParameter("note");
            boolean status = "1".equals(request.getParameter("status"));
            if (lotId != null) {
                ParkingLot p = dao.getById(lotId);
                if (p != null) {
                    p.setLotName(lotName);
                    p.setAddress(address);
                    p.setNote(note);
                    p.setStatus(status);
                    if (dao.update(p)) {
                        response.sendRedirect(request.getContextPath() + "/admin/lot");
                        return;
                    }
                    request.setAttribute("error", "C\u1EADp nh\u1EADt th\u1EA5t b\u1EA1i.");
                }
                request.setAttribute("lot", p);
                request.getRequestDispatcher(BASE + "lot-edit.jsp").forward(request, response);
            } else response.sendRedirect(request.getContextPath() + "/admin/lot");
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
