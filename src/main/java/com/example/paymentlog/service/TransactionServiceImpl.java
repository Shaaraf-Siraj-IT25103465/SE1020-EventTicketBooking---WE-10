package com.example.paymentlog.service;

import com.example.paymentlog.dto.TransactionRequest;
import com.example.paymentlog.model.Transaction;
import com.example.paymentlog.model.TransactionStatus;
import com.example.paymentlog.repository.FileTransactionRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class TransactionServiceImpl implements TransactionService {

    private static final String CURRENCY = "LKR";

    private final FileTransactionRepository transactionRepository;

    public TransactionServiceImpl(FileTransactionRepository transactionRepository) {
        this.transactionRepository = transactionRepository;
    }

    @Override
    public Transaction createTransaction(TransactionRequest request) {

        Transaction transaction = new Transaction();

        transaction.setTransactionId(generateTransactionId());
        transaction.setEventId(request.getEventId());
        transaction.setCustomerName(request.getCustomerName());
        transaction.setAmount(request.getAmount());
        transaction.setCurrency(CURRENCY);
        transaction.setTransactionType(request.getTransactionType());
        transaction.setStatus(TransactionStatus.SUCCESS);
        transaction.setTransactionDateTime(LocalDateTime.now());

        transactionRepository.save(transaction);

        return transaction;
    }

    @Override
    public List<Transaction> getAllTransactions() {
        return transactionRepository.findAll();
    }

    @Override
    public Transaction getTransactionById(String transactionId) {
        return transactionRepository.findById(transactionId)
                .orElseThrow(() -> new RuntimeException("Transaction not found: " + transactionId));
    }

    private String generateTransactionId() {
        return "TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
    @Override
    public void deleteTransaction(String transactionId) {
        transactionRepository.delete(transactionId);
    }
}