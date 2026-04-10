package controller.admin;

import dal.ParkingSlotDao;
import dal.ParkingLotDao;
import model.ParkingSlot;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class SlotServlet extends HttpServlet {

    private final ParkingSlotDao slotDao = new ParkingSlotDao();
    private final ParkingLotDao lotDao = new ParkingLotDao();
    private static final String BASE = "/view/admin/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "add":
                request.setAttribute("nextId", slotDao.nextSlotId());
                request.setAttribute("lotList", lotDao.getAll());
                request.getRequestDispatcher(BASE + "slot-add.jsp").forward(request, response);
                break;
            case "edit":
                String editId = request.getParameter("id");
                if (editId != null) {
                    ParkingSlot s = slotDao.getById(editId);
                    if (s != null) {
                        request.setAttribute("slot", s);
                        request.setAttribute("lotList", lotDao.getAll());
                        request.getRequestDispatcher(BASE + "slot-edit.jsp").forward(request, response);
                    } else response.sendRedirect(request.getContextPath() + "/admin/slot");
                } else response.sendRedirect(request.getContextPath() + "/admin/slot");
                break;
            case "delete":
                String delId = request.getParameter("id");
                if (delId != null) slotDao.delete(delId);
                response.sendRedirect(request.getContextPath() + "/admin/slot");
                break;
            default:
                request.setAttribute("slotList", slotDao.getAll());
                request.setAttribute("lotDao", lotDao);
                request.getRequestDispatcher(BASE + "slot-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String slotId = request.getParameter("slotId");
            String lotId = request.getParameter("lotId");
            String slotCode = request.getParameter("slotCode");
            String status = request.getParameter("status");
            String note = request.getParameter("note");
            if (slotId != null && lotId != null && slotCode != null) {
                ParkingSlot s = new ParkingSlot(slotId, lotId, slotCode, status != null ? status : "EMPTY", note, null);
                if (slotDao.insert(s)) response.sendRedirect(request.getContextPath() + "/admin/slot");
                else {
                    request.setAttribute("error", "Th\u00EAm th\u1EA5t b\u1EA1i.");
                    request.setAttribute("nextId", slotDao.nextSlotId());
                    request.setAttribute("lotList", lotDao.getAll());
                    request.getRequestDispatcher(BASE + "slot-add.jsp").forward(request, response);
                }
            } else response.sendRedirect(request.getContextPath() + "/admin/slot?action=add");
        } else if ("edit".equals(action)) {
            String slotId = request.getParameter("slotId");
            String lotId = request.getParameter("lotId");
            String slotCode = request.getParameter("slotCode");
            String status = request.getParameter("status");
            String note = request.getParameter("note");
            if (slotId != null) {
                ParkingSlot s = slotDao.getById(slotId);
                if (s != null) {
                    s.setLotId(lotId);
                    s.setSlotCode(slotCode);
                    s.setStatus(status != null ? status : "EMPTY");
                    s.setNote(note);
                    if (slotDao.update(s)) {
                        response.sendRedirect(request.getContextPath() + "/admin/slot");
                        return;
                    }
                    request.setAttribute("error", "C\u1EADp nh\u1EADt th\u1EA5t b\u1EA1i.");
                }
                request.setAttribute("slot", s);
                request.setAttribute("lotList", lotDao.getAll());
                request.getRequestDispatcher(BASE + "slot-edit.jsp").forward(request, response);
            } else response.sendRedirect(request.getContextPath() + "/admin/slot");
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
