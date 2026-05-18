package service;

import model.User;
import util.FileUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class UserService {

    private static final String USERS_FILE = "users.txt";
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9+()\\-\\s]{7,20}$");
    private static final Pattern NAME_PATTERN = Pattern.compile("^[A-Za-z ]{2,50}$");

    // ---------- REGISTER ----------
    public void register(User user) throws IOException {
        validate(user);

        user.setFirstName(user.getFirstName().trim());
        user.setLastName(user.getLastName().trim());
        user.setEmail(user.getEmail().trim().toLowerCase());
        user.setPhoneNumber(user.getPhoneNumber().trim());

        List<User> users = getAllUsers();

        for (User u : users) {
            if (u.getEmail().equalsIgnoreCase(user.getEmail())) {
                throw new IllegalArgumentException("Email already exists");
            }
        }

        int nextId = 1;
        for (User u : users) {
            if (u.getUserId() >= nextId) {
                nextId = u.getUserId() + 1;
            }
        }

        user.setUserId(nextId);
        user.setUserRole("USER");
        user.setCreatedAt(System.currentTimeMillis());

        FileUtil.appendLine(USERS_FILE, user.toFileLine());
    }

    // ---------- LOGIN ----------
    public User login(String email, String password) throws IOException {
        if (email == null || password == null) return null;

        email = email.trim().toLowerCase();

        for (User u : getAllUsers()) {
            if (u.getEmail().equalsIgnoreCase(email)
                    && u.getPassword().equals(password)) {
                return u;
            }
        }
        return null;
    }

    // ---------- READ ----------
    public List<User> getAllUsers() throws IOException {
        List<String> lines = FileUtil.readLines(USERS_FILE);
        List<User> users = new ArrayList<>();

        for (String line : lines) {
            User u = User.fromFileLine(line);
            if (u != null) users.add(u);
        }
        return users;
    }

    public User getUserById(int userId) throws IOException {
        for (User u : getAllUsers()) {
            if (u.getUserId() == userId) {
                return u;
            }
        }
        return null;
    }

    public User updateProfile(int userId, String firstName, String lastName, String email, String phoneNumber) throws IOException {
        if (isBlank(firstName)) throw new IllegalArgumentException("First name required");
        if (isBlank(lastName)) throw new IllegalArgumentException("Last name required");
        if (isBlank(email)) throw new IllegalArgumentException("Email required");
        if (isBlank(phoneNumber)) throw new IllegalArgumentException("Phone required");
        if (!isValidName(firstName)) throw new IllegalArgumentException("Invalid first name");
        if (!isValidName(lastName)) throw new IllegalArgumentException("Invalid last name");
        if (!isValidEmail(email)) throw new IllegalArgumentException("Invalid email");
        if (!isValidPhone(phoneNumber)) throw new IllegalArgumentException("Invalid phone number");

        List<User> users = getAllUsers();
        User updated = null;

        String normalizedEmail = email.trim().toLowerCase();
        for (User u : users) {
            if (u.getUserId() != userId && u.getEmail().equalsIgnoreCase(normalizedEmail)) {
                throw new IllegalArgumentException("Email already exists");
            }
        }

        for (User u : users) {
            if (u.getUserId() == userId) {
                u.setFirstName(firstName.trim());
                u.setLastName(lastName.trim());
                u.setEmail(normalizedEmail);
                u.setPhoneNumber(phoneNumber.trim());
                updated = u;
                break;
            }
        }

        if (updated == null) {
            throw new IllegalArgumentException("User not found");
        }

        saveAllUsers(users);
        return updated;
    }

    public void changePassword(int userId, String currentPassword, String newPassword) throws IOException {
        if (isBlank(currentPassword)) throw new IllegalArgumentException("Current password required");
        if (isBlank(newPassword)) throw new IllegalArgumentException("New password required");
        if (!isValidPassword(newPassword)) {
            throw new IllegalArgumentException("New password must be at least 6 characters and include letters and numbers");
        }

        List<User> users = getAllUsers();
        User target = null;

        for (User u : users) {
            if (u.getUserId() == userId) {
                target = u;
                break;
            }
        }

        if (target == null) throw new IllegalArgumentException("User not found");
        if (!target.getPassword().equals(currentPassword)) {
            throw new IllegalArgumentException("Current password is incorrect");
        }

        target.setPassword(newPassword.trim());
        saveAllUsers(users);
    }

    private void saveAllUsers(List<User> users) throws IOException {
        List<String> lines = new ArrayList<>();
        for (User u : users) {
            lines.add(u.toFileLine());
        }
        FileUtil.writeLines(USERS_FILE, lines);
    }

    private void validate(User u) {
        if (u == null) throw new IllegalArgumentException("User required");
        if (isBlank(u.getFirstName())) throw new IllegalArgumentException("First name required");
        if (isBlank(u.getLastName())) throw new IllegalArgumentException("Last name required");
        if (isBlank(u.getEmail())) throw new IllegalArgumentException("Email required");
        if (isBlank(u.getPhoneNumber())) throw new IllegalArgumentException("Phone required");
        if (isBlank(u.getPassword())) throw new IllegalArgumentException("Password required");

        if (!isValidName(u.getFirstName())) throw new IllegalArgumentException("Invalid first name");
        if (!isValidName(u.getLastName())) throw new IllegalArgumentException("Invalid last name");
        if (!isValidEmail(u.getEmail())) {
            throw new IllegalArgumentException("Invalid email");
        }
        if (!isValidPhone(u.getPhoneNumber())) throw new IllegalArgumentException("Invalid phone number");
        if (!isValidPassword(u.getPassword())) {
            throw new IllegalArgumentException("Password must be at least 6 characters and include letters and numbers");
        }
    }

    public void updateUserRole(int userId, String role) throws IOException {
        if (userId <= 0) throw new IllegalArgumentException("Invalid user id");
        if (!("USER".equalsIgnoreCase(role) || "ADMIN".equalsIgnoreCase(role))) {
            throw new IllegalArgumentException("Invalid role");
        }

        List<User> users = getAllUsers();
        User target = null;
        for (User user : users) {
            if (user.getUserId() == userId) {
                target = user;
                break;
            }
        }

        if (target == null) throw new IllegalArgumentException("User not found");

        target.setUserRole(role.trim().toUpperCase());
        saveAllUsers(users);
    }

    public void deleteUser(int userId) throws IOException {
        if (userId <= 0) throw new IllegalArgumentException("Invalid user id");

        List<User> users = getAllUsers();
        boolean removed = users.removeIf(user -> user.getUserId() == userId);
        if (!removed) throw new IllegalArgumentException("User not found");

        saveAllUsers(users);
    }

    public boolean isValidEmail(String email) {
        return !isBlank(email) && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public boolean isValidPhone(String phone) {
        return !isBlank(phone) && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public boolean isValidPassword(String password) {
        if (isBlank(password)) return false;
        String value = password.trim();
        if (value.length() < 6) return false;

        boolean hasLetter = false;
        boolean hasDigit = false;
        for (char c : value.toCharArray()) {
            if (Character.isLetter(c)) hasLetter = true;
            if (Character.isDigit(c)) hasDigit = true;
        }
        return hasLetter && hasDigit;
    }

    public boolean isValidName(String name) {
        return !isBlank(name) && NAME_PATTERN.matcher(name.trim()).matches();
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
