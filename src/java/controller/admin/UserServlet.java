package controller.admin;

import dal.ParkingLotDao;
import dal.UserDao;
import model.ParkingLot;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import util.PasswordUtil;
public class UserServlet extends HttpServlet {

    private final UserDao dao = new UserDao();
    private final ParkingLotDao lotDao = new ParkingLotDao();
    private static final String BASE = "/view/admin/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        String action = request.getParameter("action");
        if (action == null) action = "list";
        List<ParkingLot> lotList = lotDao.getAll();
        request.setAttribute("lotList", lotList);
        switch (action) {
            case "add":
                request.getRequestDispatcher(BASE + "user-add.jsp").forward(request, response);
                break;
            case "edit":
                String editId = request.getParameter("id");
                if (editId != null) {
                    User u = dao.getById(editId);
                    if (u != null) {
                        request.setAttribute("user", u);
                        request.getRequestDispatcher(BASE + "user-edit.jsp").forward(request, response);
                    } else response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
                } else response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
                break;
            case "delete":
                String delId = request.getParameter("id");
                if (delId != null) dao.delete(delId);
                response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
                break;
            case "reset":
                String resetId = request.getParameter("id");
                if (resetId != null) {
                    dao.resetPassword(resetId, PasswordUtil.hashPassword("123"));
                    request.getSession().setAttribute("message", "\u0110\u00E3 reset m\u1EADt kh\u1EA9u th\u00E0nh 123");
                }
                response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
                break;
            case "toggle":
                String toggleId = request.getParameter("id");
                if (toggleId != null) {
                    User u = dao.getById(toggleId);
                    if (u != null) dao.updateStatus(toggleId, !u.isStatus());
                }
                response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
                break;
            default:
                List<User> list = dao.getAll();
                request.setAttribute("userList", list);
                java.util.Map<String, String> lotMap = new java.util.HashMap<>();
                for (ParkingLot lot : lotList) lotMap.put(lot.getLotId(), lot.getLotName());
                request.setAttribute("lotMap", lotMap);
                request.getRequestDispatcher(BASE + "user-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String userId = request.getParameter("userId");
            String username = request.getParameter("username");  
             String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");
            String statusStr = request.getParameter("status");
            if (userId != null && username != null && password != null) {
                String lotId = request.getParameter("lotId");
                if (lotId != null && lotId.trim().isEmpty()) lotId = null;
                User u = new User(userId, username, PasswordUtil.hashPassword(password.trim()), fullName != null ? fullName : "", role != null ? role : "STAFF", "1".equals(statusStr), null, lotId);
                if (dao.getByUsername(username) != null) {
                    request.setAttribute("error", "Username \u0111\u00E3 t\u1ED3n t\u1EA1i.");
                    request.setAttribute("lotList", lotDao.getAll());
                    request.getRequestDispatcher(BASE + "user-add.jsp").forward(request, response);
                } else if (dao.insert(u)) {
                    response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
                } else {
                    request.setAttribute("error", "Th\u00EAm th\u1EA5t b\u1EA1i.");
                    request.setAttribute("lotList", lotDao.getAll());
                    request.getRequestDispatcher(BASE + "user-add.jsp").forward(request, response);
                }
            } else response.sendRedirect(request.getContextPath() + "/admin/user?action=add");
        } else if ("edit".equals(action)) {
            String userId = request.getParameter("userId");
            String username = request.getParameter("username");
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");
            String statusStr = request.getParameter("status");
            String lotId = request.getParameter("lotId");
            if (lotId != null && lotId.trim().isEmpty()) lotId = null;
            if (userId != null) {
                User u = dao.getById(userId);
                if (u != null) {
                    if (lotId != null && lotDao.getById(lotId) == null) {
                        request.setAttribute("error", "B\u00E3i xe \u0111\u00E3 ch\u1ECDn kh\u00F4ng t\u1ED3n t\u1EA1i.");
                        request.setAttribute("user", u);
                        request.setAttribute("lotList", lotDao.getAll());
                        request.getRequestDispatcher(BASE + "user-edit.jsp").forward(request, response);
                        return;
                    }
                    u.setUsername(username);
                    u.setFullname(fullName != null ? fullName : "");
                    u.setRole(role != null ? role : "STAFF");
                    u.setStatus("1".equals(statusStr));
                    u.setLotId(lotId);
                    if (dao.update(u)) {
                        response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
                        return;
                    }
                    request.setAttribute("error", "C\u1EADp nh\u1EADt th\u1EA5t b\u1EA1i. Ki\u1EC3m tra b\u00E3i \u0111\u00E3 ch\u1ECDn c\u00F3 t\u1ED3n t\u1EA1i trong danh s\u00E1ch b\u00E3i xe.");
                }
                request.setAttribute("user", u);
                request.setAttribute("lotList", lotDao.getAll());
                request.getRequestDispatcher(BASE + "user-edit.jsp").forward(request, response);
            } else response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
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
