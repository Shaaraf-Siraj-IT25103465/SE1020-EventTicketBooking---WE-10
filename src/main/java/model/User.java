package model;

public class User {

    private int userId;
    private String firstName;
    private String lastName;
    private String email;
    private String phoneNumber;
    private String password;   // Plain text (OK for assignment)
    private String userRole;
    private long createdAt;

    public User() {}

    // ---------- Getters ----------
    public int getUserId() { return userId; }
    public String getFirstName() { return firstName; }
    public String getLastName() { return lastName; }
    public String getEmail() { return email; }
    public String getPhoneNumber() { return phoneNumber; }
    public String getPassword() { return password; }
    public String getUserRole() { return userRole; }
    public long getCreatedAt() { return createdAt; }

    // ---------- Setters ----------
    public void setUserId(int userId) { this.userId = userId; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public void setEmail(String email) { this.email = email; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public void setPassword(String password) { this.password = password; }
    public void setUserRole(String userRole) { this.userRole = userRole; }
    public void setCreatedAt(long createdAt) { this.createdAt = createdAt; }

    // ---------- Helper ----------
    public String getFullName() {
        return (safe(firstName) + " " + safe(lastName)).trim();
    }

    // ---------- File format ----------
    // userId|firstName|lastName|email|phone|password|role|createdAt
    public String toFileLine() {
        return userId + "|" +
                safe(firstName) + "|" +
                safe(lastName) + "|" +
                safe(email) + "|" +
                safe(phoneNumber) + "|" +
                safe(password) + "|" +
                safe(userRole) + "|" +
                createdAt;
    }

    public static User fromFileLine(String line) {
        if (line == null || line.trim().isEmpty()) return null;

        String[] p = line.split("\\|", -1);
        if (p.length < 8) return null;

        User u = new User();
        u.setUserId(parseInt(p[0]));
        u.setFirstName(p[1]);
        u.setLastName(p[2]);
        u.setEmail(p[3]);
        u.setPhoneNumber(p[4]);
        u.setPassword(p[5]);
        u.setUserRole(p[6]);
        u.setCreatedAt(parseLong(p[7]));
        return u;
    }

    private static String safe(String s) {
        return s == null ? "" : s.trim();
    }

    private static int parseInt(String s) {
        try { return Integer.parseInt(s.trim()); } catch (Exception e) { return 0; }
    }

    private static long parseLong(String s) {
        try { return Long.parseLong(s.trim()); } catch (Exception e) { return 0L; }
    }
}
