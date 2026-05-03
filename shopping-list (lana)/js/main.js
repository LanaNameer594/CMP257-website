document.addEventListener("DOMContentLoaded", function () {
    loadShoppingList();
    toggleClearButton();

    const clearBtn = document.getElementById("clear-list-btn");
    if (clearBtn) {
        clearBtn.addEventListener("click", clearShoppingList);
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
        imageId: "baske-seeds",
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
    const allBasketImages = document.querySelectorAll(".basket-container .item");

    allBasketImages.forEach(function (img) {
        img.style.display = "none";
    });
}

function showBasketImageForIngredient(ingredientName) {
    const normalizedIngredient = normalizeText(ingredientName);

    ingredientImageKeywords.forEach(function (mapping) {
        const matched = mapping.keywords.some(function (keyword) {
            const normalizedKeyword = normalizeText(keyword);
            return normalizedIngredient.includes(normalizedKeyword);
        });

        if (matched) {
            const image = document.getElementById(mapping.imageId);

            if (image) {
                image.style.display = "block";
            }
        }
    });
}

function updateBasketImages(items) {
    hideAllBasketImages();

    if (!items || items.length === 0) {
        return;
    }

    items.forEach(function (item) {
        showBasketImageForIngredient(item.name);
    });
}

function toggleClearButton() {
    const clearBtn = document.getElementById("clear-list-btn");
    const listBody = document.getElementById("shopping-list-body");

    if (!clearBtn || !listBody) {
        return;
    }

    if (
        listBody.children.length === 0 ||
        listBody.innerHTML.toLowerCase().includes("empty")
    ) {
        clearBtn.style.display = "none";
    } else {
        clearBtn.style.display = "block";
    }
}

function showEmptyListMessage(listBody) {
    if (!listBody) {
        return;
    }

    listBody.innerHTML = `
        <tr>
            <td colspan="3" class="text-center">Your shopping list is empty.</td>
        </tr>
    `;

    hideAllBasketImages();
}

function loadShoppingList() {
    const listBody = document.getElementById("shopping-list-body");
    const storedList = sessionStorage.getItem("guest_shopping_list");

    if (!listBody) {
        return;
    }

    hideAllBasketImages();

    if (storedList) {
        try {
            const items = JSON.parse(storedList);

            if (items && items.length > 0) {
                listBody.innerHTML = "";

                items.forEach(function (item) {
                    const row = document.createElement("tr");

                    row.innerHTML = `
                        <td class="begin">${item.quantity || 1}</td>
                        <td>${item.name || ""}</td>
                        <td class="length">${item.amount || "0.00"}</td>
                    `;

                    listBody.appendChild(row);
                });

                updateBasketImages(items);
            } else {
                showEmptyListMessage(listBody);
            }
        } catch (e) {
            console.error("Failed to parse shopping list:", e);
            showEmptyListMessage(listBody);
        }
    } else {
        showEmptyListMessage(listBody);
    }

    toggleClearButton();
}

function clearShoppingList() {
    fetch("../DeleteFromShoppingListServlet", {
        method: "POST"
    })
        .then(function (response) {
            if (response.ok) {
                sessionStorage.removeItem("guest_shopping_list");

                const listBody = document.getElementById("shopping-list-body");
                showEmptyListMessage(listBody);

                toggleClearButton();
            } else {
                console.error("Failed to clear list on the server.");
            }
        })
        .catch(function (error) {
            console.error("Error clearing shopping list:", error);

            sessionStorage.removeItem("guest_shopping_list");

            const listBody = document.getElementById("shopping-list-body");
            showEmptyListMessage(listBody);

            toggleClearButton();
        });
}