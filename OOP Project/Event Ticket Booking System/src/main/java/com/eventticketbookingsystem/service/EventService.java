package com.eventticketbookingsystem.service;

import com.eventticketbookingsystem.model.Event;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public interface EventService {
    void addEvent(Event event) throws Exception;
    List<Event> getAllEvents() throws Exception;
    void updateEvent(Event event) throws Exception;
    void deleteEvent(String eventId) throws Exception;
}
