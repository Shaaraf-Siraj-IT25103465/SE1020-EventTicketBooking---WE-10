<%@ include file="partials/userDashboardHeader.jsp" %>
 
 <!-- Main Content -->
        <main class="col-lg-10 col-12 p-4">
            <!-- Top Bar -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1">Welcome back<% if (user != null) { %>, <%= user.getFirstName() %><% } %>!</h2>
                    <p class="text-muted mb-0">Here is a quick snapshot of your account</p>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <button class="btn btn-light rounded-pill px-3">
                        <i class="fas fa-bell"></i>
                    </button>
                    <a class="btn btn-gradient" href="<%= request.getContextPath() %>/">
                        <i class="fas fa-plus me-2"></i>New Booking
                    </a>
                </div>
            </div>

            <!-- Stats -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="card card-modern p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted">Active Bookings</div>
                                <div class="fs-3 fw-bold"><%= activeBookings %></div>
                            </div>
                            <div class="stat-icon" style="background:#667eea;">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-modern p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted">Upcoming Stays</div>
                                <div class="fs-3 fw-bold"><%= upcomingStays %></div>
                            </div>
                            <div class="stat-icon" style="background:#764ba2;">
                                <i class="fas fa-bed"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-modern p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted">Reward Points</div>
                                <div class="fs-3 fw-bold"><%= rewardPoints %></div>
                            </div>
                            <div class="stat-icon" style="background:#f59e0b;">
                                <i class="fas fa-gift"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-modern p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted">Membership</div>
                                <div class="fs-3 fw-bold"><%= membershipLevel %></div>
                            </div>
                            <div class="stat-icon" style="background:#10b981;">
                                <i class="fas fa-crown"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Content Row -->
            <div class="row g-4">
                <!-- Recent Bookings -->
                <div class="col-lg-8">
                    <div class="card card-modern p-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0">Recent Bookings</h5>
                            <a href="#" class="text-decoration-none">View all</a>
                        </div>
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Room</th>
                                    <th>Check-In</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                    if (recentBookings != null && !recentBookings.isEmpty()) {
                                        for (Object item : recentBookings) {
                                            String bookingId = null;
                                            String roomName = null;
                                            String checkIn = null;
                                            String status = null;

                                            if (item instanceof Map) {
                                                Map<?, ?> map = (Map<?, ?>) item;
                                                bookingId = safeValue(map.get("id"), "—");
                                                roomName = safeValue(map.get("room"), "—");
                                                checkIn = safeValue(map.get("checkIn"), "—");
                                                status = safeValue(map.get("status"), "Unknown");
                                            } else {
                                                bookingId = tryGetter(item, "getId");
                                                if (bookingId == null) bookingId = tryGetter(item, "getBookingId");

                                                roomName = tryGetter(item, "getRoomName");
                                                if (roomName == null) roomName = tryGetter(item, "getRoom");

                                                checkIn = tryGetter(item, "getCheckInDate");
                                                if (checkIn == null) checkIn = tryGetter(item, "getCheckIn");

                                                status = tryGetter(item, "getStatus");

                                                bookingId = bookingId != null ? bookingId : "—";
                                                roomName = roomName != null ? roomName : "—";
                                                checkIn = checkIn != null ? checkIn : "—";
                                                status = status != null ? status : "Unknown";
                                            }
                                %>
                                <tr>
                                    <td><%= bookingId %></td>
                                    <td><%= roomName %></td>
                                    <td><%= checkIn %></td>
                                    <td><span class="status-pill <%= statusClass(status) %>"><%= status %></span></td>
                                    <td><button class="btn btn-sm btn-outline-secondary">Details</button></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">No bookings yet.</td>
                                </tr>
                                <%
                                    }
                                %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="col-lg-4">
                    <div class="card card-modern p-4 mb-4">
                        <h5 class="fw-bold mb-3">Quick Actions</h5>
                        <div class="d-grid gap-2">
                            <a class="btn btn-gradient" href="<%= request.getContextPath() %>/"><i class="fas fa-calendar-plus me-2"></i>New Reservation</a>
                            <button class="btn btn-light"><i class="fas fa-credit-card me-2"></i>Pay Invoice</button>
                            <a class="btn btn-light" href="<%= request.getContextPath() %>/user/profile"><i class="fas fa-user-edit me-2"></i>Edit Profile</a>
                        </div>
                    </div>

                    <div class="card card-modern p-4">
                        <h5 class="fw-bold mb-3">Support</h5>
                        <p class="text-muted mb-3">Need help? Our team is available 24/7.</p>
                        <button class="btn btn-outline-secondary w-100"><i class="fas fa-headset me-2"></i>Contact Support</button>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>


<%@ include file="partials/userDashboardFooter.jsp" %>