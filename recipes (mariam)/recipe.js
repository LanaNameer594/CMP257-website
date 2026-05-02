// --- Element Selection ---
var searchBtn = document.getElementById("search-btn");
var searchModal = document.getElementById("pickModal"); 
var recipeModal = document.getElementById("recipeModal"); 
var closeSearchBtn = document.querySelector(".modal-close");
var closeRecipeBtn = document.querySelector(".close-btn");
var searchForm = document.getElementById("search-form");
var imageGrid = document.querySelector(".image-grid");
var tags = document.querySelectorAll(".keyword-tag");

// --- Modal Controls ---
function openSearchModal() {
    searchModal.classList.add("active");
    document.body.style.overflow = "hidden";
}

function closeSearchModal() {
    searchModal.classList.remove("active");
    document.body.style.overflow = "";
}

function closeRecipeModal() {
    recipeModal.style.display = "none";
    document.body.style.overflow = "";
}

if (searchBtn) {
    searchBtn.addEventListener("click", openSearchModal);
}
if (closeSearchBtn) {
    closeSearchBtn.addEventListener("click", closeSearchModal);
}
if (closeRecipeBtn) {
    closeRecipeBtn.addEventListener("click", closeRecipeModal);
}

// --- Tag Selection ---
if (tags) {
    tags.forEach(function(tag) {
        tag.addEventListener("click", function() {
            // Remove active class from all tags
            tags.forEach(function(t) {
                t.classList.remove("active");
            });
            // Add active class to the selected tag
            this.classList.add("active");
        });
    });
}

// Close on background click
window.onclick = function(event) {
    if (event.target == recipeModal) {
        closeRecipeModal();
    }
    if (event.target == searchModal) {
        closeSearchModal();
    }
};

// --- Search Implementation ---
if (searchForm) {
    searchForm.addEventListener("submit", function(e) {
        e.preventDefault();
        
        var queryInput = document.getElementById("search-input");
        var query = queryInput ? queryInput.value : "";
        
        var activeTagElement = document.querySelector(".keyword-tag.active");
        var activeTag = activeTagElement ? activeTagElement.innerText : "";

        var url = 'RecipeSearch?q=' + encodeURIComponent(query) + '&tag=' + encodeURIComponent(activeTag);

        fetch(url)
            .then(function(response) {
                return response.json();
            })
            .then(function(recipes) {
                if (imageGrid) {
                    imageGrid.innerHTML = ""; 

                    if (recipes.length === 0) {
                        imageGrid.innerHTML = "<p style='color:white; grid-column: 1/-1; text-align:center;'>No recipes found.</p>";
                    }

                    recipes.forEach(function(recipe) {
                        var card = document.createElement("div");
                        card.className = "card";
                        
                        // Fallback image if not provided by JSON
                        var imgUrl = recipe.image ? recipe.image : 'rpics/p1.png';
                        
                        // Generate card structure
                        card.innerHTML = 
                            '<img src="' + imgUrl + '" class="grid-pic" alt="' + recipe.name + '">' +
                            '<div class="overlay">' +
                                '<p class="overlay-text" style="color: white; padding: 10px; text-align: center;">' + recipe.name + '</p>' +
                            '</div>';
                        
                        card.addEventListener("click", function() {
                            showFullRecipe(recipe);
                        });
                        
                        imageGrid.appendChild(card);
                    });
                }
                closeSearchModal(); 
            })
            .catch(function(err) {
                console.error("Search failed:", err);
            });
    });
}

