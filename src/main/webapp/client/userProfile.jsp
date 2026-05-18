<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile | Event Ticket Booking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background: linear-gradient(145deg, #f8fafc 0%, #e2e8f0 100%);
            min-height: 100vh;
        }

        .profile-card {
            border: 0;
            border-radius: 16px;
            box-shadow: 0 14px 32px rgba(15, 23, 42, 0.08);
        }

        .btn-accent {
            background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
            border: 0;
            color: #fff;
        }

        .btn-accent:hover { color: #fff; opacity: 0.95; }
    </style>
</head>
<body>
<div class="container py-4 py-lg-5">
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-4">
        <h2 class="fw-bold mb-0"><i class="fas fa-user-circle me-2"></i>Profile Settings</h2>
        <a href="<%= request.getContextPath() %>/client/dashboard.jsp" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
        </a>
    </div>

    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("success") %></div>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="row g-4">
        <div class="col-lg-7">
            <div class="card profile-card p-4">
                <h5 class="fw-bold mb-3">Update Profile</h5>
                <form method="post" action="<%= request.getContextPath() %>/user/profile">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">First Name</label>
                            <input type="text" name="firstName" class="form-control" value="<%= user.getFirstName() %>" pattern="[A-Za-z ]{2,50}" title="Use only letters and spaces (2-50 characters)" maxlength="50" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Last Name</label>
                            <input type="text" name="lastName" class="form-control" value="<%= user.getLastName() %>" pattern="[A-Za-z ]{2,50}" title="Use only letters and spaces (2-50 characters)" maxlength="50" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" value="<%= user.getEmail() %>" maxlength="120" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phone Number</label>
                            <input type="text" name="phoneNumber" class="form-control" value="<%= user.getPhoneNumber() %>" pattern="[0-9+()\-\s]{7,20}" title="Use 7-20 characters. Allowed: digits, +, -, spaces, parentheses" maxlength="20" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-accent mt-4 px-4">
                        <i class="fas fa-floppy-disk me-1"></i>Save Profile
                    </button>
                </form>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="card profile-card p-4">
                <h5 class="fw-bold mb-3">Change Password</h5>
                <form method="post" action="<%= request.getContextPath() %>/user/profile">
                    <input type="hidden" name="action" value="changePassword">

                    <div class="mb-3">
                        <label class="form-label">Current Password</label>
                        <input type="password" name="currentPassword" class="form-control" minlength="6" maxlength="120" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" class="form-control" pattern="(?=.*[A-Za-z])(?=.*\d).{6,}" title="At least 6 characters with letters and numbers" maxlength="120" required minlength="6">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Confirm New Password</label>
                        <input type="password" id="confirmNewPassword" name="confirmNewPassword" class="form-control" required minlength="6">
                    </div>

                    <button type="submit" class="btn btn-dark px-4">
                        <i class="fas fa-key me-1"></i>Update Password
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const newPassword = document.getElementById('newPassword');
    const confirmNewPassword = document.getElementById('confirmNewPassword');

    if (confirmNewPassword && newPassword) {
        confirmNewPassword.addEventListener('input', function () {
            if (confirmNewPassword.value !== newPassword.value) {
                confirmNewPassword.setCustomValidity('Passwords do not match');
            } else {
                confirmNewPassword.setCustomValidity('');
            }
        });
    }
</script>
</body>
</html>
