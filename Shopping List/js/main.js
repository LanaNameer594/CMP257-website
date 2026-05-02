document.addEventListener("DOMContentLoaded", function() {
    // Load existing list items and update button state
    loadShoppingList();
    toggleClearButton();
});

// Function to show or hide the Clear List button
function toggleClearButton() {
    const clearBtn = document.getElementById('clear-list-btn');
    const listBody = document.getElementById('shopping-list-body');
    
    // Check if the list is empty or contains the default "Your shopping list is empty" text
    if (!listBody || listBody.children.length === 0 || listBody.innerHTML.includes('empty')) {
        clearBtn.style.display = 'none';
    } else {
        clearBtn.style.display = 'block'; // or 'inline-block' depending on your styling
    }
}

// Function to load items onto the screen
function loadShoppingList() {
    const listBody = document.getElementById('shopping-list-body');
    const storedList = sessionStorage.getItem('guest_shopping_list');

    if (storedList) {
        try {
            const items = JSON.parse(storedList);
            if (items && items.length > 0) {
                listBody.innerHTML = '';
                items.forEach(item => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td class="begin">${item.quantity || 1}</td>
                        <td>${item.name}</td>
                        <td class="length">${item.amount || '0.00'}</td>
                    `;
                    listBody.appendChild(row);

                    // Show associated basket image if it exists
                    const itemImg = document.getElementById(`basket-${item.name.toLowerCase()}`);
                    if (itemImg) {
                        itemImg.style.display = 'block';
                    }
                });
            } else {
                listBody.innerHTML = `
                    <tr>
                        <td colspan="3" class="text-center">Your shopping list is empty.</td>
                    </tr>`;
            }
        } catch (e) {
            listBody.innerHTML = `
                <tr>
                    <td colspan="3" class="text-center">Your shopping list is empty.</td>
                </tr>`;
        }
    } else {
        listBody.innerHTML = `
            <tr>
                <td colspan="3" class="text-center">Your shopping list is empty.</td>
            </tr>`;
    }
}

// Event Listener for the Clear List button
document.getElementById('clear-list-btn').addEventListener('click', function() {
    fetch('DeleteFromShoppingListServlet', {
        method: 'POST'
    })
    .then(response => {
        if (response.ok) {
            // 1. Clear frontend sessionStorage
            sessionStorage.removeItem('guest_shopping_list');
            
            // 2. Clear the table UI visually
            const listBody = document.getElementById('shopping-list-body');
            listBody.innerHTML = `
                <tr>
                    <td colspan="3" class="text-center">Your shopping list is empty.</td>
                </tr>`;

            // 3. Hide all basket images
            const allBasketImages = document.querySelectorAll('.basket-container .item');
            allBasketImages.forEach(img => {
                img.style.display = 'none';
            });

            // 4. Hide the button once cleared
            toggleClearButton();
        } else {
            console.error("Failed to clear list on the server.");
        }
    })
    .catch(error => console.error('Error clearing shopping list:', error));
});