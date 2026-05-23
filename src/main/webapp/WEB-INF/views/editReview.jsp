<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Review</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/review-styles.css">
</head>
<body>

<nav class="nav">
    <a class="nav-brand" href="#">🎟 EventBook</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/ReviewServlet?action=myReviews">My Reviews</a>
    </div>
</nav>

<div class="container">

    <div class="page-header">
        <h1>Edit Your Review</h1>
        <p>Update your feedback for <strong>${review.eventName}</strong></p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:if test="${not empty review}">
        <div class="card" style="max-width:620px;">
            <form action="${pageContext.request.contextPath}/ReviewServlet" method="POST">
                <input type="hidden" name="action"   value="update">
                <input type="hidden" name="reviewId" value="${review.reviewId}">

                <!-- Star Rating -->
                <div class="form-group">
                    <label>Your Rating *</label>
                    <div class="star-input">
                        <c:forEach begin="1" end="5" var="i">
                            <c:set var="val" value="${6-i}"/>
                            <input type="radio" name="rating" id="s${val}" value="${val}"
                                   ${review.rating == val ? 'checked' : ''}>
                            <label for="s${val}">★</label>
                        </c:forEach>
                    </div>
                </div>

                <!-- Comment -->
                <div class="form-group">
                    <label for="comment">Review Comment *</label>
                    <textarea class="form-control" id="comment" name="comment"
                              maxlength="500" required>${review.comment}</textarea>
                </div>

                <div class="flex gap-2 mt-2">
                    <button type="submit" class="btn btn-primary">Update Review</button>
                    <a href="${pageContext.request.contextPath}/ReviewServlet?action=myReviews"
                       class="btn btn-ghost">Cancel</a>
                </div>
            </form>
        </div>
    </c:if>

</div>
</body>
</html>
