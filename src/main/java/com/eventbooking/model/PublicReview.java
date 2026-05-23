package com.eventbooking.model;

/**
 * PublicReview.java
 * Represents a review submitted by any registered user.
 * Demonstrates: Inheritance (extends Review), Polymorphism (overrides getReviewType)
 */
public class PublicReview extends Review {

    public PublicReview() {
        super();
    }

    public PublicReview(String reviewId, String eventId, String eventName,
                        String userId, String username, int rating, String comment) {
        super(reviewId, eventId, eventName, userId, username, rating, comment);
    }

    /**
     * Polymorphic implementation – returns the review type label.
     */
    @Override
    public String getReviewType() {
        return "PUBLIC";
    }
}
