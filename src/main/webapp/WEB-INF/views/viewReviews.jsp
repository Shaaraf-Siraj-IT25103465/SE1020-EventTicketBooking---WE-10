<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reviews – ${eventName}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/review-styles.css">
</head>
<body>

<nav class="nav">
    <a class="nav-brand" href="#">🎟 EventBook</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=myReviews">My Reviews</a>
    </div>
</nav>

<div class="container">

    <!-- ── Alert ── -->
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success">${sessionScope.message}</div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="page-header">
        <h1>Reviews for <span style="color:var(--accent)">${eventName}</span></h1>
        <p>What attendees are saying</p>
    </div>

    <!-- ── Average Rating ── -->
    <div class="avg-rating">
        <div>
            <div class="avg-number">${avgRating}</div>
        </div>
        <div>
            <div class="avg-stars">★★★★★</div>
            <div class="avg-count">${reviews.size()} review(s) total</div>
        </div>
        <div style="margin-left:auto;">
            <a href="${pageContext.request.contextPath}/ReviewServlet?action=submitForm&eventId=${eventId}&eventName=${eventName}"
               class="btn btn-primary">✍ Write a Review</a>
        </div>
    </div>

    <!-- ── Review List ── -->
    <c:choose>
        <c:when test="${empty reviews}">
            <div class="empty-state">
                <div class="icon">💬</div>
                <p>No reviews yet. Be the first to share your experience!</p>
                <a href="${pageContext.request.contextPath}/ReviewServlet?action=submitForm&eventId=${eventId}&eventName=${eventName}"
                   class="btn btn-primary mt-2">Write First Review</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="review" items="${reviews}">
                <c:if test="${review.status == 'APPROVED'}">
                    <div class="review-card">
                        <div class="review-header">
                            <div>
                                <span class="review-user">${review.username}</span>
                                <span class="badge badge-${review.reviewType.toLowerCase()} mt-1" style="margin-left:0.5rem;">
                                    <c:choose>
                                        <c:when test="${review.reviewType == 'VERIFIED'}">✓ Verified Purchase</c:when>
                                        <c:otherwise>Public</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <span class="review-date">${review.reviewDate}</span>
                        </div>
                        <div class="stars">${review.starDisplay}</div>
                        <p class="review-comment">${review.comment}</p>
                    </div>
                </c:if>
            </c:forEach>
        </c:otherwise>
    </c:choose>

</div>
</body>
</html>
