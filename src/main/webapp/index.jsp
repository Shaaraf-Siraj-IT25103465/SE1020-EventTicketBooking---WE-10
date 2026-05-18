<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Ticket Booking System</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --brand-dark: #0b1220;
            --brand-blue: #2563eb;
            --brand-cyan: #06b6d4;
            --brand-surface: #f8fafc;
        }

        * {
            font-family: 'Outfit', sans-serif;
        }

        body {
            background: radial-gradient(circle at top right, #e0f2fe 0%, #f8fafc 35%, #eef2ff 100%);
            color: #0f172a;
        }

        .navbar-custom {
            background: rgba(11, 18, 32, 0.92);
            backdrop-filter: blur(8px);
        }

        .hero {
            position: relative;
            min-height: 85vh;
            display: flex;
            align-items: center;
            background:
                    linear-gradient(120deg, rgba(11, 18, 32, 0.92), rgba(37, 99, 235, 0.82)),
                    url('https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=1600') center/cover;
            overflow: hidden;
        }

        .hero::after {
            content: "";
            position: absolute;
            right: -120px;
            bottom: -140px;
            width: 380px;
            height: 380px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(6, 182, 212, 0.55), rgba(6, 182, 212, 0));
        }

        .hero-content {
            position: relative;
            z-index: 2;
            color: #fff;
        }

        .hero h1 {
            font-size: clamp(2rem, 6vw, 4.2rem);
            line-height: 1.05;
            font-weight: 800;
        }

        .hero-tag {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 7px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.24);
        }

        .btn-main {
            background: linear-gradient(135deg, var(--brand-cyan) 0%, var(--brand-blue) 100%);
            border: 0;
            color: #fff;
        }

        .btn-main:hover {
            color: #fff;
            opacity: 0.95;
        }

        .event-card {
            border: 0;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 14px 34px rgba(15, 23, 42, 0.08);
            transition: transform 0.25s ease;
            background: #fff;
        }

        .event-card:hover {
            transform: translateY(-6px);
        }

        .event-cover {
            height: 190px;
            object-fit: cover;
            width: 100%;
        }

        .chip {
            display: inline-block;
            font-size: 12px;
            font-weight: 600;
            padding: 6px 10px;
            border-radius: 999px;
            background: #dbeafe;
            color: #1e3a8a;
        }

        .feature-box {
            border-radius: 16px;
            background: #fff;
            border: 1px solid #e2e8f0;
            height: 100%;
        }

        .cta {
            border-radius: 18px;
            background: linear-gradient(125deg, #0f172a, #1d4ed8 70%, #06b6d4);
            color: #fff;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/">
            <i class="fas fa-ticket-alt me-2"></i>EventHub
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav ms-auto align-items-lg-center">
                <li class="nav-item"><a class="nav-link" href="#events">Events</a></li>
                <li class="nav-item"><a class="nav-link" href="#how">How It Works</a></li>

                <% if (user == null) { %>
                <li class="nav-item ms-lg-2"><a class="nav-link" href="<%= request.getContextPath() %>/user/login">Login</a></li>
                <li class="nav-item ms-lg-2"><a class="btn btn-main rounded-pill px-4" href="<%= request.getContextPath() %>/user/register">Create Account</a></li>
                <% } else { %>
                <li class="nav-item ms-lg-2"><a class="nav-link" href="<%= request.getContextPath() %>/client/dashboard.jsp">Dashboard</a></li>
                <li class="nav-item ms-lg-2"><a class="btn btn-outline-light rounded-pill px-4" href="<%= request.getContextPath() %>/user/logout" onclick="return confirm('Are you sure you want to logout?');">Logout</a></li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<section class="hero">
    <div class="container hero-content py-5">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <span class="hero-tag mb-3"><i class="fas fa-bolt"></i> Secure, Fast, Easy Booking</span>
                <h1 class="mb-3">Book Your Next Event in Seconds.</h1>
                <p class="lead mb-4">Discover concerts, festivals, sports nights, and theatre shows. Reserve tickets with smooth login, secure profile, and quick checkout flow.</p>
                <div class="d-flex flex-wrap gap-2">
                    <% if (user == null) { %>
                    <a class="btn btn-main btn-lg rounded-pill px-4" href="<%= request.getContextPath() %>/user/register">
                        <i class="fas fa-user-plus me-1"></i>Start Booking
                    </a>
                    <a class="btn btn-outline-light btn-lg rounded-pill px-4" href="<%= request.getContextPath() %>/user/login">Login</a>
                    <% } else { %>
                    <a class="btn btn-main btn-lg rounded-pill px-4" href="<%= request.getContextPath() %>/client/dashboard.jsp">Go to Dashboard</a>
                    <a class="btn btn-outline-light btn-lg rounded-pill px-4" href="<%= request.getContextPath() %>/user/profile">Edit Profile</a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</section>

<section id="events" class="py-5">
    <div class="container py-2">
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
            <div>
                <h2 class="fw-bold mb-1">Trending Events</h2>
                <p class="text-muted mb-0">Sample showcase for your landing page</p>
            </div>
            <a class="btn btn-outline-primary rounded-pill" href="<%= request.getContextPath() %>/user/login">Book Now</a>
        </div>

        <div class="row g-4">
            <div class="col-md-6 col-lg-4">
                <div class="event-card h-100">
                    <img class="event-cover" src="https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=900" alt="Concert event">
                    <div class="p-3 p-lg-4">
                        <span class="chip">Music</span>
                        <h5 class="fw-bold mt-3">Neon Beats Live</h5>
                        <p class="text-muted mb-2"><i class="fas fa-location-dot me-2"></i>Colombo Arena</p>
                        <p class="text-muted mb-3"><i class="fas fa-calendar me-2"></i>Jun 14, 2026</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <strong>LKR 3,500</strong>
                            <a class="btn btn-sm btn-main rounded-pill px-3" href="<%= request.getContextPath() %>/user/login">Reserve</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-lg-4">
                <div class="event-card h-100">
                    <img class="event-cover" src="https://images.unsplash.com/photo-1511578314322-379afb476865?w=900" alt="Tech conference">
                    <div class="p-3 p-lg-4">
                        <span class="chip">Conference</span>
                        <h5 class="fw-bold mt-3">Future Tech Summit</h5>
                        <p class="text-muted mb-2"><i class="fas fa-location-dot me-2"></i>BMICH</p>
                        <p class="text-muted mb-3"><i class="fas fa-calendar me-2"></i>Jul 09, 2026</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <strong>LKR 6,000</strong>
                            <a class="btn btn-sm btn-main rounded-pill px-3" href="<%= request.getContextPath() %>/user/login">Reserve</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-lg-4">
                <div class="event-card h-100">
                    <img class="event-cover" src="https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=900" alt="Sports event">
                    <div class="p-3 p-lg-4">
                        <span class="chip">Sports</span>
                        <h5 class="fw-bold mt-3">City Derby Finals</h5>
                        <p class="text-muted mb-2"><i class="fas fa-location-dot me-2"></i>National Stadium</p>
                        <p class="text-muted mb-3"><i class="fas fa-calendar me-2"></i>Aug 03, 2026</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <strong>LKR 2,800</strong>
                            <a class="btn btn-sm btn-main rounded-pill px-3" href="<%= request.getContextPath() %>/user/login">Reserve</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<section id="how" class="pb-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-4">
                <div class="feature-box p-4">
                    <h5 class="fw-bold"><i class="fas fa-user-check me-2 text-primary"></i>Create Account</h5>
                    <p class="text-muted mb-0">Register in under one minute and set up your profile securely.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-box p-4">
                    <h5 class="fw-bold"><i class="fas fa-magnifying-glass me-2 text-primary"></i>Choose Event</h5>
                    <p class="text-muted mb-0">Browse upcoming events and pick your preferred seat category.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-box p-4">
                    <h5 class="fw-bold"><i class="fas fa-ticket me-2 text-primary"></i>Get Ticket</h5>
                    <p class="text-muted mb-0">Finalize booking and manage ticket details from your dashboard.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="pb-5">
    <div class="container">
        <div class="cta p-4 p-lg-5 d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h3 class="fw-bold mb-2">Ready to launch your event journey?</h3>
                <p class="mb-0">Login or register now and manage everything from profile to bookings.</p>
            </div>
            <div class="d-flex gap-2">
                <a class="btn btn-light rounded-pill px-4" href="<%= request.getContextPath() %>/user/login">Login</a>
            </div>
        </div>
    </div>
</section>

<footer class="py-4" style="background:#0b1220; color:#cbd5e1;">
    <div class="container d-flex justify-content-between flex-wrap gap-2">
        <div>Event Ticket Booking System</div>
        <div>© 2026 All rights reserved</div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
