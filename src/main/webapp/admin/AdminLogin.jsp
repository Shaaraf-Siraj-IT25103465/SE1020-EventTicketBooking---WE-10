<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | EventHub</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        * {
            font-family: 'Poppins', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.4);
            overflow: hidden;
            max-width: 1000px;
            width: 100%;
        }
        
        .login-left {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            padding: 60px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .login-right {
            padding: 60px;
        }
        
        .form-control {
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 12px 20px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #1e293b;
            box-shadow: 0 0 0 0.2rem rgba(30, 41, 59, 0.25);
        }
        
        .input-group-text {
            background: transparent;
            border: 2px solid #e0e0e0;
            border-right: none;
            border-radius: 10px 0 0 10px;
            color: #1e293b;
        }
        
        .input-group .form-control {
            border-left: none;
            border-radius: 0 10px 10px 0;
        }
        
        .input-group:focus-within .input-group-text {
            border-color: #1e293b;
        }
        
        .btn-login {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(30, 41, 59, 0.4);
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(30, 41, 59, 0.6);
        }
        
        .alert-custom {
            border-radius: 10px;
            border: none;
            animation: slideDown 0.4s ease-out;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .feature-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        
        .admin-badge {
            display: inline-block;
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
            padding: 4px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        @media (max-width: 768px) {
            .login-left {
                padding: 40px;
            }
            .login-right {
                padding: 40px;
            }
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="row g-0">
        <!-- Left Side - Info -->
        <div class="col-lg-5 d-none d-lg-block">
            <div class="login-left h-100">
                <div class="text-center mb-5">
                    <div class="admin-badge">
                        <i class="fas fa-shield-alt me-1"></i>ADMIN PANEL
                    </div>
                    <i class="fas fa-crown feature-icon"></i>
                    <h2 class="fw-bold mb-3">Admin Access</h2>
                    <p class="mb-4">Manage events, users, and bookings from a centralized dashboard</p>
                </div>
                <div class="mt-auto">
                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-check-circle me-3 fs-5"></i>
                        <span>Full control panel</span>
                    </div>
                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-check-circle me-3 fs-5"></i>
                        <span>User & booking management</span>
                    </div>
                    <div class="d-flex align-items-center">
                        <i class="fas fa-check-circle me-3 fs-5"></i>
                        <span>Real-time analytics</span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Right Side - Form -->
        <div class="col-lg-7">
            <div class="login-right">
                <!-- Header -->
                <div class="text-center mb-5">
                    <a href="<%= request.getContextPath() %>/" class="text-decoration-none">
                        <h3 class="fw-bold text-dark mb-2">
                            <i class="fas fa-ticket-alt me-2" style="color: #1e293b;"></i>EventHub
                        </h3>
                    </a>
                    <h4 class="mb-2">Admin Sign In</h4>
                    <p class="text-muted">Enter your admin credentials to access the control panel</p>
                </div>
                
                <!-- Error Alert -->
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-custom d-flex align-items-center" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <div><%= request.getAttribute("error") %></div>
                </div>
                <% } %>
                
                <!-- Login Form -->
                <form action="<%= request.getContextPath() %>/admin/login" method="post">
                    <!-- Email Input -->
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Admin Email</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-envelope"></i>
                            </span>
                            <input type="email" 
                                   name="email" 
                                   class="form-control" 
                                placeholder="Enter admin email"
                                maxlength="120"
                                   required 
                                   autofocus>
                        </div>
                    </div>
                    
                    <!-- Password Input -->
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-lock"></i>
                            </span>
                            <input type="password" 
                                   name="password" 
                                   class="form-control" 
                                   placeholder="Enter password" 
                                minlength="6"
                                maxlength="120"
                                   required>
                        </div>
                    </div>
                    
                    <!-- Remember Me -->
                    <div class="mb-4">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="rememberMe">
                            <label class="form-check-label" for="rememberMe">
                                Remember me on this device
                            </label>
                        </div>
                    </div>
                    
                    <!-- Login Button -->
                    <button type="submit" class="btn btn-login btn-primary w-100 text-white mb-4">
                        <i class="fas fa-sign-in-alt me-2"></i>Sign In to Admin Panel
                    </button>
                </form>
                
                <!-- Back to Home -->
                <div class="text-center">
                    <p class="text-muted mb-2">Not an admin?</p>
                    <a href="<%= request.getContextPath() %>/" 
                       class="fw-bold text-decoration-none" 
                       style="color: #1e293b;">
                        <i class="fas fa-arrow-left me-1"></i>Back to Home
                    </a>
                </div>
                
                <!-- Info Box -->
                <div class="alert alert-info mt-4" style="background: #dbeafe; border: 1px solid #93c5fd; border-radius: 10px;">
                    <small class="text-secondary">
                        <i class="fas fa-info-circle me-2"></i>
                        This is a restricted area for administrators only. Unauthorized access attempts are monitored.
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
