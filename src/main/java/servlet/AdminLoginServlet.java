package servlet;

import model.User;
import service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User admin = session == null ? null : (User) session.getAttribute("admin");

        if (admin != null && "ADMIN".equalsIgnoreCase(admin.getUserRole())) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        req.getRequestDispatcher("/admin/AdminLogin.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (!userService.isValidEmail(email)) {
            req.setAttribute("error", "Please enter a valid admin email");
            req.getRequestDispatcher("/admin/AdminLogin.jsp").forward(req, res);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Password is required");
            req.getRequestDispatcher("/admin/AdminLogin.jsp").forward(req, res);
            return;
        }

        User user = userService.login(email, password);

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getUserRole())) {
            req.setAttribute("error", "Invalid admin credentials");
            req.getRequestDispatcher("/admin/AdminLogin.jsp").forward(req, res);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("admin", user);
        session.setMaxInactiveInterval(30 * 60);

        res.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
