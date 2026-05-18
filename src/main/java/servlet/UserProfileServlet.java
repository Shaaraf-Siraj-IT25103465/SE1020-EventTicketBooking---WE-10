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

@WebServlet("/user/profile")
public class UserProfileServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }

        req.getRequestDispatcher("/client/userProfile.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User sessionUser = session == null ? null : (User) session.getAttribute("user");

        if (sessionUser == null) {
            res.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("changePassword".equals(action)) {
                String newPassword = req.getParameter("newPassword");
                String confirmNewPassword = req.getParameter("confirmNewPassword");

                if (confirmNewPassword == null || !confirmNewPassword.equals(newPassword)) {
                    throw new IllegalArgumentException("New password and confirm password do not match");
                }

                userService.changePassword(
                        sessionUser.getUserId(),
                        req.getParameter("currentPassword"),
                        newPassword
                );
                req.setAttribute("success", "Password updated successfully");
            } else {
                String firstName = req.getParameter("firstName");
                String lastName = req.getParameter("lastName");
                String email = req.getParameter("email");
                String phone = req.getParameter("phoneNumber");

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

                User updated = userService.updateProfile(
                        sessionUser.getUserId(),
                        firstName,
                        lastName,
                        email,
                        phone
                );

                session.setAttribute("user", updated);
                session.setAttribute("fullName", updated.getFullName());
                req.setAttribute("success", "Profile updated successfully");
            }
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
        }

        req.getRequestDispatcher("/client/userProfile.jsp").forward(req, res);
    }
}
