<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Review Dashboard – EventBook</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/review-styles.css">
</head>
<body>

<nav class="nav">
    <a class="nav-brand" href="#">🎟 EventBook</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=myReviews">My Reviews</a>
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=moderate">Admin Panel</a>
    </div>
</nav>

<div class="container">

    <div class="page-header">
        <h1>Review & Rating Dashboard</h1>
        <p>Overview of all event feedback</p>
    </div>

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-value">${allReviews.size()}</div>
            <div class="stat-label">Total Reviews</div>
        </div>
        <div class="stat-card">
            <div class="stat-value" style="color:var(--green)">
                <c:set var="approved" value="0"/>
                <c:forEach var="r" items="${allReviews}">
                    <c:if test="${r.status == 'APPROVED'}">
                        <c:set var="approved" value="${approved+1}"/>
                    </c:if>
                </c:forEach>
                ${approved}
            </div>
            <div class="stat-label">Approved</div>
        </div>
        <div class="stat-card">
            <div class="stat-value" style="color:var(--accent)">
                <c:set var="verified" value="0"/>
                <c:forEach var="r" items="${allReviews}">
                    <c:if test="${r.reviewType == 'VERIFIED'}">
                        <c:set var="verified" value="${verified+1}"/>
                    </c:if>
                </c:forEach>
                ${verified}
            </div>
            <div class="stat-label">Verified</div>
        </div>
    </div>

    <!-- Quick actions -->
    <div class="flex gap-2 mb-1">
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=moderate" class="btn btn-primary">
            Go to Moderation Panel →
        </a>
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=myReviews" class="btn btn-ghost">
            View My Reviews
        </a>
    </div>

    <!-- Recent reviews -->
    <h2 style="font-family:'Syne',sans-serif; font-size:1.2rem; margin:2rem 0 1rem;">Recent Reviews</h2>

    <c:forEach var="review" items="${allReviews}" begin="0" end="4">
        <div class="review-card">
            <div class="review-header">
                <div>
                    <strong>${review.username}</strong> on <em>${review.eventName}</em>
                    <span class="badge badge-${review.status.toLowerCase()}" style="margin-left:0.5rem;">${review.status}</span>
                </div>
                <span class="review-date">${review.reviewDate}</span>
            </div>
            <div class="stars">${review.starDisplay}</div>
            <p class="review-comment">${review.comment}</p>
        </div>
    </c:forEach>

    <c:if test="${empty allReviews}">
        <div class="empty-state">
            <div class="icon">🌟</div>
            <p>No reviews submitted yet.</p>
        </div>
    </c:if>

</div>
</body>
</html>
