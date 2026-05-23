package com.example.paymentlog.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Transaction {

    private String transactionId;
    private String eventId;
    private String customerName;
    private BigDecimal amount;
    private String currency;
    private TransactionType transactionType;
    private TransactionStatus status;
    private LocalDateTime transactionDateTime;

    public Transaction() {
    }

    public Transaction(String transactionId,
                       String eventId,
                       String customerName,
                       BigDecimal amount,
                       String currency,
                       TransactionType transactionType,
                       TransactionStatus status,
                       LocalDateTime transactionDateTime) {
        this.transactionId = transactionId;
        this.eventId = eventId;
        this.customerName = customerName;
        this.amount = amount;
        this.currency = currency;
        this.transactionType = transactionType;
        this.status = status;
        this.transactionDateTime = transactionDateTime;
    }

   //Getters

    public String getTransactionId() {
        return transactionId;
    }

    public String getEventId() {
        return eventId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public String getCurrency() {
        return currency;
    }

    public TransactionType getTransactionType() {
        return transactionType;
    }

    public TransactionStatus getStatus() {
        return status;
    }

    public LocalDateTime getTransactionDateTime() {
        return transactionDateTime;
    }

    //Setters


    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public void setTransactionType(TransactionType transactionType) {
        this.transactionType = transactionType;
    }

    public void setStatus(TransactionStatus status) {
        this.status = status;
    }

    public void setTransactionDateTime(LocalDateTime transactionDateTime) {
        this.transactionDateTime = transactionDateTime;
    }
}