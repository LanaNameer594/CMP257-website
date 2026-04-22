const recipes = [
  {
    id: 1,
    title: "Berry Yogurt Toast",
    mealType: "breakfast",
    moods: ["light", "quick"],
    ingredients: ["bread", "yogurt", "berries", "honey"],
    image: "images/berry-toast.jpg",
    description: "Fresh, bright, and perfect for an easy morning.",
    time: "10 mins",
    difficulty: "Easy"
  },
  {
    id: 2,
    title: "Avocado Egg Toast",
    mealType: "breakfast",
    moods: ["light", "comforting"],
    ingredients: ["bread", "avocado", "egg", "lemon"],
    image: "images/avocado-toast.jpg",
    description: "A simple breakfast that feels fresh and filling.",
    time: "12 mins",
    difficulty: "Easy"
  },
  {
    id: 3,
    title: "Chicken Pesto Wrap",
    mealType: "lunch",
    moods: ["quick", "light"],
    ingredients: ["chicken", "wrap", "lettuce", "pesto"],
    image: "images/chicken-wrap.jpg",
    description: "A quick lunch that still feels satisfying.",
    time: "15 mins",
    difficulty: "Easy"
  },
  {
    id: 4,
    title: "Tomato Basil Grilled Cheese",
    mealType: "lunch",
    moods: ["comforting", "cozy"],
    ingredients: ["bread", "cheese", "tomato", "basil"],
    image: "images/grilled-cheese.jpg",
    description: "Warm, cheesy, and exactly right for a cozy afternoon.",
    time: "18 mins",
    difficulty: "Easy"
  },
  {
    id: 5,
    title: "Creamy Garlic Pasta",
    mealType: "dinner",
    moods: ["comforting", "cozy", "indulgent"],
    ingredients: ["pasta", "garlic", "cream", "parmesan"],
    image: "images/garlic-pasta.jpg",
    description: "Rich, creamy, and ideal for a cozy dinner.",
    time: "25 mins",
    difficulty: "Easy"
  },
  {
    id: 6,
    title: "Herb Butter Salmon",
    mealType: "dinner",
    moods: ["fancy", "light"],
    ingredients: ["salmon", "butter", "lemon", "herbs"],
    image: "images/salmon.jpg",
    description: "Elegant enough for a special dinner but simple to make.",
    time: "30 mins",
    difficulty: "Medium"
  }
];

const state = {
  mealType: "",
  mood: "",
  ingredients: [],
  results: [],
  currentIndex: 0,
  lastWasFallback: false
};

const openPickerBtn = document.getElementById("openPickerBtn");
const closePickerBtn = document.getElementById("closePickerBtn");
const pickModal = document.getElementById("pickModal");

const form = document.getElementById("pickForm");
const mealTypeSelect = document.getElementById("mealType");
const moodSelect = document.getElementById("mood");
const ingredientInput = document.getElementById("ingredientInput");
const addIngredientBtn = document.getElementById("addIngredientBtn");
const ingredientTags = document.getElementById("ingredientTags");
const resultCard = document.getElementById("resultCard");
const rerollBtn = document.getElementById("rerollBtn");
const saveBtn = document.getElementById("saveBtn");
const resetBtn = document.getElementById("resetBtn");

function openModal() {
  pickModal.classList.add("active");
  pickModal.setAttribute("aria-hidden", "false");
  document.body.style.overflow = "hidden";
}

function closeModal() {
  pickModal.classList.remove("active");
  pickModal.setAttribute("aria-hidden", "true");
  document.body.style.overflow = "";
}

openPickerBtn.addEventListener("click", openModal);
closePickerBtn.addEventListener("click", closeModal);

pickModal.addEventListener("click", (event) => {
  if (event.target === pickModal) {
    closeModal();
  }
});

document.addEventListener("keydown", (event) => {
  if (event.key === "Escape" && pickModal.classList.contains("active")) {
    closeModal();
  }
});

function normalizeText(value) {
  return value.trim().toLowerCase();
}

function renderIngredientTags() {
  ingredientTags.innerHTML = "";

  state.ingredients.forEach((ingredient, index) => {
    const tag = document.createElement("span");
    tag.className = "ingredient-tag";
    tag.innerHTML = `
      ${ingredient}
      <button
        type="button"
        class="remove-tag"
        aria-label="Remove ${ingredient}"
        data-index="${index}"
      >
        ×
      </button>
    `;
    ingredientTags.appendChild(tag);
  });

  document.querySelectorAll(".remove-tag").forEach((button) => {
    button.addEventListener("click", () => {
      const index = Number(button.dataset.index);
      state.ingredients.splice(index, 1);
      renderIngredientTags();
    });
  });
}

