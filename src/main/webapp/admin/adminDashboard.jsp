<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%
    User admin = (User) session.getAttribute("admin");
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/admin/login");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("allUsers");
    Integer totalUsers = (Integer) request.getAttribute("totalUsers");
    Integer totalAdmins = (Integer) request.getAttribute("totalAdmins");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Event Ticket Booking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { background: #f1f5f9; }
        .panel { border: 0; border-radius: 14px; box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08); }
        .hero {
            background: linear-gradient(135deg, #0f172a 0%, #1d4ed8 100%);
            color: #fff;
            border-radius: 16px;
        }
        .btn-xs { padding: 4px 10px; font-size: 12px; }
    </style>
</head>
<body>
<div class="container py-4 py-lg-5">
    <div class="hero p-4 p-lg-5 mb-4">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h2 class="fw-bold mb-2">Admin Dashboard</h2>
                <p class="mb-0">Welcome, <strong><%= admin.getFullName() %></strong>. Manage platform operations from here.</p>
            </div>
            <a href="<%= request.getContextPath() %>/admin/logout" class="btn btn-light" onclick="return confirm('Are you sure you want to logout?');">
                <i class="fas fa-right-from-bracket me-1"></i>Logout
            </a>
        </div>
    </div>

    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("success") %></div>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card panel p-4 h-100">
                <div class="text-muted">Total Users</div>
                <div class="display-6 fw-bold"><%= totalUsers == null ? 0 : totalUsers %></div>
                <div class="small text-secondary">All registered users</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card panel p-4 h-100">
                <div class="text-muted">Admins</div>
                <div class="display-6 fw-bold"><%= totalAdmins == null ? 0 : totalAdmins %></div>
                <div class="small text-secondary">Users with admin access</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card panel p-4 h-100">
                <div class="text-muted">User Management</div>
                <div class="display-6 fw-bold"><i class="fas fa-users"></i></div>
                <div class="small text-secondary">Promote, demote, and delete users</div>
            </div>
        </div>
    </div>

    <div class="card panel p-4 mt-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-bold mb-0">Registered Users</h5>
            <span class="text-muted small">Manage roles and accounts</span>
        </div>

        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                <tr>
                        <td>Role</td>
                        <td>Created</td>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Created</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% if (users != null && !users.isEmpty()) { %>
                    <% for (User u : users) { %>
                    <tr>
                        <td>
                            <span class="badge <%= "ADMIN".equalsIgnoreCase(u.getUserRole()) ? "bg-dark" : "bg-primary" %>">
                                <%= u.getUserRole() %>
                            </span>
                        </td>
                        <td><%= u.getUserId() %></td>
                        <td><%= u.getFullName() %></td>
                        <td><%= u.getEmail() %></td>
                                <% if (!"ADMIN".equalsIgnoreCase(u.getUserRole())) { %>
                        <td><%= u.getPhoneNumber() %></td>
                        <td><%= new java.util.Date(u.getCreatedAt()) %></td>
                        <td>
                            <div class="d-flex gap-2 flex-wrap">
                                <form action="<%= request.getContextPath() %>/admin/dashboard" method="post" class="m-0">
                                <% } else if (u.getUserId() != admin.getUserId()) { %>
                                <form action="<%= request.getContextPath() %>/admin/dashboard" method="post" class="m-0">
                                    <input type="hidden" name="action" value="makeUser">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <button type="submit" class="btn btn-warning btn-xs" onclick="return confirm('Demote this admin to USER?');">Make User</button>
                                </form>
                                <% } %>

                                <% if (u.getUserId() != admin.getUserId()) { %>
                                    <input type="hidden" name="action" value="makeAdmin">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <button type="submit" class="btn btn-success btn-xs" onclick="return confirm('Promote this user to ADMIN?');">Make Admin</button>
                                </form>
                                <form action="<%= request.getContextPath() %>/admin/dashboard" method="post" class="m-0">
                                <% } %>
                                    <input type="hidden" name="action" value="deleteUser">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <button type="submit" class="btn btn-danger btn-xs" onclick="return confirm('Delete this user permanently?');">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                <% } else { %>
                <tr>
                    <td colspan="7" class="text-center text-muted py-4">No user records available.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
