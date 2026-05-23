<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Reviews</title>
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

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success">${sessionScope.message}</div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="page-header">
        <h1>My Reviews</h1>
        <p>All reviews you have submitted</p>
    </div>

    <c:choose>
        <c:when test="${empty myReviews}">
            <div class="empty-state">
                <div class="icon">📝</div>
                <p>You haven't submitted any reviews yet.</p>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="review" items="${myReviews}">
                <div class="review-card">
                    <div class="review-header">
                        <div>
                            <strong>${review.eventName}</strong>
                            <span class="badge badge-${review.status.toLowerCase()}" style="margin-left:0.5rem;">
                                ${review.status}
                            </span>
                            <span class="badge badge-${review.reviewType.toLowerCase()}" style="margin-left:0.4rem;">
                                ${review.reviewType}
                            </span>
                        </div>
                        <span class="review-date">${review.reviewDate}</span>
                    </div>
                    <div class="stars">${review.starDisplay}</div>
                    <p class="review-comment">${review.comment}</p>
                    <div class="flex gap-1 mt-2">
                        <!-- Edit only if PENDING or APPROVED -->
                        <c:if test="${review.status != 'REJECTED'}">
                            <a href="${pageContext.request.contextPath}/ReviewServlet?action=editForm&reviewId=${review.reviewId}"
                               class="btn btn-ghost btn-sm">✏ Edit</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/ReviewServlet?action=delete&reviewId=${review.reviewId}&return=ReviewServlet%3Faction%3DmyReviews"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Delete this review?')">🗑 Delete</a>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

</div>
</body>
</html>
