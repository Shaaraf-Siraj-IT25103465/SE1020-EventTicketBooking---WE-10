package com.example.venuemanagement.controller;

import com.example.venuemanagement.model.Venue;
import com.example.venuemanagement.service.VenueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/venues")
@CrossOrigin(origins = "*")
public class VenueController {

    @Autowired
    private VenueService service;

    @PostMapping
    public Venue addVenue(@RequestBody Venue venue) {
        return service.addVenue(venue);
    }

    @GetMapping
    public List<Venue> getAllVenues() {
        return service.getAllVenues();
    }

    @PutMapping("/{id}")
    public Venue updateVenue(@PathVariable int id, @RequestBody Venue venue) {
        return service.updateVenue(id, venue);
    }

    @DeleteMapping("/{id}")
    public String deleteVenue(@PathVariable int id) {
        if (service.deleteVenue(id)) {
            return "Venue deleted successfully";
        }
        return "Venue not found";
    }

    @GetMapping("/search")
    public List<Venue> searchVenues(@RequestParam(required = false) String name,
                                    @RequestParam(required = false) String location) {
        return service.searchVenues(name, location);
    }
}
