
document.addEventListener('DOMContentLoaded', () => {
    // get ul
    const clientsList = document.getElementById('clients');

    // get form
    const addForm = document.getElementById('addForm');

    // get input
    const nameInput = document.getElementById('nameInput');

    // div message
    const message = document.getElementById('message');

    // fetch clients
    async function fetchClients() {
        try {
            // fetch clients
            const res = await fetch('php/clients.php');
            const data = await res.json();

            // afficher clients
            renderClients(data);
        } catch (err) {
            message.textContent = 'Failed to load clients.';
        }
    }

    // afficher clients
    function renderClients(clients) {
        // vider ul
        clientsList.innerHTML = '';

        // if no clients then show no clients message
        if (!clients || clients.length === 0) {
            clientsList.innerHTML = '<li>No clients yet.</li>';
            return;
        }

        // liste clients
        clients.forEach((c, i) => {
            const li = document.createElement('li');
            li.textContent = c.name || '(no name)';

            const del = document.createElement('button');
            del.textContent = 'Delete';
            del.style.marginLeft = '8px';
            del.addEventListener('click', () => deleteClient(i));

            li.appendChild(del);
            clientsList.appendChild(li);
        });
    }

    async function addClient(name) {
        try {
            const body = new URLSearchParams();
            body.append('name', name);

            const res = await fetch('php/add_client.php', {
                method: 'POST',
                body,
            });
            const json = await res.json();
            if (json.success) {
                message.textContent = 'Client added.';
                nameInput.value = '';
                renderClients(json.data);
            } else {
                message.textContent = json.message || 'Failed to add client.';
            }
        } catch (err) {
            message.textContent = 'Failed to add client.';
        }
    }

    async function deleteClient(index) {
        if (!confirm('Delete this client?')) return;
        try {
            const body = new URLSearchParams();
            body.append('index', index);

            const res = await fetch('php/delete_client.php', {
                method: 'POST',
                body,
            });
            const json = await res.json();
            if (json.success) {
                message.textContent = 'Client deleted.';
                renderClients(json.data);
            } else {
                message.textContent = json.message || 'Failed to delete client.';
            }
        } catch (err) {
            message.textContent = 'Failed to delete client.';
        }
    }

    addForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const name = nameInput.value.trim();
        if (!name) return;
        addClient(name);
    });

    fetchClients();
});