// --- UI Display ---
function showFullRecipe(recipe) {
    var body = document.getElementById("modalBody");
    var imgUrl = recipe.image ? recipe.image : 'rpics/p1.png';

    // Parse ingredients and their IDs
    var ingredientNames = recipe.ingredients.split(', ');
    var ingredientIds = recipe.ingredientIds ? recipe.ingredientIds.split(',') : [];
    var ingredientCheckboxes = '';

    for (var i = 0; i < ingredientNames.length; i++) {
        var id = ingredientIds[i] ? ingredientIds[i] : "";
        var name = ingredientNames[i];
        
        ingredientCheckboxes += 
            '<div class="form-check">' +
                '<input class="form-check-input" type="checkbox" value="' + id + '" id="ing_' + id + '" name="shopping_ingredients">' +
                '<label class="form-check-label" for="ing_' + id + '">' + name + '</label>' +
            '</div>';
    }

    if (body) {
        body.innerHTML = 
            '<h1 class="recipe-header">' + recipe.name + '</h1>' +
            '<div class="recipe-split">' +
                '<img src="' + imgUrl + '" class="recipe-info-img" alt="' + recipe.name + '">' +
                '<div class="recipe-details">' +
                    '<h3>Prep Time</h3>' +
                    '<p>' + recipe.prepTime + '</p>' +
                    '<h3>Nutrition Facts</h3>' +
                    '<p>' + recipe.nutrition + '</p>' +
                    '<h3>Ingredients</h3>' +
                    '<form id="shopping-form">' + 
                        ingredientCheckboxes +
                        '<br>' +
                        '<button type="button" class="btn btn-success btn-sm" onclick="saveToShoppingList()">Add Selected to Shopping List</button>' +
                    '</form>' +
                '</div>' +
            '</div>' +
            '<div style="margin-top: 30px;">' +
                '<h3>Instructions</h3>' +
                '<p class="instruction-text">' + recipe.instructions + '</p>' +
            '</div>';
    }

    if (recipeModal) {
        recipeModal.style.display = "block";
        document.body.style.overflow = "hidden";
    }
}

// --- Shopping List Form Submission ---
window.saveToShoppingList = function() {
    var checkedBoxes = document.querySelectorAll('input[name="shopping_ingredients"]:checked');
    
    if (checkedBoxes.length === 0) {
        alert("Please select at least one ingredient to add.");
        return;
    }

    var params = [];
    checkedBoxes.forEach(function(box) {
        params.push('shopping_ingredients=' + encodeURIComponent(box.value));
    });

    fetch('ShoppingListServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params.join('&')
    })
    .then(function(response) {
        if (response.status === 401 || !response.ok) {
            throw new Error('User not logged in or server error');
        }
        return response.json();
    })
    .then(function(data) {
        if (data.status === "success") {
            alert("Selected ingredients added to your shopping list!");
            document.querySelectorAll('input[name="shopping_ingredients"]').forEach(function(cb) {
                cb.checked = false;
            });
        } else {
            alert("Failed to add: " + data.message);
        }
    })
    .catch(function(err) {
        console.warn("Backend rejected/user not logged in. Using guest storage fallback:", err);
        
        let shoppingListItems = JSON.parse(sessionStorage.getItem('guest_shopping_list')) || [];

        checkedBoxes.forEach(function(box) {
            var label = document.querySelector('label[for="' + box.id + '"]').textContent;
            var parts = label.trim().split(/\s+/);

            var quantity = 1;
            var unit = '';
            var name = '';

            if (!isNaN(parts[0])) {
                quantity = parseFloat(parts[0]);
                unit = parts[1] || '';
                name = parts.slice(2).join(' ') || '';
            } else {
                name = parts.join(' ');
            }

            if (!name) {
                name = label;
            }

            var newItem = {
                name: name,
                quantity: quantity,
                unit: unit,
                is_checked: false
            };

            const existingIndex = shoppingListItems.findIndex(
                (i) => i.name === newItem.name && i.unit === newItem.unit
            );

            if (existingIndex !== -1) {
                shoppingListItems[existingIndex].quantity += newItem.quantity;
            } else {
                shoppingListItems.push(newItem);
            }
        });

        sessionStorage.setItem('guest_shopping_list', JSON.stringify(shoppingListItems));
        alert("Item(s) added to guest shopping list!");

        document.querySelectorAll('input[name="shopping_ingredients"]').forEach(function(cb) {
            cb.checked = false;
        });
    });
};