package com.example.paymentlog.service;

import com.example.paymentlog.dto.TransactionRequest;
import com.example.paymentlog.model.Transaction;
import java.util.List;

public interface TransactionService {

    Transaction createTransaction(TransactionRequest request);

    List<Transaction> getAllTransactions();

    Transaction getTransactionById(String transactionId);

    void deleteTransaction(String transactionId);
}