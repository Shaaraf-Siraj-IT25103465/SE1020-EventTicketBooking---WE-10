<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Moderate Reviews – Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/review-styles.css">
</head>
<body>

<nav class="nav">
    <a class="nav-brand" href="#">🎟 EventBook</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=moderate">Moderate</a>
    </div>
</nav>

<div class="container">

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success">${sessionScope.message}</div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="page-header">
        <h1>Admin – Moderate Reviews</h1>
        <p>Approve or reject submitted reviews</p>
    </div>

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-value">${allReviews.size()}</div>
            <div class="stat-label">Total Reviews</div>
        </div>
        <div class="stat-card">
            <div class="stat-value" style="color:var(--muted)">
                <c:set var="pending" value="0"/>
                <c:forEach var="r" items="${allReviews}">
                    <c:if test="${r.status == 'PENDING'}"><c:set var="pending" value="${pending+1}"/></c:if>
                </c:forEach>
                ${pending}
            </div>
            <div class="stat-label">Pending</div>
        </div>
        <div class="stat-card">
            <div class="stat-value" style="color:var(--green)">
                <c:set var="approved" value="0"/>
                <c:forEach var="r" items="${allReviews}">
                    <c:if test="${r.status == 'APPROVED'}"><c:set var="approved" value="${approved+1}"/></c:if>
                </c:forEach>
                ${approved}
            </div>
            <div class="stat-label">Approved</div>
        </div>
        <div class="stat-card">
            <div class="stat-value" style="color:var(--accent2)">
                <c:set var="rejected" value="0"/>
                <c:forEach var="r" items="${allReviews}">
                    <c:if test="${r.status == 'REJECTED'}"><c:set var="rejected" value="${rejected+1}"/></c:if>
                </c:forEach>
                ${rejected}
            </div>
            <div class="stat-label">Rejected</div>
        </div>
    </div>

    <!-- Table -->
    <div class="card">
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Review ID</th>
                        <th>Event</th>
                        <th>User</th>
                        <th>Rating</th>
                        <th>Comment</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty allReviews}">
                            <tr><td colspan="8" class="text-muted" style="text-align:center; padding:2rem;">No reviews found.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="review" items="${allReviews}">
                                <tr>
                                    <td class="text-muted" style="font-size:0.78rem;">${review.reviewId}</td>
                                    <td>${review.eventName}</td>
                                    <td>${review.username}</td>
                                    <td><span class="stars" style="font-size:0.95rem;">${review.starDisplay}</span></td>
                                    <td style="max-width:220px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                                        ${review.comment}
                                    </td>
                                    <td><span class="badge badge-${review.reviewType.toLowerCase()}">${review.reviewType}</span></td>
                                    <td><span class="badge badge-${review.status.toLowerCase()}">${review.status}</span></td>
                                    <td>
                                        <div class="flex gap-1">
                                            <c:if test="${review.status != 'APPROVED'}">
                                                <a href="${pageContext.request.contextPath}/ReviewServlet?action=setStatus&reviewId=${review.reviewId}&status=APPROVED"
                                                   class="btn btn-success btn-sm">✓</a>
                                            </c:if>
                                            <c:if test="${review.status != 'REJECTED'}">
                                                <a href="${pageContext.request.contextPath}/ReviewServlet?action=setStatus&reviewId=${review.reviewId}&status=REJECTED"
                                                   class="btn btn-ghost btn-sm">✗</a>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/ReviewServlet?action=delete&reviewId=${review.reviewId}"
                                               class="btn btn-danger btn-sm"
                                               onclick="return confirm('Permanently delete this review?')">🗑</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

</div>
</body>
</html>
