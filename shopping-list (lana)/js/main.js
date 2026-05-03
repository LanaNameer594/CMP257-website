document.addEventListener("DOMContentLoaded", function() {
    loadShoppingList();

    const clearBtn = document.getElementById('clear-list-btn');
    const downloadBtn = document.getElementById('download-list-btn');

    if (clearBtn) {
        clearBtn.addEventListener('click', clearShoppingList);
    }

    if (downloadBtn) {
        downloadBtn.addEventListener('click', downloadShoppingList);
    }
});

const ingredientImageKeywords = [
    {
        imageId: "basket-almonds",
        keywords: ["almond", "almonds"]
    },
    {
        imageId: "basket-liqueur",
        keywords: ["amaretto", "liqueur", "amaretto liqueur"]
    },
    {
        imageId: "basket-vinegar",
        keywords: ["vinegar", "apple cider vinegar", "cider vinegar"]
    },
    {
        imageId: "basket-brandy",
        keywords: ["brandy", "apricot brandy"]
    },
    {
        imageId: "basket-apricot",
        keywords: ["apricot", "apricots", "apricot preserves", "apricot glaze"]
    },
    {
        imageId: "basket-avocado",
        keywords: ["avocado", "avocados"]
    },
    {
        imageId: "basket-baking-powder",
        keywords: ["baking powder"]
    },
    {
        imageId: "basket-beans",
        keywords: ["bean", "beans", "black beans", "kidney beans", "refried beans"]
    },
    {
        imageId: "basket-blueberries",
        keywords: ["blueberry", "blueberries"]
    },
    {
        imageId: "basket-bread",
        keywords: ["bread", "toast", "bun", "buns", "roll", "rolls"]
    },
    {
        imageId: "basket-cheese",
        keywords: ["cheese", "cheddar", "mozzarella", "parmesan", "american cheese"]
    },
    {
        imageId: "basket-cherries",
        keywords: ["cherry", "cherries", "fresh cherries", "preserved cherries"]
    },
    {
        imageId: "basket-chicken",
        keywords: ["chicken", "chicken thigh", "chicken thighs", "chicken breast", "chicken breasts"]
    },
    {
        imageId: "basket-cornstarch",
        keywords: ["cornstarch", "corn starch"]
    },
    {
        imageId: "basket-eggs",
        keywords: ["egg", "eggs"]
    },
    {
        imageId: "basket-flour",
        keywords: ["flour", "all-purpose flour", "all purpose flour", "bread flour"]
    },
    {
        imageId: "basket-rosemary",
        keywords: ["rosemary", "fresh rosemary", "rosemary sprig", "rosemary sprigs"]
    },
    {
        imageId: "basket-kiwis",
        keywords: ["kiwi", "kiwis", "kiwifruit"]
    },
    {
        imageId: "basket-lime-juice",
        keywords: ["lime juice", "lime", "limes"]
    },
    {
        imageId: "basket-rice",
        keywords: ["rice", "long-grain rice", "long grain rice", "basmati", "jasmine rice"]
    },
    {
        imageId: "basket-nectar",
        keywords: ["nectar", "agave nectar", "fruit nectar"]
    },
    {
        imageId: "basket-olives",
        keywords: ["olive", "olives", "black olives", "green olives"]
    },
    {
        imageId: "basket-orange",
        keywords: ["orange", "oranges", "orange juice", "orange zest", "orange bell pepper"]
    },
    {
        imageId: "basket-peach",
        keywords: ["peach", "peaches", "fresh peach", "peach schnapps"]
    },
    {
        imageId: "basket-persimmon",
        keywords: ["persimmon", "persimmons"]
    },
    {
        imageId: "basket-pineapple",
        keywords: ["pineapple", "pineapples"]
    },
    {
        imageId: "basket-pomegranate-juice",
        keywords: ["pomegranate juice"]
    },
    {
        imageId: "basket-seeds",
        keywords: ["pomegranate seeds", "pomegranate seed"]
    },
    {
        imageId: "basket-porkchops",
        keywords: ["pork", "porkchop", "porkchops", "pork chop", "pork chops"]
    },
    {
        imageId: "basket-saffron",
        keywords: ["saffron", "saffron threads"]
    },
    {
        imageId: "basket-steak",
        keywords: ["steak", "beef", "beef skirt steak", "skirt steak"]
    },
    {
        imageId: "basket-strawberries",
        keywords: ["strawberry", "strawberries"]
    }
];

function normalizeText(value) {
    return String(value || "")
        .toLowerCase()
        .replace(/[^a-z0-9\s-]/g, " ")
        .replace(/-/g, " ")
        .replace(/\s+/g, " ")
        .trim();
}

function hideAllBasketImages() {
    const allBasketImages = document.querySelectorAll('.basket-container .item');

    allBasketImages.forEach(function(img) {
        img.style.display = 'none';
    });
}

function showBasketImageForIngredient(ingredientName) {
    const normalizedIngredient = normalizeText(ingredientName);

    ingredientImageKeywords.forEach(function(mapping) {
        const matched = mapping.keywords.some(function(keyword) {
            const normalizedKeyword = normalizeText(keyword);
            return normalizedIngredient.includes(normalizedKeyword);
        });

        if (matched) {
            const image = document.getElementById(mapping.imageId);

            if (image) {
                image.style.display = 'block';
            }
        }
    });
}

