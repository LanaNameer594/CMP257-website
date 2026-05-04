var searchBtn = document.getElementById("search-btn");
var searchModal = document.getElementById("pickModal"); 
var recipeModal = document.getElementById("recipeModal"); 
var closeSearchBtn = document.querySelector(".modal-close");
var closeRecipeBtn = document.querySelector(".close-btn");
var searchForm = document.getElementById("search-form");
var imageGrid = document.querySelector(".image-grid");
var tags = document.querySelectorAll(".keyword-tag");
var resultsHeader = document.getElementById("results-header");

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

function escapeHTML(value) {
    if (value === null || value === undefined) {
        return "";
    }

    return String(value)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}

function shuffleRecipes(recipes) {
    var copy = recipes.slice();

    for (var i = copy.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = copy[i];
        copy[i] = copy[j];
        copy[j] = temp;
    }

    return copy;
}

function renderRecipeCards(recipes, heading, subheading, limit) {
    if (!imageGrid) {
        return;
    }

    imageGrid.innerHTML = "";

    if (resultsHeader) {
        resultsHeader.innerHTML =
            '<h2>' + escapeHTML(heading) + '</h2>' +
            '<p>' + escapeHTML(subheading) + '</p>';
    }

    if (!recipes || recipes.length === 0) {
        imageGrid.innerHTML =
            '<p class="no-results-message">No recipes found.</p>';
        return;
    }

    var recipesToShow = limit ? recipes.slice(0, limit) : recipes;

    recipesToShow.forEach(function(recipe) {
        var card = document.createElement("div");
        card.className = "card";

        var imgUrl = recipe.image ? recipe.image : 'rpics/p1.png';
        var recipeName = recipe.name ? recipe.name : "Untitled Recipe";
        var prepText = recipe.prepTime ? recipe.prepTime : "View recipe";

        card.innerHTML =
            '<div class="recipe-card-image-wrap">' +
                '<img src="' + escapeHTML(imgUrl) + '" class="grid-pic" alt="' + escapeHTML(recipeName) + '">' +
            '</div>' +
            '<div class="recipe-card-info">' +
                '<h3>' + escapeHTML(recipeName) + '</h3>' +
                '<p>' + escapeHTML(prepText) + '</p>' +
            '</div>';

        card.addEventListener("click", function() {
            showFullRecipe(recipe);
        });

        imageGrid.appendChild(card);
    });
}

function loadFeaturedRecipes() {
    fetch('../RecipeSearch?q=&tag=')
        .then(function(response) {
            if (!response.ok) {
                throw new Error("Failed to load featured recipes.");
            }
            return response.json();
        })
        .then(function(recipes) {
            var randomRecipes = shuffleRecipes(recipes);
            renderRecipeCards(
                randomRecipes,
                "Featured Recipes",
                "A few picks from our cookbook.",
                4
            );
        })
        .catch(function(err) {
            console.error("Featured recipes failed:", err);

            if (imageGrid) {
                imageGrid.innerHTML =
                    '<p class="no-results-message">Could not load featured recipes.</p>';
            }
        });
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

if (tags) {
    tags.forEach(function(tag) {
        tag.addEventListener("click", function() {
            tags.forEach(function(t) {
                t.classList.remove("active");
            });
            this.classList.add("active");
        });
    });
}

window.onclick = function(event) {
    if (event.target == recipeModal) {
        closeRecipeModal();
    }
    if (event.target == searchModal) {
        closeSearchModal();
    }
};

if (searchForm) {
    searchForm.addEventListener("submit", function(e) {
        e.preventDefault();
        
        var queryInput = document.getElementById("search-input");
        var query = queryInput ? queryInput.value : "";
        
        var activeTagElement = document.querySelector(".keyword-tag.active");
        var activeTag = activeTagElement ? activeTagElement.innerText : "";

        var url = '../RecipeSearch?q=' + encodeURIComponent(query) + '&tag=' + encodeURIComponent(activeTag);

        fetch(url)
            .then(function(response) {
                return response.json();
            })
			.then(function(recipes) {
			    var countText = recipes.length + ' recipe' + (recipes.length === 1 ? '' : 's') + ' found';

			    renderRecipeCards(
			        recipes,
			        "Search Results",
			        countText,
			        null
			    );

			    if (recipes.length === 0 && imageGrid) {
			        imageGrid.innerHTML =
			            '<p class="no-results-message">No recipes found. Try another keyword.</p>';
			    }

			    closeSearchModal();
			})
            .catch(function(err) {
                console.error("Search failed:", err);
            });
    });
}

function showFullRecipe(recipe) {
    var body = document.getElementById("modalBody");
    var imgUrl = recipe.image ? recipe.image : 'rpics/p1.png';

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
			'<div class="recipe-top-section">' +
			    '<img src="' + imgUrl + '" class="recipe-info-img" alt="' + recipe.name + '">' +
			    '<div class="recipe-summary">' +
			        '<div class="summary-card">' +
			            '<h3>Prep Time</h3>' +
			            '<p>' + recipe.prepTime + '</p>' +
			        '</div>' +
			        '<div class="summary-card">' +
			            '<h3>Nutrition Facts</h3>' +
			            '<p>' + recipe.nutrition + '</p>' +
			        '</div>' +
			    '</div>' +
			'</div>' +

			'<div class="ingredients-section">' +
			    '<h3>Ingredients</h3>' +
			    '<form id="shopping-form">' +
			        '<div class="ingredients-list" id="ingredients-list">' +
			            ingredientCheckboxes +
			        '</div>' +
			        '<button type="button" class="btn btn-success btn-sm shopping-btn" onclick="saveToShoppingList()">Add Selected to Shopping List</button>' +
			    '</form>' +
			'</div>' +
			'<div class="recipe-instructions-block">' +
			    '<h3>Instructions</h3>' +
			    '<p class="instruction-text">' + recipe.instructions + '</p>' +
			'</div>';
    }

    if (recipeModal) {
        recipeModal.style.display = "block";
        document.body.style.overflow = "hidden";
    }
	adjustIngredientColumns();
}

function adjustIngredientColumns() {
    var ingredientsList = document.getElementById("ingredients-list");

    if (!ingredientsList) {
        return;
    }

    var itemCount = ingredientsList.querySelectorAll(".form-check").length;

    ingredientsList.classList.remove("many-ingredients");

    if (itemCount >= 14) {
        ingredientsList.classList.add("many-ingredients");
    }
}

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

// --- AUTO-OPEN MODAL FROM URL PARAMETER ---
// This runs when the page loads, checks the URL, and opens the recipe if ?recipeId is present
document.addEventListener("DOMContentLoaded", function() {
    loadFeaturedRecipes();

    var urlParams = new URLSearchParams(window.location.search);
    var recipeId = urlParams.get('recipeId');

    if (recipeId) {
        fetch('../RecipeSearch?id=' + encodeURIComponent(recipeId))
            .then(function(response) {
                return response.json();
            })
            .then(function(recipes) {
                if (recipes && recipes.length > 0) {
                    showFullRecipe(recipes[0]);
                    window.history.replaceState({}, document.title, window.location.pathname);
                }
            })
            .catch(function(err) {
                console.error("Failed to load specific recipe:", err);
            });
    }
});