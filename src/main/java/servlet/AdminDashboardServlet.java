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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        List<User> users = userService.getAllUsers();
        List<User> nonAdminUsers = new ArrayList<>();
        int totalAdmins = 0;

        for (User user : users) {
            if ("ADMIN".equalsIgnoreCase(user.getUserRole())) {
                totalAdmins++;
            } else {
                nonAdminUsers.add(user);
            }
        }

        req.setAttribute("allUsers", users);
        req.setAttribute("users", nonAdminUsers);
        req.setAttribute("totalUsers", users.size());
        req.setAttribute("totalAdmins", totalAdmins);

        HttpSession session = req.getSession(false);
        if (session != null) {
            Object success = session.getAttribute("flashSuccess");
            Object error = session.getAttribute("flashError");
            if (success != null) req.setAttribute("success", String.valueOf(success));
            if (error != null) req.setAttribute("error", String.valueOf(error));
            session.removeAttribute("flashSuccess");
            session.removeAttribute("flashError");
        }

        req.getRequestDispatcher("/admin/adminDashboard.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User currentAdmin = session == null ? null : (User) session.getAttribute("admin");

        if (currentAdmin == null || !"ADMIN".equalsIgnoreCase(currentAdmin.getUserRole())) {
            res.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        String action = req.getParameter("action");
        String userIdRaw = req.getParameter("userId");

        try {
            int userId = Integer.parseInt(userIdRaw);

            if (currentAdmin.getUserId() == userId) {
                throw new IllegalArgumentException("You cannot modify your own admin account from this action");
            }

            if ("makeAdmin".equals(action)) {
                userService.updateUserRole(userId, "ADMIN");
                session.setAttribute("flashSuccess", "User promoted to ADMIN successfully");
            } else if ("makeUser".equals(action)) {
                userService.updateUserRole(userId, "USER");
                session.setAttribute("flashSuccess", "User role changed to USER successfully");
            } else if ("deleteUser".equals(action)) {
                userService.deleteUser(userId);
                session.setAttribute("flashSuccess", "User deleted successfully");
            } else {
                session.setAttribute("flashError", "Invalid action");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Invalid user id");
        } catch (IllegalArgumentException e) {
            session.setAttribute("flashError", e.getMessage());
        }

        res.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
