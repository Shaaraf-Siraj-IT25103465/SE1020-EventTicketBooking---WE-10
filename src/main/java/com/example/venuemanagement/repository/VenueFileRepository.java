package com.example.venuemanagement.repository;

import com.example.venuemanagement.model.Venue;
import org.springframework.stereotype.Repository;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Repository
public class VenueFileRepository {
    private final String FILE_PATH = "venues.txt";

    public VenueFileRepository() {
        try {
            File file = new File(FILE_PATH);
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public List<Venue> findAll() {
        try {
            return Files.lines(Paths.get(FILE_PATH))
                    .map(Venue::fromString)
                    .filter(v -> v != null)
                    .collect(Collectors.toList());
        } catch (IOException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void saveAll(List<Venue> venues) {
        try (PrintWriter writer = new PrintWriter(new FileWriter(FILE_PATH))) {
            for (Venue venue : venues) {
                writer.println(venue.toString());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void append(Venue venue) {
        try (PrintWriter writer = new PrintWriter(new FileWriter(FILE_PATH, true))) {
            writer.println(venue.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public int getNextId() {
        List<Venue> venues = findAll();
        return venues.stream()
                .mapToInt(Venue::getId)
                .max()
                .orElse(0) + 1;
    }
}
