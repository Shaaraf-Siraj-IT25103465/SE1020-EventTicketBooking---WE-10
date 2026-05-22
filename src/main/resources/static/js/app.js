const API_BASE = '/api/venues';
let currentMode = 'add';

document.addEventListener('DOMContentLoaded', () => {
    fetchVenues();

    document.getElementById('venueForm').addEventListener('submit', handleFormSubmit);
});

async function fetchVenues() {
    try {
        const response = await fetch(API_BASE);
        const venues = await response.json();
        renderTable(venues);
    } catch (error) {
        showNotification('Error fetching venues', 'danger');
    }
}

function renderTable(venues) {
    const tbody = document.getElementById('venueTableBody');
    tbody.innerHTML = '';

    venues.forEach(venue => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>#${venue.id}</td>
            <td style="font-weight: 600;">${venue.name}</td>
            <td>${venue.location}</td>
            <td>${venue.capacity}</td>
            <td><span class="badge badge-${venue.status.toLowerCase()}">${venue.status}</span></td>
            <td>
                <div class="actions">
                    <button class="action-btn edit-btn" onclick="openEditModal(${JSON.stringify(venue).replace(/"/g, '&quot;')})">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="action-btn delete-btn" onclick="deleteVenue(${venue.id})">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

async function handleFormSubmit(e) {
    e.preventDefault();
    
    const venueData = {
        name: document.getElementById('name').value,
        location: document.getElementById('location').value,
        capacity: parseInt(document.getElementById('capacity').value),
        description: document.getElementById('description').value,
        status: document.getElementById('status').value
    };

    const id = document.getElementById('venueId').value;
    const url = currentMode === 'edit' ? `${API_BASE}/${id}` : API_BASE;
    const method = currentMode === 'edit' ? 'PUT' : 'POST';

    try {
        const response = await fetch(url, {
            method: method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(venueData)
        });

        if (response.ok) {
            showNotification(`Venue ${currentMode === 'edit' ? 'updated' : 'added'} successfully`, 'success');
            closeModal();
            fetchVenues();
        }
    } catch (error) {
        showNotification('Error saving venue', 'danger');
    }
}

async function deleteVenue(id) {
    if (!confirm('Are you sure you want to delete this venue?')) return;

    try {
        const response = await fetch(`${API_BASE}/${id}`, { method: 'DELETE' });
        if (response.ok) {
            showNotification('Venue deleted successfully', 'success');
            fetchVenues();
        }
    } catch (error) {
        showNotification('Error deleting venue', 'danger');
    }
}

async function handleSearch() {
    const name = document.getElementById('searchName').value;
    const location = document.getElementById('searchLocation').value;

    try {
        const response = await fetch(`${API_BASE}/search?name=${encodeURIComponent(name)}&location=${encodeURIComponent(location)}`);
        const venues = await response.json();
        renderTable(venues);
    } catch (error) {
        console.error('Search failed', error);
    }
}

function clearSearch() {
    document.getElementById('searchName').value = '';
    document.getElementById('searchLocation').value = '';
    fetchVenues();
}

function openModal(mode) {
    currentMode = mode;
    document.getElementById('modalTitle').innerText = mode === 'add' ? 'Add New Venue' : 'Edit Venue';
    document.getElementById('venueForm').reset();
    document.getElementById('venueId').value = '';
    document.getElementById('venueModal').classList.add('active');
}

function openEditModal(venue) {
    openModal('edit');
    document.getElementById('venueId').value = venue.id;
    document.getElementById('name').value = venue.name;
    document.getElementById('location').value = venue.location;
    document.getElementById('capacity').value = venue.capacity;
    document.getElementById('description').value = venue.description;
    document.getElementById('status').value = venue.status;
}

function closeModal() {
    document.getElementById('venueModal').classList.remove('active');
}

function showNotification(message, type) {
    const notification = document.getElementById('notification');
    notification.innerText = message;
    notification.style.backgroundColor = type === 'success' ? 'var(--success)' : 'var(--danger)';
    notification.style.display = 'block';
    
    setTimeout(() => {
        notification.style.display = 'none';
    }, 3000);
}
