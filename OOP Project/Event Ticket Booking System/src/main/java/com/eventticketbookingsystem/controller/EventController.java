package com.eventticketbookingsystem.controller;

import com.eventticketbookingsystem.model.Event;
import org.springframework.ui.Model;
import com.eventticketbookingsystem.service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/events")//Sets base URL for all methods in the controller


public class EventController {

    @Autowired // Tells the spring to automatically create and inject the object
    EventService eventService;



    // READ - list all events
    @GetMapping("/list") //Handles GET request - when user visit URL in browser
    public String listEvents(Model model) {
        try {
            model.addAttribute("events", eventService.getAllEvents());
            return "events/list";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }
    // CREATE - show add form
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("event", new Event());
        return "events/add";
    }

    // CREATE - submit add form
    @PostMapping("/add")
    public String addEvent(@ModelAttribute Event event) {
        try {
            event.setEventId("E" + System.currentTimeMillis());
            event.setAvailableSeats(event.getTotalSeats());
            eventService.addEvent(event);
            return "redirect:/events/";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    // UPDATE - show edit form
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable String id, Model model) {
        try {
            // Search for the event in your text file database
            Event existingEvent = eventService.getAllEvents()
                    .stream()
                    .filter(e -> e.getEventId().equals(id))
                    .findFirst()
                    .orElse(null);

            // Safety Check: If not found, create a blank object instead of passing null
            if (existingEvent == null) {
                existingEvent = new Event();
                existingEvent.setEventId(id); // Assign the ID so it's not empty
            }

            model.addAttribute("event", existingEvent);
            return "events/edit";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    // UPDATE - submit edit form
    @PostMapping("/update")
    public String updateEvent(@ModelAttribute Event event) {
        try {
            eventService.updateEvent(event);
            return "redirect:/events/";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    // DELETE
    @GetMapping("/delete/{id}")
    public String deleteEvent(@PathVariable String id) {
        try {
            eventService.deleteEvent(id);
            return "redirect:/events/";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }
}

