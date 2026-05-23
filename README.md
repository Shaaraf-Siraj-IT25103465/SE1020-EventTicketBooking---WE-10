# Review & Rating Management Module
### SE1020 – Object Oriented Programming | Event Ticket Booking System

**Developer:** [Your Name] | **Student ID:** [Your ID]

---

## Module Overview

This module handles all review and rating functionality for the Event Ticket Booking System.
Users can submit, edit and delete their own reviews. Admins can approve, reject, and delete any review.

---

## CRUD Operations

| Operation | Endpoint | Description |
|-----------|----------|-------------|
| **Create** | `POST /ReviewServlet?action=submit` | Submit a new review |
| **Read** | `GET /ReviewServlet?action=view` | View reviews by event |
| **Read** | `GET /ReviewServlet?action=myReviews` | View own reviews |
| **Update** | `POST /ReviewServlet?action=update` | Edit own review |
| **Delete** | `GET /ReviewServlet?action=delete` | Delete a review |

---

## OOP Concepts Applied

### Encapsulation
- `Review.java` — all fields are `private`, accessed via public getters/setters
- Rating validation inside `setRating()` — rejects values outside 1–5

### Inheritance
- `Review` (abstract base class)
  - `PublicReview extends Review` — any registered user
  - `VerifiedReview extends Review` — user with a ticket purchase

### Polymorphism
- `getReviewType()` is abstract in `Review`, overridden in both subclasses
- `Review.fromFileString()` instantiates the correct subclass at runtime

### Abstraction
- `getReviewType()` is abstract — callers don't care about subclass details
- `ReviewFileHandler` hides all file I/O behind clean method names

### Information Hiding
- `ticketId` in `VerifiedReview` is not exposed to the parent class

---

## File Handling

Data is stored in `data/reviews.txt` using pipe-delimited format:

```
reviewId|eventId|eventName|userId|username|rating|comment|reviewDate|status|reviewType
```

- **Write (append):** `BufferedWriter` with `FileWriter(path, true)` — used on Create
- **Read:** `BufferedReader` + `FileReader` — used on all Read operations
- **Rewrite:** Full file rewrite using `FileWriter(path, false)` — used on Update & Delete

---

## UI Pages (JSPs)

| Page | Path | Purpose |
|------|------|---------|
| Submit Review | `/WEB-INF/views/submitReview.jsp` | Create a new review |
| View Reviews | `/WEB-INF/views/viewReviews.jsp` | Read reviews for an event |
| My Reviews | `/WEB-INF/views/myReviews.jsp` | Read + Edit + Delete own reviews |
| Edit Review | `/WEB-INF/views/editReview.jsp` | Update an existing review |
| Moderate Reviews | `/WEB-INF/views/moderateReviews.jsp` | Admin approve/reject/delete |
| Dashboard | `/WEB-INF/views/dashboard.jsp` | Overview stats |

---

## Setup & Run

1. Open the project in **IntelliJ IDEA**
2. Ensure **Java 11+** and **Maven** are installed
3. Run the main Spring Boot class or use: `mvn spring-boot:run`
4. Access: `http://localhost:8080/ReviewServlet?action=dashboard`

---

## Class Diagram Summary

```
         ┌─────────────────────────────┐
         │       <<abstract>>          │
         │           Review            │
         │─────────────────────────────│
         │ - reviewId : String         │
         │ - eventId  : String         │
         │ - rating   : int            │
         │ - status   : String         │
         │─────────────────────────────│
         │ + getReviewType() : String  │  ◄── abstract
         │ + toFileString()  : String  │
         │ + fromFileString(): Review  │  ◄── static factory
         └──────────────┬──────────────┘
                        │ extends
           ┌────────────┴──────────────┐
           ▼                           ▼
  ┌─────────────────┐       ┌──────────────────────┐
  │   PublicReview  │       │    VerifiedReview     │
  │─────────────────│       │──────────────────────│
  │ getReviewType() │       │ - ticketId : String   │
  │  → "PUBLIC"     │       │ getReviewType()       │
  └─────────────────┘       │  → "VERIFIED"         │
                            └──────────────────────┘

  ┌───────────────────────────────────────────────┐
  │             ReviewFileHandler                 │
  │ (Utility – no inheritance, pure file I/O)     │
  │───────────────────────────────────────────────│
  │ + saveReview(Review)      → CREATE            │
  │ + getAllReviews()          → READ              │
  │ + getReviewsByEvent(id)   → READ (filtered)   │
  │ + updateReview(Review)    → UPDATE            │
  │ + deleteReview(id)        → DELETE            │
  └───────────────────────────────────────────────┘
```
