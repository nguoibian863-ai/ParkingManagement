package controller;

import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Xem thông tin cá nhân (tài khoản đang đăng nhập).
 */
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User account = (User) session.getAttribute("account");
        request.setAttribute("account", account);
        String role = account.getRole();
        if ("ADMIN".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/view/admin/profile.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/view/staff/profile.jsp").forward(request, response);
        }
    }
}
