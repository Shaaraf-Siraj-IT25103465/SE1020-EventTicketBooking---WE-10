<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Review – Event Ticket Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/review-styles.css">
</head>
<body>

<!-- ── Navigation ─────────────────────────────────────────── -->
<nav class="nav">
    <a class="nav-brand" href="#">🎟 EventBook</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=myReviews">My Reviews</a>
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=moderate">Admin</a>
    </div>
</nav>

<div class="container">

    <!-- ── Page Header ── -->
    <div class="page-header">
        <h1>Leave a Review</h1>
        <p>Share your experience for <strong>${param.eventName}</strong></p>
    </div>

    <!-- ── Alert messages ── -->
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-info">${sessionScope.message}</div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <!-- ── Submit Review Form ── -->
    <div class="card" style="max-width: 620px;">
        <form action="${pageContext.request.contextPath}/ReviewServlet" method="POST">
            <input type="hidden" name="action"    value="submit">
            <input type="hidden" name="eventId"   value="${param.eventId}">
            <input type="hidden" name="eventName" value="${param.eventName}">

            <!-- Star Rating -->
            <div class="form-group">
                <label>Your Rating *</label>
                <div class="star-input" id="starInput">
                    <input type="radio" name="rating" id="s5" value="5"><label for="s5">★</label>
                    <input type="radio" name="rating" id="s4" value="4"><label for="s4">★</label>
                    <input type="radio" name="rating" id="s3" value="3" checked><label for="s3">★</label>
                    <input type="radio" name="rating" id="s2" value="2"><label for="s2">★</label>
                    <input type="radio" name="rating" id="s1" value="1"><label for="s1">★</label>
                </div>
            </div>

            <!-- Comment -->
            <div class="form-group">
                <label for="comment">Your Review *</label>
                <textarea class="form-control" id="comment" name="comment"
                          placeholder="Tell others what you thought about this event..."
                          maxlength="500" required></textarea>
                <div class="text-muted" style="font-size:0.78rem; margin-top:0.3rem;">
                    <span id="charCount">0</span>/500 characters
                </div>
            </div>

            <!-- Ticket ID (optional, makes it a VerifiedReview) -->
            <div class="form-group">
                <label for="ticketId">Ticket ID <span class="text-muted">(optional — verifies your purchase)</span></label>
                <input type="text" class="form-control" id="ticketId" name="ticketId"
                       placeholder="e.g. TKT-1716789123">
            </div>

            <!-- Actions -->
            <div class="flex gap-2 mt-2">
                <button type="submit" class="btn btn-primary">Submit Review</button>
                <a href="${pageContext.request.contextPath}/ReviewServlet?action=view&eventId=${param.eventId}&eventName=${param.eventName}"
                   class="btn btn-ghost">Cancel</a>
            </div>
        </form>
    </div>

</div>

<script>
    const textarea  = document.getElementById('comment');
    const charCount = document.getElementById('charCount');
    textarea.addEventListener('input', () => {
        charCount.textContent = textarea.value.length;
    });
</script>
</body>
</html>
