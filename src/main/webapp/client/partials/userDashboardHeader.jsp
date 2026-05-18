<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%!
    private String safeValue(Object value, String fallback) {
        return value == null ? fallback : String.valueOf(value);
    }

    private String tryGetter(Object obj, String methodName) {
        if (obj == null) return null;
        try {
            Object value = obj.getClass().getMethod(methodName).invoke(obj);
            return value == null ? null : String.valueOf(value);
        } catch (Exception ignored) {
            return null;
        }
    }

    private String statusClass(String status) {
        if (status == null) return "status-pending";

        String s = status.trim().toLowerCase();
        if ("confirmed".equals(s) || "active".equals(s)) return "status-confirmed";
        if ("pending".equals(s)) return "status-pending";
        if ("cancelled".equals(s) || "canceled".equals(s)) return "status-cancelled";
        return "status-pending";
    }
%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login");
        return;
    }

    int activeBookings = 0;
    int upcomingStays = 0;
    int rewardPoints = 0;
    String membershipLevel = "Starter";
    List<Object> recentBookings = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard | Event Ticket Booking</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            background: linear-gradient(145deg, #f8fafc 0%, #eef2ff 100%);
            min-height: 100vh;
        }

        .sidebar {
            min-height: 100vh;
            background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
            color: #fff;
        }

        .sidebar .nav-link {
            color: #cbd5e1;
            border-radius: 10px;
            margin-bottom: 6px;
            padding: 10px 14px;
        }

        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255, 255, 255, 0.14);
            color: #fff;
        }

        .card-modern {
            border: 0;
            border-radius: 14px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
        }

        .stat-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            color: #fff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-gradient {
            background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
            border: 0;
            color: #fff;
        }

        .btn-gradient:hover {
            color: #fff;
            opacity: 0.95;
        }

        .status-pill {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-confirmed { background: #dcfce7; color: #166534; }
        .status-pending { background: #fef9c3; color: #854d0e; }
        .status-cancelled { background: #fee2e2; color: #991b1b; }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <aside class="col-lg-2 col-md-3 sidebar p-3">
            <h5 class="fw-bold mb-4"><i class="fas fa-ticket-alt me-2"></i>EventHub</h5>
            <div class="small text-light-emphasis mb-3">Hello, <strong><%= user.getFirstName() %></strong></div>

            <nav class="nav flex-column">
                <a class="nav-link active" href="<%= request.getContextPath() %>/client/dashboard.jsp">
                    <i class="fas fa-gauge me-2"></i>Dashboard
                </a>
                <a class="nav-link" href="<%= request.getContextPath() %>/user/profile">
                    <i class="fas fa-user me-2"></i>Profile
                </a>
                <a class="nav-link" href="<%= request.getContextPath() %>/">
                    <i class="fas fa-calendar-days me-2"></i>Browse Events
                </a>
                <a class="nav-link" href="<%= request.getContextPath() %>/user/logout" onclick="return confirm('Are you sure you want to logout?');">
                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                </a>
            </nav>
        </aside>
