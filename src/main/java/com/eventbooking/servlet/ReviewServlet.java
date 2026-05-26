package com.eventbooking.servlet;

import com.eventbooking.model.*;
import com.eventbooking.util.ReviewFileHandler;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import javax.servlet.http.HttpSession;

/**
 * ReviewServlet.java
 * Central controller (Front Controller pattern) for all Review & Rating operations.
 *
 * URL Mapping: /ReviewServlet?action=<action>
 * Actions: submit | view | edit | update | delete | moderate | myReviews | dashboard
 *
 * Demonstrates: Servlet lifecycle (init, doGet, doPost, destroy),
 *               Request dispatching, Session management
 */
@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        System.out.println("ReviewServlet initialized.");
    }

    // ── GET – page navigation & read operations ───────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // TEMP SESSION FIX
        HttpSession session = req.getSession(true);
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", "USR-001");
            session.setAttribute("username", "TestUser");
        }

        String action = req.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {

            case "view": {
                String eventId   = req.getParameter("eventId");
                String eventName = req.getParameter("eventName");
                List<Review> reviews = ReviewFileHandler.getReviewsByEvent(eventId);
                double avgRating = ReviewFileHandler.getAverageRating(eventId);
                req.setAttribute("reviews",   reviews);
                req.setAttribute("avgRating", String.format("%.1f", avgRating));
                req.setAttribute("eventId",   eventId);
                req.setAttribute("eventName", eventName);
                dispatch(req, resp, "/WEB-INF/views/viewReviews.jsp");
                break;
            }

            case "myReviews": {
                String userId = getLoggedInUserId(req);
                if (userId == null) { resp.sendRedirect("login.jsp"); return; }
                List<Review> myReviews = ReviewFileHandler.getReviewsByUser(userId);
                req.setAttribute("myReviews", myReviews);
                dispatch(req, resp, "/WEB-INF/views/myReviews.jsp");
                break;
            }

            case "submitForm": {
                String eventId   = req.getParameter("eventId");
                String eventName = req.getParameter("eventName");
                req.setAttribute("eventId",   eventId);
                req.setAttribute("eventName", eventName);
                dispatch(req, resp, "/WEB-INF/views/submitReview.jsp");
                break;
            }

            case "editForm": {
                String reviewId = req.getParameter("reviewId");
                Review review   = ReviewFileHandler.getReviewById(reviewId);
                if (review == null) { req.setAttribute("error", "Review not found."); }
                req.setAttribute("review", review);
                dispatch(req, resp, "/WEB-INF/views/editReview.jsp");
                break;
            }

            case "moderate": {
                List<Review> allReviews = ReviewFileHandler.getAllReviews();
                req.setAttribute("allReviews", allReviews);
                dispatch(req, resp, "/WEB-INF/views/moderateReviews.jsp");
                break;
            }

            case "delete": {
                String reviewId  = req.getParameter("reviewId");
                String returnUrl = req.getParameter("return");
                boolean deleted  = ReviewFileHandler.deleteReview(reviewId);
                req.getSession().setAttribute("message",
                        deleted ? "Review deleted successfully." : "Delete failed.");
                resp.sendRedirect(returnUrl != null ? returnUrl : "ReviewServlet?action=moderate");
                break;
            }

            case "setStatus": {
                String reviewId = req.getParameter("reviewId");
                String status   = req.getParameter("status");
                Review r = ReviewFileHandler.getReviewById(reviewId);
                if (r != null) {
                    r.setStatus(status);
                    ReviewFileHandler.updateReview(r);
                }
                resp.sendRedirect("ReviewServlet?action=moderate");
                break;
            }

            default: {
                List<Review> allReviews = ReviewFileHandler.getAllReviews();
                req.setAttribute("allReviews", allReviews);
                dispatch(req, resp, "/WEB-INF/views/dashboard.jsp");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // TEMP SESSION FIX
        HttpSession session = req.getSession(true);
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", "USR-001");
            session.setAttribute("username", "TestUser");
        }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        switch (action != null ? action : "") {

            case "submit": {
                String eventId   = req.getParameter("eventId");
                String eventName = req.getParameter("eventName");
                String userId    = getLoggedInUserId(req);
                String username  = getLoggedInUsername(req);
                int    rating    = parseRating(req.getParameter("rating"));
                String comment   = sanitize(req.getParameter("comment"));
                String ticketId  = req.getParameter("ticketId");

                if (userId == null) { resp.sendRedirect("login.jsp"); return; }

                Review review;
                String reviewId = ReviewFileHandler.generateReviewId();

                if (ticketId != null && !ticketId.trim().isEmpty()) {
                    review = new VerifiedReview(reviewId, eventId, eventName,
                            userId, username, rating, comment, ticketId);
                } else {
                    review = new PublicReview(reviewId, eventId, eventName,
                            userId, username, rating, comment);
                }

                boolean saved = ReviewFileHandler.saveReview(review);
                req.getSession().setAttribute("message",
                        saved ? "Your review has been submitted for moderation!"
                                : "Failed to submit review. Please try again.");
                resp.sendRedirect("ReviewServlet?action=view&eventId=" + eventId
                        + "&eventName=" + encode(eventName));
                break;
            }

            case "update": {
                String reviewId = req.getParameter("reviewId");
                Review existing = ReviewFileHandler.getReviewById(reviewId);

                if (existing == null) {
                    req.getSession().setAttribute("message", "Review not found.");
                    resp.sendRedirect("ReviewServlet?action=myReviews");
                    return;
                }

                int    newRating  = parseRating(req.getParameter("rating"));
                String newComment = sanitize(req.getParameter("comment"));

                existing.setRating(newRating);
                existing.setComment(newComment);
                existing.setStatus("PENDING");

                boolean updated = ReviewFileHandler.updateReview(existing);
                req.getSession().setAttribute("message",
                        updated ? "Review updated successfully!" : "Update failed.");
                resp.sendRedirect("ReviewServlet?action=myReviews");
                break;
            }

            default:
                resp.sendRedirect("ReviewServlet?action=dashboard");
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────
    private void dispatch(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, resp);
    }

    private String getLoggedInUserId(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null ? (String) session.getAttribute("userId") : null;
    }

    private String getLoggedInUsername(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null ? (String) session.getAttribute("username") : "Guest";
    }

    private int parseRating(String val) {
        try {
            int r = Integer.parseInt(val);
            return Math.min(5, Math.max(1, r));
        } catch (Exception e) { return 3; }
    }

    private String sanitize(String input) {
        if (input == null) return "";
        return input.trim().replaceAll("[<>\"']", "");
    }

    private String encode(String s) {
        try { return java.net.URLEncoder.encode(s, "UTF-8"); }
        catch (Exception e) { return s; }
    }

    @Override
    public void destroy() {
        System.out.println("ReviewServlet destroyed.");
    }
}
