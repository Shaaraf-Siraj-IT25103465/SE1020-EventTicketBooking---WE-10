<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up | Event Ticket Booking</title>

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

        .register-container {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 20px 60px rgba(15, 23, 42, 0.3);
            overflow: hidden;
            max-width: 1100px;
            width: 100%;
        }

        .register-left {
            background: linear-gradient(140deg, #0f172a 0%, #1d4ed8 70%, #06b6d4 100%);
            padding: 48px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .register-right {
            padding: 42px;
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

        .btn-register {
            background: linear-gradient(135deg, #06b6d4 0%, #2563eb 100%);
            border: none;
            border-radius: 12px;
            padding: 12px;
            font-weight: 600;
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);
        }

        .btn-register:hover {
            box-shadow: 0 10px 24px rgba(37, 99, 235, 0.45);
        }

        .alert-custom {
            border-radius: 12px;
            border: none;
        }

        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: 1.2rem;
            padding: 0.9rem;
            background: rgba(255, 255, 255, 0.12);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.14);
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
            font-size: 2.5rem;
        }

        .password-strength {
            height: 6px;
            border-radius: 6px;
            margin-top: 5px;
            transition: all 0.3s ease;
        }

        @media (max-width: 768px) {
            .register-right { padding: 30px 24px; }
        }
    </style>
</head>
<body>

<div class="register-container">
    <div class="row g-0">
        <div class="col-lg-5 d-none d-lg-block">
            <div class="register-left h-100">
                <div class="mb-4">
                    <span class="tag-pill mb-3">EventHub</span>
                    <h2 class="fw-bold mb-3">Create Your Account</h2>
                    <p class="mb-0 text-white-50">Join now and manage all your ticket bookings in one place.</p>
                </div>
                <div class="mt-4">
                    <div class="feature-item">
                        <i class="fas fa-ticket-alt fs-4 me-3"></i>
                        <div>
                            <h6 class="mb-1 fw-bold">Fast Ticket Access</h6>
                            <small>Book events in a few clicks</small>
                        </div>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-shield-halved fs-4 me-3"></i>
                        <div>
                            <h6 class="mb-1 fw-bold">Secure Profile</h6>
                            <small>Update account details anytime</small>
                        </div>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-bell fs-4 me-3"></i>
                        <div>
                            <h6 class="mb-1 fw-bold">Booking Updates</h6>
                            <small>Stay informed about your events</small>
                        </div>
                    </div>
                </div>
                <div class="mt-auto pt-3">
                    <i class="fas fa-wave-square feature-icon"></i>
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <div class="register-right">
                <div class="text-center mb-4">
                    <a href="<%= request.getContextPath() %>/" class="text-decoration-none">
                        <h3 class="fw-bold text-dark mb-2"><i class="fas fa-ticket-alt me-2 text-primary"></i>EventHub</h3>
                    </a>
                    <h4 class="mb-2">Create Account</h4>
                    <p class="text-muted">Fill in your details to get started</p>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-custom d-flex align-items-center mb-4" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <div><%= request.getAttribute("error") %></div>
                </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/user/register" method="post" id="registerForm">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">First Name</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" name="firstName" class="form-control" placeholder="John" pattern="[A-Za-z ]{2,50}" title="Use only letters and spaces (2-50 characters)" maxlength="50" required autofocus>
                            </div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Last Name</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" name="lastName" class="form-control" placeholder="Doe" pattern="[A-Za-z ]{2,50}" title="Use only letters and spaces (2-50 characters)" maxlength="50" required>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                            <input type="email" name="email" class="form-control" placeholder="john.doe@example.com" maxlength="120" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Phone Number</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-phone"></i></span>
                            <input type="tel" name="phoneNumber" class="form-control" placeholder="+94 77 123 4567" pattern="[0-9+()\-\s]{7,20}" title="Use 7-20 characters. Allowed: digits, +, -, spaces, parentheses" maxlength="20" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <input type="password" name="password" id="password" class="form-control" placeholder="Create a strong password" pattern="(?=.*[A-Za-z])(?=.*\d).{6,}" title="At least 6 characters with letters and numbers" maxlength="120" required minlength="6">
                        </div>
                        <div class="password-strength bg-secondary" id="passwordStrength"></div>
                        <small class="text-muted">Password must be at least 6 characters</small>
                    </div>

                    <div class="form-check mb-4">
                        <input class="form-check-input" type="checkbox" id="terms" required>
                        <label class="form-check-label" for="terms">
                            I agree to the <a href="#" class="text-primary">Terms & Conditions</a> and <a href="#" class="text-primary">Privacy Policy</a>
                        </label>
                    </div>

                    <button type="submit" class="btn btn-register btn-primary w-100 text-white mb-4">
                        <i class="fas fa-user-plus me-2"></i>Create Account
                    </button>
                </form>

                <div class="text-center">
                    <p class="text-muted mb-2">Already have an account?</p>
                    <a href="<%= request.getContextPath() %>/user/login" class="fw-bold text-decoration-none text-primary">
                        <i class="fas fa-sign-in-alt me-1"></i>Sign In
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const passwordInput = document.getElementById('password');
    const strengthBar = document.getElementById('passwordStrength');
    
    passwordInput.addEventListener('input', function() {
        const password = this.value;
        let strength = 0;
        
        if (password.length >= 6) strength += 25;
        if (password.length >= 10) strength += 25;
        if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength += 25;
        if (/[0-9]/.test(password)) strength += 15;
        if (/[^a-zA-Z0-9]/.test(password)) strength += 10;
        
        strengthBar.style.width = strength + '%';
        
        if (strength < 40) {
            strengthBar.style.backgroundColor = '#dc3545';
        } else if (strength < 70) {
            strengthBar.style.backgroundColor = '#ffc107';
        } else {
            strengthBar.style.backgroundColor = '#28a745';
        }
    });
</script>

</body>
</html>
