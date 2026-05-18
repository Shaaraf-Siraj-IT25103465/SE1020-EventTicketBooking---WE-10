package servlet;

import model.User;
import service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/user/login")
public class UserLoginServlet extends HttpServlet {

    private final UserService userService = new UserService();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            res.sendRedirect(req.getContextPath() + "/client/dashboard.jsp");
            return;
        }
        req.getRequestDispatcher("/client/UserLogin.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (!userService.isValidEmail(email)) {
            req.setAttribute("error", "Please enter a valid email address");
            req.getRequestDispatcher("/client/UserLogin.jsp").forward(req, res);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Password is required");
            req.getRequestDispatcher("/client/UserLogin.jsp").forward(req, res);
            return;
        }

        User user = userService.login(
                email,
                password
        );

        if (user != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("fullName", user.getFullName());
            session.setMaxInactiveInterval(30 * 60);

            res.sendRedirect(req.getContextPath() + "/client/dashboard.jsp");
        } else {
            req.setAttribute("error", "Invalid email or password");
            req.getRequestDispatcher("/client/UserLogin.jsp").forward(req, res);
        }
    }
}
