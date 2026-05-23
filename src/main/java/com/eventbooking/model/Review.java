package com.eventbooking.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Review.java - Base class representing a user review/rating for an event.
 * Demonstrates: Encapsulation (private fields + getters/setters),
 *               Abstraction (abstract getSummary method)
 */
public abstract class Review {

    // ── Encapsulated Fields ──────────────────────────────────────────────────
    private String reviewId;
    private String eventId;
    private String eventName;
    private String userId;
    private String username;
    private int rating;          // 1–5
    private String comment;
    private String reviewDate;
    private String status;       // PENDING | APPROVED | REJECTED

    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // ── Constructors ─────────────────────────────────────────────────────────
    public Review() {
        this.reviewDate = LocalDateTime.now().format(FORMATTER);
        this.status = "PENDING";
    }

    public Review(String reviewId, String eventId, String eventName,
                  String userId, String username, int rating, String comment) {
        this();
        this.reviewId  = reviewId;
        this.eventId   = eventId;
        this.eventName = eventName;
        this.userId    = userId;
        this.username  = username;
        setRating(rating);        // validated setter
        this.comment   = comment;
    }

    // ── Abstract Method (Abstraction) ─────────────────────────────────────────
    /**
     * Returns a short human-readable summary of the review type.
     * Subclasses must implement this (Polymorphism).
     */
    public abstract String getReviewType();

    // ── Business Logic ────────────────────────────────────────────────────────
    public String getStarDisplay() {
        return "★".repeat(rating) + "☆".repeat(5 - rating);
    }

    public boolean isApproved() {
        return "APPROVED".equalsIgnoreCase(status);
    }

    /**
     * Serialize to a single pipe-delimited line for file storage.
     * Format: reviewId|eventId|eventName|userId|username|rating|comment|reviewDate|status|reviewType
     */
    public String toFileString() {
        return String.join("|",
                reviewId, eventId, eventName, userId, username,
                String.valueOf(rating), comment.replace("|", ";;"),
                reviewDate, status, getReviewType());
    }

    /**
     * Deserialize from a pipe-delimited line — factory used in ReviewFileHandler.
     */
    public static Review fromFileString(String line) {
        String[] parts = line.split("\\|", 10);
        if (parts.length < 10) return null;

        String type    = parts[9].trim();
        int    rating  = Integer.parseInt(parts[5].trim());
        String comment = parts[6].replace(";;", "|");

        Review r;
        if ("VERIFIED".equals(type)) {
            r = new VerifiedReview();
        } else {
            r = new PublicReview();
        }
        r.setReviewId(parts[0].trim());
        r.setEventId(parts[1].trim());
        r.setEventName(parts[2].trim());
        r.setUserId(parts[3].trim());
        r.setUsername(parts[4].trim());
        r.setRating(rating);
        r.setComment(comment);
        r.setReviewDate(parts[7].trim());
        r.setStatus(parts[8].trim());
        return r;
    }

    // ── Getters & Setters (Encapsulation) ────────────────────────────────────
    public String getReviewId()               { return reviewId; }
    public void   setReviewId(String id)      { this.reviewId = id; }

    public String getEventId()                { return eventId; }
    public void   setEventId(String id)       { this.eventId = id; }

    public String getEventName()              { return eventName; }
    public void   setEventName(String name)   { this.eventName = name; }

    public String getUserId()                 { return userId; }
    public void   setUserId(String id)        { this.userId = id; }

    public String getUsername()               { return username; }
    public void   setUsername(String name)    { this.username = name; }

    public int    getRating()                 { return rating; }
    public void   setRating(int rating) {
        if (rating < 1 || rating > 5)
            throw new IllegalArgumentException("Rating must be between 1 and 5.");
        this.rating = rating;
    }

    public String getComment()                { return comment; }
    public void   setComment(String comment)  { this.comment = comment; }

    public String getReviewDate()             { return reviewDate; }
    public void   setReviewDate(String date)  { this.reviewDate = date; }

    public String getStatus()                 { return status; }
    public void   setStatus(String status)    { this.status = status; }

    @Override
    public String toString() {
        return "[" + getReviewType() + "] " + username + " → " +
               eventName + " " + getStarDisplay() + " (" + status + ")";
    }
}
