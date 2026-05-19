package com.eventticketbookingsystem.model;

import lombok.Getter;
import lombok.Setter;
@Getter
@Setter

public class Event {

    private String eventId;
    private String eventName;
    private String category;
    private String date;
    private String time;
    private String venue;
    private int totalSeats;
    private int availableSeats;
    private double ticketPrice;

    public Event(String eventId, String eventName, String category, String date, String time, String venue, int totalSeats, int availableSeats, double ticketPrice  ){

        this.eventId= eventId;
        this.eventName= eventName;
        this.category= category;
        this.date = date;
        this.time = time;
        this.venue = venue;
        this.totalSeats=totalSeats;
        this.ticketPrice = ticketPrice;
        this.availableSeats = availableSeats;
    }

    public Event() {
    }
}


