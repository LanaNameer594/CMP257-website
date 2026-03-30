const openBtn = document.getElementById("open-btn");
const modal = document.getElementById("pickModal");
const closeBtn = modal.querySelector(".modal-close");

let lastFocusedElement = null;

function openModal() {
  lastFocusedElement = document.activeElement;

  modal.classList.add("active");
  document.body.style.overflow = "hidden";

  closeBtn.focus();
}

function closeModal() {
  modal.classList.remove("active");
  document.body.style.overflow = "";

  if (lastFocusedElement) {
    lastFocusedElement.focus();
  }
}

openBtn.addEventListener("click", openModal);
closeBtn.addEventListener("click", closeModal);

document.addEventListener("keydown", (e) => {
  if (e.key === "Escape" && modal.classList.contains("active")) {
    closeModal();
  }
});