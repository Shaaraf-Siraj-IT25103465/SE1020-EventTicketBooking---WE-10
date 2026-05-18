package filter;

import model.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());
        HttpSession session = req.getSession(false);

        if (path.startsWith("/admin") || path.startsWith("/client") || "/user/profile".equals(path)) {
            res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            res.setHeader("Pragma", "no-cache");
            res.setDateHeader("Expires", 0);
        }

        if (path.startsWith("/admin")) {
            if ("/admin/login".equals(path) || "/admin".equals(path)) {
                chain.doFilter(request, response);
                return;
            }

            User admin = session == null ? null : (User) session.getAttribute("admin");
            if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getUserRole())) {
                res.sendRedirect(req.getContextPath() + "/admin/login");
                return;
            }

            chain.doFilter(request, response);
            return;
        }

        if (path.startsWith("/client") || "/user/profile".equals(path)) {
            User user = session == null ? null : (User) session.getAttribute("user");
            if (user == null) {
                res.sendRedirect(req.getContextPath() + "/user/login");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
