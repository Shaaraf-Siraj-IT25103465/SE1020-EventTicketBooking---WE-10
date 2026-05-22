package com.example.venuemanagement.service;

import com.example.venuemanagement.model.Venue;
import com.example.venuemanagement.repository.VenueFileRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class VenueService {
    @Autowired
    private VenueFileRepository repository;

    public Venue addVenue(Venue venue) {
        venue.setId(repository.getNextId());
        repository.append(venue);
        return venue;
    }

    public List<Venue> getAllVenues() {
        return repository.findAll();
    }

    public Venue updateVenue(int id, Venue updatedVenue) {
        List<Venue> venues = repository.findAll();
        for (int i = 0; i < venues.size(); i++) {
            if (venues.get(i).getId() == id) {
                updatedVenue.setId(id);
                venues.set(i, updatedVenue);
                repository.saveAll(venues);
                return updatedVenue;
            }
        }
        return null;
    }

    public boolean deleteVenue(int id) {
        List<Venue> venues = repository.findAll();
        boolean removed = venues.removeIf(v -> v.getId() == id);
        if (removed) {
            repository.saveAll(venues);
        }
        return removed;
    }

    public List<Venue> searchVenues(String name, String location) {
        return repository.findAll().stream()
                .filter(v -> (name == null || v.getName().toLowerCase().contains(name.toLowerCase())) &&
                             (location == null || v.getLocation().toLowerCase().contains(location.toLowerCase())))
                .collect(Collectors.toList());
    }
}