function addIngredient() {
  const value = normalizeText(ingredientInput.value);

  if (!value) return;
  if (state.ingredients.includes(value)) {
    ingredientInput.value = "";
    return;
  }

  state.ingredients.push(value);
  ingredientInput.value = "";
  renderIngredientTags();
}

function filterRecipes() {
  return recipes.filter((recipe) => {
    const matchesMeal = !state.mealType || recipe.mealType === state.mealType;
    const matchesMood = !state.mood || recipe.moods.includes(state.mood);
    const matchesIngredients =
      state.ingredients.length === 0 ||
      state.ingredients.every((ingredient) =>
        recipe.ingredients.includes(ingredient)
      );

    return matchesMeal && matchesMood && matchesIngredients;
  });
}

function getFallbackRecipes() {
  return recipes.filter((recipe) => {
    const matchesMeal = !state.mealType || recipe.mealType === state.mealType;
    const matchesMood = !state.mood || recipe.moods.includes(state.mood);

    return matchesMeal || matchesMood;
  });
}

function renderRecipe(recipe, isFallback = false) {
  resultCard.classList.remove("empty-state");

  resultCard.innerHTML = `
    ${isFallback ? `<p><strong>No exact match.</strong> Here’s a close pick instead.</p>` : ""}
    <img src="${recipe.image}" alt="${recipe.title}" class="recipe-image">
    <h3>${recipe.title}</h3>
    <p>${recipe.description}</p>

    <div class="recipe-meta">
      <span class="recipe-pill">${recipe.mealType}</span>
      <span class="recipe-pill">${recipe.time}</span>
      <span class="recipe-pill">${recipe.difficulty}</span>
    </div>

    <h4>Main ingredients</h4>
    <ul class="recipe-ingredients">
      ${recipe.ingredients.map((item) => `<li>${item}</li>`).join("")}
    </ul>

    <button type="button" class="secondary-btn view-recipe-btn">View recipe</button>
  `;

  const viewRecipeBtn = resultCard.querySelector(".view-recipe-btn");
  if (viewRecipeBtn) {
    viewRecipeBtn.addEventListener("click", () => {
      window.location.href = `recipes.html?recipeId=${recipe.id}`;
    });
  }

  rerollBtn.disabled = state.results.length <= 1;
  saveBtn.disabled = false;
}

function renderEmptyResult(message) {
  resultCard.className = "result-card empty-state";
  resultCard.innerHTML = `<p>${message}</p>`;
  rerollBtn.disabled = true;
  saveBtn.disabled = true;
}

function pickRecipe(event) {
  event.preventDefault();

  state.mealType = mealTypeSelect.value;
  state.mood = moodSelect.value;

  let matches = filterRecipes();
  let isFallback = false;

  if (matches.length === 0) {
    matches = getFallbackRecipes();
    isFallback = true;
  }

  state.results = matches;
  state.currentIndex = 0;
  state.lastWasFallback = isFallback;

  if (matches.length === 0) {
    renderEmptyResult("We couldn’t find a recipe for that combo yet.");
    return;
  }

  renderRecipe(matches[0], isFallback);
}

function pickAgain() {
  if (state.results.length <= 1) return;

  state.currentIndex = (state.currentIndex + 1) % state.results.length;
  const recipe = state.results[state.currentIndex];
  renderRecipe(recipe, state.lastWasFallback);
}

function resetForm() {
  form.reset();
  state.mealType = "";
  state.mood = "";
  state.ingredients = [];
  state.results = [];
  state.currentIndex = 0;
  state.lastWasFallback = false;

  renderIngredientTags();
  renderEmptyResult("Nothing picked yet. Let the kitchen decide.");
}

addIngredientBtn.addEventListener("click", addIngredient);

ingredientInput.addEventListener("keydown", (event) => {
  if (event.key === "Enter") {
    event.preventDefault();
    addIngredient();
  }
});

form.addEventListener("submit", pickRecipe);
rerollBtn.addEventListener("click", pickAgain);
resetBtn.addEventListener("click", resetForm);

saveBtn.addEventListener("click", () => {
  alert("Save feature will connect to your profile later.");
});

renderIngredientTags();