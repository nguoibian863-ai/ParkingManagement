package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * Set UTF-8 encoding for all requests and responses so Vietnamese displays correctly.
 * Do not set Content-Type for static resources (.css, .js, images) so the container can serve them correctly.
 */
public class EncodingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        // Only set text/html for non-static resources; otherwise CSS/JS would be sent with wrong Content-Type
        if (response.getContentType() == null && request instanceof HttpServletRequest) {
            String uri = ((HttpServletRequest) request).getRequestURI();
            if (uri != null && !isStaticResource(uri)) {
                response.setContentType("text/html; charset=UTF-8");
            }
        }
        chain.doFilter(request, response);
    }

    private boolean isStaticResource(String uri) {
        String lower = uri.toLowerCase();
        return lower.endsWith(".css") || lower.endsWith(".js") || lower.endsWith(".ico")
                || lower.endsWith(".png") || lower.endsWith(".jpg") || lower.endsWith(".jpeg")
                || lower.endsWith(".gif") || lower.endsWith(".svg") || lower.endsWith(".woff")
                || lower.endsWith(".woff2") || lower.endsWith(".ttf") || lower.endsWith(".eot");
    }
}
