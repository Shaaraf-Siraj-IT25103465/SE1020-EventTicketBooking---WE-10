package com.example.paymentlog.repository;

import com.example.paymentlog.model.Transaction;
import com.example.paymentlog.model.TransactionStatus;
import com.example.paymentlog.model.TransactionType;
import org.springframework.stereotype.Repository;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class FileTransactionRepository {

    private final Path filePath = Paths.get(System.getProperty("user.dir"), "transactions.csv");

    public FileTransactionRepository() {
        createFileIfNotExists();
    }

    private void createFileIfNotExists() {
        try {
            if (!Files.exists(filePath)) {
                Files.createFile(filePath);

                try (BufferedWriter writer = Files.newBufferedWriter(filePath, StandardOpenOption.APPEND)) {
                    writer.write("transactionId,eventId,customerName,amount,currency,transactionType,status,transactionDateTime");
                    writer.newLine();
                }
            }
        } catch (IOException e) {
            throw new RuntimeException("Could not create transaction file", e);
        }
    }

    public synchronized void save(Transaction transaction) {
        try (BufferedWriter writer = Files.newBufferedWriter(filePath, StandardOpenOption.APPEND)) {

            writer.write(convertTransactionToCsv(transaction));
            writer.newLine();

        } catch (IOException e) {
            throw new RuntimeException("Could not save transaction", e);
        }
    }

    public List<Transaction> findAll() {
        List<Transaction> transactions = new ArrayList<>();

        try (BufferedReader reader = Files.newBufferedReader(filePath)) {

            String line;
            boolean isHeader = true;

            while ((line = reader.readLine()) != null) {

                if (isHeader) {
                    isHeader = false;
                    continue;
                }

                if (!line.trim().isEmpty()) {
                    transactions.add(convertCsvToTransaction(line));
                }
            }

        } catch (IOException e) {
            throw new RuntimeException("Could not read transactions", e);
        }

        return transactions;
    }

    public Optional<Transaction> findById(String transactionId) {
        return findAll()
                .stream()
                .filter(transaction -> transaction.getTransactionId().equals(transactionId))
                .findFirst();
    }

    private String convertTransactionToCsv(Transaction transaction) {
        return transaction.getTransactionId() + "," +
                transaction.getEventId() + "," +
                transaction.getCustomerName() + "," +
                transaction.getAmount() + "," +
                transaction.getCurrency() + "," +
                transaction.getTransactionType() + "," +
                transaction.getStatus() + "," +
                transaction.getTransactionDateTime();
    }

    private Transaction convertCsvToTransaction(String csvLine) {
        String[] data = csvLine.split(",");

        return new Transaction(
                data[0],
                data[1],
                data[2],
                new BigDecimal(data[3]),
                data[4],
                TransactionType.valueOf(data[5]),
                TransactionStatus.valueOf(data[6]),
                LocalDateTime.parse(data[7])
        );
    }
    public void delete(String id) {
        List<Transaction> list = findAll();

        list.removeIf(t -> t.getTransactionId().equals(id));

        try (BufferedWriter writer = Files.newBufferedWriter(filePath, StandardOpenOption.TRUNCATE_EXISTING)) {
            writer.write("transactionId,eventId,customerName,amount,currency,transactionType,status,transactionDateTime");
            writer.newLine();

            for (Transaction t : list) {
                writer.write(convertTransactionToCsv(t));
                writer.newLine();
            }

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}