const url = "http://localhost:8080/api/transactions";

function createTransaction() {
    const data = {
        eventId: document.getElementById("eventId").value,
        customerName: document.getElementById("customerName").value,
        amount: parseFloat(document.getElementById("amount").value),
        transactionType: document.getElementById("transactionType").value
    };

    fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(data)
    })
    .then(res => res.json())
    .then(d => {
        alert("Payment Successful! ID: " + d.transactionId);
        loadTransactions();
    });
}

function loadTransactions() {
    fetch(url)
    .then(res => res.json())
    .then(data => {
        const table = document.getElementById("tableBody");
        table.innerHTML = "";

        data.forEach(t => {
            table.innerHTML += `
                <tr>
                    <td>${t.transactionId}</td>
                    <td>${t.customerName}</td>
                    <td>${t.amount} LKR</td>
                    <td>${t.transactionType}</td>
                    <td>
                        <button onclick="deleteTransaction('${t.transactionId}')">Delete</button>
                    </td>
                </tr>
            `;
        });
    });
}

function deleteTransaction(id) {
    fetch(url + "/" + id, {
        method: "DELETE"
    })
    .then(() => {
        alert("Deleted!");
        loadTransactions();
    });
}

window.onload = loadTransactions;