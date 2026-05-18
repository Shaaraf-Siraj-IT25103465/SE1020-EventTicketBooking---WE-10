package servlet;

import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin")
public class AdminEntryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User admin = session == null ? null : (User) session.getAttribute("admin");

        if (admin != null && "ADMIN".equalsIgnoreCase(admin.getUserRole())) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        res.sendRedirect(req.getContextPath() + "/admin/login");
    }
}
