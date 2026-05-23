package com.eventbooking.util;

import com.eventbooking.model.Review;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.stream.Collectors;

/**
 * ReviewFileHandler.java
 * Handles all file read/write operations for reviews.
 * Data is stored in reviews.txt using pipe-delimited format.
 *
 * Demonstrates: File Handling (BufferedReader, BufferedWriter, FileWriter)
 */
public class ReviewFileHandler {

    private static final String FILE_PATH = "data/reviews.txt";

    // ── Ensure file exists ────────────────────────────────────────────────────
    static {
        try {
            File dir  = new File("data");
            File file = new File(FILE_PATH);
            if (!dir.exists())  dir.mkdirs();
            if (!file.exists()) file.createNewFile();
        } catch (IOException e) {
            System.err.println("Failed to initialize reviews.txt: " + e.getMessage());
        }
    }

    // ── CREATE ────────────────────────────────────────────────────────────────
    /**
     * Appends a new review to reviews.txt.
     */
    public static boolean saveReview(Review review) {
        try (BufferedWriter writer = new BufferedWriter(
                new FileWriter(FILE_PATH, true))) {       // append = true
            writer.write(review.toFileString());
            writer.newLine();
            return true;
        } catch (IOException e) {
            System.err.println("Error saving review: " + e.getMessage());
            return false;
        }
    }

    // ── READ (all) ────────────────────────────────────────────────────────────
    /**
     * Reads all reviews from reviews.txt.
     */
    public static List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Review r = Review.fromFileString(line);
                    if (r != null) reviews.add(r);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading reviews: " + e.getMessage());
        }
        return reviews;
    }

    // ── READ (by event) ───────────────────────────────────────────────────────
    public static List<Review> getReviewsByEvent(String eventId) {
        return getAllReviews().stream()
                .filter(r -> r.getEventId().equals(eventId))
                .collect(Collectors.toList());
    }

    // ── READ (by user) ────────────────────────────────────────────────────────
    public static List<Review> getReviewsByUser(String userId) {
        return getAllReviews().stream()
                .filter(r -> r.getUserId().equals(userId))
                .collect(Collectors.toList());
    }

    // ── READ (by ID) ──────────────────────────────────────────────────────────
    public static Review getReviewById(String reviewId) {
        return getAllReviews().stream()
                .filter(r -> r.getReviewId().equals(reviewId))
                .findFirst()
                .orElse(null);
    }

    // ── UPDATE ────────────────────────────────────────────────────────────────
    /**
     * Updates a review (matched by reviewId) by rewriting the entire file.
     */
    public static boolean updateReview(Review updatedReview) {
        List<Review> all = getAllReviews();
        boolean found = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getReviewId().equals(updatedReview.getReviewId())) {
                all.set(i, updatedReview);
                found = true;
                break;
            }
        }
        if (!found) return false;
        return writeAll(all);
    }

    // ── DELETE ────────────────────────────────────────────────────────────────
    /**
     * Removes the review with the given ID and rewrites the file.
     */
    public static boolean deleteReview(String reviewId) {
        List<Review> all = getAllReviews();
        boolean removed  = all.removeIf(r -> r.getReviewId().equals(reviewId));
        if (!removed) return false;
        return writeAll(all);
    }

    // ── Utility: rewrite whole file ───────────────────────────────────────────
    private static boolean writeAll(List<Review> reviews) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, false))) {
            for (Review r : reviews) {
                writer.write(r.toFileString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            System.err.println("Error writing reviews: " + e.getMessage());
            return false;
        }
    }

    // ── Average rating for an event ───────────────────────────────────────────
    public static double getAverageRating(String eventId) {
        List<Review> eventReviews = getReviewsByEvent(eventId).stream()
                .filter(Review::isApproved)
                .collect(Collectors.toList());
        if (eventReviews.isEmpty()) return 0.0;
        return eventReviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);
    }

    // ── Generate unique ID ────────────────────────────────────────────────────
    public static String generateReviewId() {
        return "REV-" + System.currentTimeMillis();
    }
}