function updateBasketImages(items) {
    hideAllBasketImages();

    if (!items || items.length === 0) {
        return;
    }

    items.forEach(function(item) {
        showBasketImageForIngredient(item.name);
    });
}

function toggleButtons() {
    const clearBtn = document.getElementById('clear-list-btn');
    const downloadBtn = document.getElementById('download-list-btn');
    const listBody = document.getElementById('shopping-list-body');

    if (!clearBtn || !downloadBtn || !listBody) {
        return;
    }
    
    if (
        listBody.children.length === 0 ||
        listBody.innerHTML.toLowerCase().includes('empty')
    ) {
        clearBtn.style.display = 'none';
        downloadBtn.style.display = 'none';
    } else {
        clearBtn.style.display = 'inline-block';
        downloadBtn.style.display = 'inline-block';
    }
}

// 1. Check database first. If not logged in, check session storage.
function loadShoppingList() {
    const listBody = document.getElementById('shopping-list-body');

    if (!listBody) {
        return;
    }

    hideAllBasketImages();

    fetch('../ShoppingListController')
        .then(function(response) {
            if (response.ok) {
                const userName = response.headers.get("X-User-Name") || "Member";
                setReceiptInfo(userName);
                return response.json();
            } else if (response.status === 401) {
                setReceiptInfo("Guest");
                return null;
            }

            throw new Error('Failed to fetch from DB');
        })
        .then(function(dbItems) {
            if (dbItems) {
                renderItems(dbItems, listBody);
            } else {
                loadFromSessionStorage(listBody);
            }
        })
        .catch(function(error) {
            console.error("Error loading shopping list:", error);
            setReceiptInfo("Guest");
            loadFromSessionStorage(listBody);
        });
}

// 2. Helper to load from Session Storage
function loadFromSessionStorage(listBody) {
    const storedList = sessionStorage.getItem('guest_shopping_list');

    if (storedList) {
        try {
            const items = JSON.parse(storedList);
            renderItems(items, listBody);
        } catch (e) {
            console.error("Failed to parse guest shopping list:", e);
            renderEmpty(listBody);
        }
    } else {
        renderEmpty(listBody);
    }
}

// 3. Render the items to the screen
function renderItems(items, listBody) {
    hideAllBasketImages();

    if (items && items.length > 0) {
        listBody.innerHTML = '';

        items.forEach(function(item) {
            const row = document.createElement('tr');

            row.innerHTML = `
                <td class="begin">${item.quantity || 1}</td>
                <td>${item.name || ''}</td>
                <td class="length">${item.unit || ''}</td>
            `;

            listBody.appendChild(row);
        });

        updateBasketImages(items);
        toggleButtons();
    } else {
        renderEmpty(listBody);
    }
}

function setReceiptInfo(shopperName) {
    const dateElement = document.getElementById('receipt-date');
    const nameElement = document.getElementById('receipt-name');
    
    if (dateElement) {
        const today = new Date();
        const formattedDate = today.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });

        dateElement.innerText = `DATE: ${formattedDate}`;
    }
    
    if (nameElement) {
        nameElement.innerText = `NAME: ${shopperName}`;
    }
}

// 4. Helper to display an empty list
function renderEmpty(listBody) {
    if (!listBody) {
        return;
    }

    listBody.innerHTML = `
        <tr>
            <td colspan="3" class="text-center">Your shopping list is empty.</td>
        </tr>
    `;

    hideAllBasketImages();
    toggleButtons();
}

// Clear Button Logic
function clearShoppingList() {
    fetch('../ShoppingListController', { method: 'DELETE' })
        .then(function(response) {
            sessionStorage.removeItem('guest_shopping_list');
            
            const listBody = document.getElementById('shopping-list-body');
            renderEmpty(listBody);
        })
        .catch(function(error) {
            console.error('Error clearing shopping list:', error);

            sessionStorage.removeItem('guest_shopping_list');

            const listBody = document.getElementById('shopping-list-body');
            renderEmpty(listBody);
        });
}

// Download Button Logic
function downloadShoppingList() {
    const listBody = document.getElementById('shopping-list-body');

    if (!listBody) {
        return;
    }

    const rows = listBody.querySelectorAll('tr');
    
    if (rows.length > 0 && !listBody.innerHTML.toLowerCase().includes('empty')) {
        let fileText = "MY SHOPPING LIST\n";
        fileText += "================\n\n";
        
        rows.forEach(function(row) {
            const cells = row.querySelectorAll('td');

            if (cells.length === 3) {
                const qty = cells[0].innerText.trim();
                const name = cells[1].innerText.trim();
                const unit = cells[2].innerText.trim();

                fileText += `- ${qty}x ${name} (${unit})\n`;
            }
        });
        
        const blob = new Blob([fileText], { type: "text/plain" });
        const link = document.createElement("a");

        link.href = URL.createObjectURL(blob);
        link.download = "Shopping_List.txt";
        
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        
        URL.revokeObjectURL(link.href);
    }
}