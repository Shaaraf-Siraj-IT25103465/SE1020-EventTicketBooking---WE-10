package com.example.venuemanagement.model;

public class Venue {
    private int id;
    private String name;
    private String location;
    private int capacity;
    private String description;
    private String status;

    public Venue() {}

    public Venue(int id, String name, String location, int capacity, String description, String status) {
        this.id = id;
        this.name = name;
        this.location = location;
        this.capacity = capacity;
        this.description = description;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return id + "|" + name + "|" + location + "|" + capacity + "|" + description + "|" + status;
    }

    public static Venue fromString(String line) {
        String[] parts = line.split("\\|");
        if (parts.length < 6) return null;
        try {
            return new Venue(
                Integer.parseInt(parts[0]),
                parts[1],
                parts[2],
                Integer.parseInt(parts[3]),
                parts[4],
                parts[5]
            );
        } catch (Exception e) {
            return null;
        }
    }
}
