package util;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.List;

public final class FileUtil {

    private static Path baseDir;

    private FileUtil() {}

    // 🔹 Called ONCE from AppContextListener
    public static synchronized void init(String basePath) throws IOException {
        if (baseDir != null) return;

        if (basePath == null || basePath.trim().isEmpty()) {
            throw new IllegalArgumentException("Base path is null or empty");
        }

        baseDir = Paths.get(basePath).toAbsolutePath().normalize();
        Files.createDirectories(baseDir);

        System.out.println("[FileUtil] Base directory initialized: " + baseDir);
    }

    private static void ensureInit() {
        if (baseDir == null) {
            throw new IllegalStateException(
                    "FileUtil not initialized. Call FileUtil.init() from AppContextListener."
            );
        }
    }

    // 🔹 Ensure file exists (creates if missing)
    public static synchronized Path ensureFile(String filename) throws IOException {
        ensureInit();

        if (filename == null || filename.trim().isEmpty()) {
            throw new IllegalArgumentException("Filename is null or empty");
        }

        Path file = baseDir.resolve(filename).normalize();

        // Security: prevent path traversal
        if (!file.startsWith(baseDir)) {
            throw new SecurityException("Invalid filename: " + filename);
        }

        if (!Files.exists(file)) {
            Files.createFile(file);
            System.out.println("[FileUtil] Created file: " + file);
        }

        return file;
    }

    // 🔹 Read all non-empty lines
    public static List<String> readLines(String filename) throws IOException {
        Path file = ensureFile(filename);
        List<String> raw = Files.readAllLines(file, StandardCharsets.UTF_8);

        List<String> cleaned = new ArrayList<>();
        for (String line : raw) {
            if (line != null && !line.trim().isEmpty()) {
                cleaned.add(line.trim());
            }
        }
        return cleaned;
    }

    // 🔹 Overwrite file
    public static void writeLines(String filename, List<String> lines) throws IOException {
        Path file = ensureFile(filename);

        if (lines == null) lines = new ArrayList<>();

        Files.write(
                file,
                lines,
                StandardCharsets.UTF_8,
                StandardOpenOption.TRUNCATE_EXISTING,
                StandardOpenOption.CREATE
        );
    }

    // 🔹 Append ONE line (best for register)
    public static synchronized void appendLine(String filename, String line) throws IOException {
        Path file = ensureFile(filename);
        String content = (line == null ? "" : line) + System.lineSeparator();

        Files.write(
                file,
                content.getBytes(StandardCharsets.UTF_8),
                StandardOpenOption.CREATE,
                StandardOpenOption.APPEND
        );
    }

    // 🔹 Get absolute file path (debug/useful)
    public static String getPath(String filename) throws IOException {
        return ensureFile(filename).toString();
    }

    // 🔹 Get base directory path
    public static String getBaseDir() {
        ensureInit();
        return baseDir.toString();
    }
}
