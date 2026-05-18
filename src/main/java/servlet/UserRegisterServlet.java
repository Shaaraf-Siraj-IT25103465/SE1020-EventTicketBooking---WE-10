package servlet;

import model.User;
import service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/user/register")
public class UserRegisterServlet extends HttpServlet {

    private final UserService userService = new UserService();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            res.sendRedirect(req.getContextPath() + "/client/dashboard.jsp");
            return;
        }

        req.getRequestDispatcher("/client/UserRegister.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {
            String firstName = req.getParameter("firstName");
            String lastName = req.getParameter("lastName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phoneNumber");
            String password = req.getParameter("password");

            if (!userService.isValidName(firstName)) {
                throw new IllegalArgumentException("First name must contain only letters and spaces (2-50 chars)");
            }
            if (!userService.isValidName(lastName)) {
                throw new IllegalArgumentException("Last name must contain only letters and spaces (2-50 chars)");
            }
            if (!userService.isValidEmail(email)) {
                throw new IllegalArgumentException("Invalid email address");
            }
            if (!userService.isValidPhone(phone)) {
                throw new IllegalArgumentException("Invalid phone number");
            }
            if (!userService.isValidPassword(password)) {
                throw new IllegalArgumentException("Password must be at least 6 characters and include letters and numbers");
            }

            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPhoneNumber(phone);
            user.setPassword(password);

            userService.register(user);
            res.sendRedirect(req.getContextPath() + "/user/login");

        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/client/UserRegister.jsp").forward(req, res);
        }
    }
}
