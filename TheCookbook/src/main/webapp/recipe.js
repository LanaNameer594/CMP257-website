// --- Element Selection ---
const searchBtn = document.getElementById("search-btn");
const searchModal = document.getElementById("pickModal"); 
const recipeModal = document.getElementById("recipeModal"); 
const closeSearchBtn = document.querySelector(".modal-close");
const closeRecipeBtn = document.querySelector(".close-btn");
const searchForm = document.getElementById("search-form");
const imageGrid = document.querySelector(".image-grid");
const tags = document.querySelectorAll(".keyword-tag");

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

searchBtn.addEventListener("click", openSearchModal);
closeSearchBtn.addEventListener("click", closeSearchModal);
closeRecipeBtn.addEventListener("click", closeRecipeModal);

// Close on background click
window.onclick = (event) => {
    if (event.target == recipeModal) closeRecipeModal();
    if (event.target == searchModal) closeSearchModal();
};

// --- Search Implementation ---
searchForm.addEventListener("submit", async (e) => {
    e.preventDefault();
    
    const query = document.getElementById("search-input").value;
    const activeTag = document.querySelector(".keyword-tag.active")?.innerText || "";

    try {
        const response = await fetch(`RecipeSearch?q=${encodeURIComponent(query)}&tag=${encodeURIComponent(activeTag)}`);
        const recipes = await response.json();

        imageGrid.innerHTML = ""; 

        if (recipes.length === 0) {
            imageGrid.innerHTML = "<p style='color:white; grid-column: 1/-1; text-align:center;'>No recipes found.</p>";
        }

        recipes.forEach(recipe => {
            const card = document.createElement("div");
            card.className = "card";
            card.innerHTML = `
                <img src="${recipe.image}" class="grid-pic" alt="${recipe.name}">
                <div class="overlay">
                    <p class="overlay-text">${recipe.name}</p>
                </div>
            `;
            card.addEventListener("click", () => showFullRecipe(recipe));
            imageGrid.appendChild(card);
        });

        closeSearchModal(); 
    } catch (err) {
        console.error("Search failed:", err);
    }
});

// --- UI Display ---
function showFullRecipe(recipe) {
    const body = document.getElementById("modalBody");
    body.innerHTML = `
        <h1 class="recipe-header">${recipe.name}</h1>
        <div class="recipe-split">
            <img src="${recipe.image}" class="recipe-info-img">
            <div class="recipe-details">
                <h3>Ingredients</h3>
                <p class="ingredient-list">${recipe.ingredients}</p>
                <br>
                <h3>Instructions</h3>
                <p class="instruction-text">${recipe.instructions}</p>
            </div>
        </div>
    `;
    recipeModal.style.display = "block";
    document.body.style.overflow = "hidden";
}