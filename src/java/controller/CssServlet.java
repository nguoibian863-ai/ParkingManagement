package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * Serves style.css with correct Content-Type so CSS loads even if default servlet or filter misbehaves.
 */
public class CssServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/css; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        try (InputStream in = getServletContext().getResourceAsStream("/css/style.css");
             OutputStream out = response.getOutputStream()) {
            if (in == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            byte[] buf = new byte[8192];
            int n;
            while ((n = in.read(buf)) > 0) {
                out.write(buf, 0, n);
            }
        }
    }
}
