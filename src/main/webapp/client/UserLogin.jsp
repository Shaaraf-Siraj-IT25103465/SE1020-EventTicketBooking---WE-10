<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | Event Ticket Booking</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">

    <style>
        * { font-family: 'Outfit', sans-serif; }

        body {
            background: radial-gradient(circle at 20% 20%, #0ea5e9 0%, #1d4ed8 35%, #0f172a 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .login-container {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 20px 60px rgba(15, 23, 42, 0.3);
            overflow: hidden;
            max-width: 1000px;
            width: 100%;
        }

        .login-left {
            background: linear-gradient(140deg, #0f172a 0%, #1d4ed8 70%, #06b6d4 100%);
            padding: 48px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-right {
            padding: 48px;
        }

        .form-control {
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            padding: 12px 14px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.18);
        }

        .input-group-text {
            background: #f8fafc;
            border: 1px solid #cbd5e1;
            border-right: none;
            border-radius: 12px 0 0 12px;
            color: #1d4ed8;
        }

        .input-group .form-control {
            border-left: none;
            border-radius: 0 12px 12px 0;
        }

        .input-group:focus-within .input-group-text {
            border-color: #2563eb;
        }

        .btn-login {
            background: linear-gradient(135deg, #06b6d4 0%, #2563eb 100%);
            border: none;
            border-radius: 12px;
            padding: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);
        }

        .btn-login:hover {
            box-shadow: 0 10px 24px rgba(37, 99, 235, 0.45);
        }

        .alert-custom {
            border-radius: 12px;
            border: none;
        }

        .tag-pill {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.35);
            font-size: 12px;
        }

        .feature-icon {
            font-size: 2.6rem;
        }

        @media (max-width: 768px) {
            .login-right { padding: 30px 24px; }
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="row g-0">
        <div class="col-lg-5 d-none d-lg-block">
            <div class="login-left h-100">
                <div class="mb-4">
                    <span class="tag-pill mb-3">EventHub</span>
                    <h2 class="fw-bold mb-3">Welcome Back</h2>
                    <p class="mb-0 text-white-50">Sign in to continue managing your event bookings and profile.</p>
                </div>
                <div class="mt-4">
                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-ticket-alt me-3"></i>
                        <span>Track ticket activity</span>
                    </div>
                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-user-shield me-3"></i>
                        <span>Secure account session</span>
                    </div>
                    <div class="d-flex align-items-center">
                        <i class="fas fa-calendar-check me-3"></i>
                        <span>Instant booking updates</span>
                    </div>
                </div>
                <div class="mt-auto pt-4">
                    <i class="fas fa-wave-square feature-icon"></i>
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <div class="login-right">
                <div class="text-center mb-5">
                    <a href="<%= request.getContextPath() %>/" class="text-decoration-none">
                        <h3 class="fw-bold text-dark mb-2"><i class="fas fa-ticket-alt me-2 text-primary"></i>EventHub</h3>
                    </a>
                    <h4 class="mb-2">Sign In</h4>
                    <p class="text-muted mb-0">Use your email and password to continue</p>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-custom d-flex align-items-center" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <div><%= request.getAttribute("error") %></div>
                </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/user/login" method="post">
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                            <input type="email" name="email" class="form-control" placeholder="you@example.com" maxlength="120" required autofocus>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <input type="password" name="password" class="form-control" placeholder="Enter your password" minlength="6" maxlength="120" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-login btn-primary w-100 text-white mb-4">
                        <i class="fas fa-sign-in-alt me-2"></i>Sign In
                    </button>
                </form>

                <div class="text-center">
                    <p class="text-muted mb-2">Don't have an account?</p>
                    <a href="<%= request.getContextPath() %>/user/register" class="fw-bold text-decoration-none text-primary">
                        <i class="fas fa-user-plus me-1"></i>Create an Account
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
