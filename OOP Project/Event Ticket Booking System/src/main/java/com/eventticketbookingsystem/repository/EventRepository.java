package com.eventticketbookingsystem.repository;

import com.eventticketbookingsystem.model.Event;
import org.springframework.stereotype.Repository;

import  java.util.List;

@Repository

public interface EventRepository {
    void create(Event event) throws Exception;
    List<Event> readAll() throws Exception;
    void update(Event updated) throws Exception;
    void delete(String eventId) throws Exception;
}
