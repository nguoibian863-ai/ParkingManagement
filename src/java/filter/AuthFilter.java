package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (!(request instanceof HttpServletRequest) || !(response instanceof HttpServletResponse)) {
            chain.doFilter(request, response);
            return;
        }

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String ctx = req.getContextPath();
        String uri = req.getRequestURI();
        String path = (uri != null && ctx != null && uri.startsWith(ctx)) ? uri.substring(ctx.length()) : uri;
        if (path == null) path = "";

        HttpSession session = req.getSession(false);
        Object accObj = (session != null) ? session.getAttribute("account") : null;
        if (!(accObj instanceof User)) {
            res.sendRedirect(ctx + "/login");
            return;
        }

        User acc = (User) accObj;
        String role = acc.getRole() != null ? acc.getRole() : "";

        if (path.startsWith("/admin") && !"ADMIN".equalsIgnoreCase(role)) {
            res.sendRedirect(ctx + "/login");
            return;
        }
        if (path.startsWith("/staff") && !"STAFF".equalsIgnoreCase(role)) {
            res.sendRedirect(ctx + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}

