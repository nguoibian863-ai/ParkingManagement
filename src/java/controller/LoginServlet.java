package controller;

import dal.LoginDao;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

/**
 * Đăng nhập thống nhất - phân quyền theo role (ADMIN -> /admin, STAFF -> /staff).
 */
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if (username != null) username = username.trim();

        LoginDao dao = new LoginDao();
        User user = dao.checkLogin(username, password);

        if (user != null) {
            request.getSession().setAttribute("account", user);
            String role = user.getRole();
            if ("ADMIN".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else if ("STAFF".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/staff");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("error", "Sai t\u00EAn \u0111\u0103ng nh\u1EADp ho\u1EB7c m\u1EADt kh\u1EA9u!");
            request.getRequestDispatcher("view/login.jsp").forward(request, response);
        }
    }
}
