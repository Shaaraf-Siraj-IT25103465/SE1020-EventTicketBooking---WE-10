package com.eventbooking.model;

/**
 * VerifiedReview.java
 * Represents a review from a user who has a confirmed ticket booking.
 * Demonstrates: Inheritance (extends Review), Polymorphism (overrides getReviewType)
 * Information Hiding: ticketId is only accessible via getter, not exposed in toFileString base.
 */
public class VerifiedReview extends Review {

    private String ticketId;   // Information hiding – extra field hidden from parent

    public VerifiedReview() {
        super();
    }

    public VerifiedReview(String reviewId, String eventId, String eventName,
                          String userId, String username, int rating,
                          String comment, String ticketId) {
        super(reviewId, eventId, eventName, userId, username, rating, comment);
        this.ticketId = ticketId;
    }

    /**
     * Polymorphic implementation – distinguishes this from PublicReview.
     */
    @Override
    public String getReviewType() {
        return "VERIFIED";
    }

    public String getTicketId()              { return ticketId; }
    public void   setTicketId(String id)     { this.ticketId = id; }
}
