package com.eventticketbookingsystem.service;

import com.eventticketbookingsystem.filehandler.EventFileHandler;
import com.eventticketbookingsystem.model.Event;
import java.util.List;
@org.springframework.stereotype.Service


public class EventServiceImpl implements EventService {

    private final EventFileHandler fileHandler = new EventFileHandler();

    @Override
    public void addEvent(Event event) throws Exception {
        fileHandler.create(event);
    }

    @Override
    public List<Event> getAllEvents() throws Exception {
        return fileHandler.readAll();
    }

    @Override
    public void updateEvent(Event event) throws Exception {
        fileHandler.update(event);
    }

    @Override
    public void deleteEvent(String eventId) throws Exception {
        fileHandler.delete(eventId);
    }
}

