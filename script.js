document.addEventListener("DOMContentLoaded", () => {
  const API_BASE = window.location.origin + "/TheCookbook";

  // --- THE BOUNCER: PAGE-LOAD CHECK ---
  // If we are currently ON the profile page, immediately check if we are allowed to be here.
  if (window.location.pathname.includes("profile.html")) {
    fetch(API_BASE + '/GetShoppingListServlet') 
      .then(response => {
        if (!response.ok) {
          // KICK OUT: Server returned an error (401), redirect directly to neighbor login.html.
          window.location.replace('login.html');
        }
      })
      .catch(error => {
        // KICK OUT: Network error or server crash, redirect directly to neighbor login.html.
        window.location.replace('login.html');
      });
  }

  let currentRecipe = null;

  const state = {
    ingredients: [],
    results: [],
    currentIndex: 0,
    lastWasFallback: false
  };

  const openPickerBtn = document.getElementById("openPickerBtn");
  const closePickerBtn = document.getElementById("closePickerBtn");
  const pickModal = document.getElementById("pickModal");

  const form = document.getElementById("pickForm");
  const categorySelect = document.getElementById("category");
  const recipeTypeSelect = document.getElementById("recipeType");
  const ingredientInput = document.getElementById("ingredientInput");
  const addIngredientBtn = document.getElementById("addIngredientBtn");
  const ingredientTags = document.getElementById("ingredientTags");
  const resultCard = document.getElementById("resultCard");
  const rerollBtn = document.getElementById("rerollBtn");
  const saveBtn = document.getElementById("saveBtn");
  const resetBtn = document.getElementById("resetBtn");

  console.log("Script loaded");

  function normalizeText(value) {
    return value.trim().toLowerCase();
  }

  function renderIngredientTags() {
    if (!ingredientTags) {
      return;
    }

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

  function fetchBestMatches(category, recipeType, ingredients) {
    var params = new URLSearchParams();

    if (category) params.append("category", category);
    if (recipeType) params.append("type", recipeType);

    var url = API_BASE + "/api/recipes/match";
    if (params.toString()) {
        url += "?" + params.toString();
    }

    return fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify(ingredients || []) 
    })
      .then(function (response) {
        if (!response.ok) {
          throw new Error("Server error while fetching recipe matches.");
        }
        return response.json();
      })
      .then(function (data) {
        if (!Array.isArray(data)) {
          console.error("Expected array but got:", data);
          return [];
        }
        return data;
      });
  }

  function renderBackendRecipe(recipe) {
      currentRecipe = recipe;

      if (!recipe) {
        renderEmptyResult("No recipe was returned.");
        return;
      }

      resultCard.className = "result-card";

      const recipeName = recipe.recipeName || "Untitled recipe";
      const image = recipe.imgSrc || "images/placeholder.jpg";
      const totalTime = recipe.totalTime || "Time not listed";
      const rating = recipe.rating || "N/A";
      const servings = recipe.servings || "N/A";

      resultCard.innerHTML = `
        <img
          src="${image}"
          alt="${recipeName}"
          class="recipe-image"
          onerror="this.src='images/placeholder.jpg'"
        >
        <h3>${recipeName}</h3>
        <div class="recipe-meta">
          <span class="recipe-pill">${totalTime}</span>
          <span class="recipe-pill">Rating: ${rating}</span>
          <span class="recipe-pill">Serves: ${servings}</span>
        </div>
        <button type="button" class="secondary-btn view-recipe-btn">View recipe</button>
      `;

      const saveBtn = resultCard.querySelector(".save-recipe-btn");

      if (saveBtn) {
        saveBtn.addEventListener("click", () => {
          if (!currentRecipe) {
            alert("No recipe selected yet.");
            return;
          }

          fetch(`${API_BASE}/api/saved-recipes`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json"
            },
            body: JSON.stringify({
              userId: 1, // Make sure you update this later to reflect the actual logged-in user!
              recipeId: currentRecipe.recipeId
            })
          })
          .then(response => {
            if (!response.ok) {
              throw new Error("Save failed");
            }
            alert("Recipe saved to your profile!");
          })
          .catch(error => {
            console.error(error);
            alert("Could not save recipe.");
          });
        });
      }

      const viewRecipeBtn = resultCard.querySelector(".view-recipe-btn");

      if (viewRecipeBtn) {
        viewRecipeBtn.addEventListener("click", () => {
          // If your recipe.html is ALSO in the same folder, you can change this to just `recipe.html?recipeId=...`
          window.location.href = `${API_BASE}/recipes/recipe.html?recipeId=${recipe.recipeId}`;
        });
      }

      if (rerollBtn) {
        rerollBtn.disabled = state.results.length <= 1;
      }

      if (saveBtn) {
        saveBtn.disabled = false;
      }
  } 

  function renderEmptyResult(message) {
    currentRecipe = null;
    if(resultCard) {
      resultCard.className = "result-card empty-state";
      resultCard.innerHTML = `<p>${message}</p>`;
    }
    if (rerollBtn) {
      rerollBtn.disabled = true;
    }
    if (saveBtn) {
      saveBtn.disabled = true;
    }
  }

  function pickRecipe(event) {
    event.preventDefault();

    const category = categorySelect.value;
    const recipeType = recipeTypeSelect.value;

    fetchBestMatches(category, recipeType, state.ingredients)
      .then(function(matches) {
        if (matches.length === 0 && category && recipeType) {
          state.lastWasFallback = true;
          return fetchBestMatches(category, recipeType, []);
        } else if (matches.length === 0 && category && state.ingredients.length > 0) {
          state.lastWasFallback = true;
          return fetchBestMatches(category, "", state.ingredients);
        } else if (matches.length === 0 && recipeType && state.ingredients.length > 0) {
          state.lastWasFallback = true;
          return fetchBestMatches("", recipeType, state.ingredients);
        } else {
          state.lastWasFallback = false;
          return matches;
        }
      })
      .then(function(finalMatches) {
        state.results = finalMatches;
        state.currentIndex = 0;

        if (finalMatches.length === 0) {
          renderEmptyResult("No close match found. Try removing one filter.");
          return;
        }

        renderBackendRecipe(finalMatches[0]);
      })
      .catch(function(error) {
        console.error("Recipe search failed:", error);
        renderEmptyResult("Something went wrong while loading recipes.");
      });
  }

  function pickAgain() {
    if (state.results.length <= 1) return;
    state.currentIndex = (state.currentIndex + 1) % state.results.length;
    const recipe = state.results[state.currentIndex];
    renderBackendRecipe(recipe);
  }

  function resetForm() {
    form.reset();
    categorySelect.value = "";
    recipeTypeSelect.value = "";

    state.ingredients = [];
    state.results = [];
    state.currentIndex = 0;
    state.lastWasFallback = false;

    renderIngredientTags();
    renderEmptyResult("Nothing picked yet. Let the cookbook decide.");
  }

  function openModal() {
    if(pickModal) {
      pickModal.classList.add("active");
      pickModal.setAttribute("aria-hidden", "false");
      document.body.style.overflow = "hidden";
    }
  }

  function closeModal() {
    if(pickModal) {
      pickModal.classList.remove("active");
      pickModal.setAttribute("aria-hidden", "true");
      document.body.style.overflow = "";
    }
  }

  if (openPickerBtn) {
    openPickerBtn.addEventListener("click", openModal);
  }

  if (closePickerBtn) {
    closePickerBtn.addEventListener("click", closeModal);
  }

  if (pickModal) {
    pickModal.addEventListener("click", function (event) {
      if (event.target === pickModal) {
        closeModal();
      }
    });
  }

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && pickModal && pickModal.classList.contains("active")) {
      closeModal();
    }
  });

  if (addIngredientBtn) {
    addIngredientBtn.addEventListener("click", addIngredient);
  }

  if (ingredientInput) {
    ingredientInput.addEventListener("keydown", (event) => {
      if (event.key === "Enter") {
        event.preventDefault();
        addIngredient();
      }
    });
  }

  if (form) {
    form.addEventListener("submit", pickRecipe);
  }
  if (rerollBtn) {
    rerollBtn.addEventListener("click", pickAgain);
  }
  if (resetBtn) {
    resetBtn.addEventListener("click", resetForm);
  }

  // --- UPDATED CLICK INTERCEPTION ---
  const profileLinks = document.querySelectorAll(".profile-link-btn, #profileLinkBtn");

  profileLinks.forEach(link => {
    link.addEventListener("click", function(event) {
      event.preventDefault(); // Stop normal redirection

      const checkUrl = API_BASE + '/GetShoppingListServlet';

      fetch(checkUrl) 
        .then(response => {
          if (response.ok) {
            // Logged in: manually send them to neighbor profile.html
            window.location.href = 'profile.html';
          } else {
            // Not logged in: manually send them to neighbor login.html
            window.location.href = 'login.html'; 
          }
        })
        .catch(error => {
          console.error("Error checking login status:", error);
          window.location.href = 'login.html'; 
        });
    });
  });

  renderIngredientTags();
});