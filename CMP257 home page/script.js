const modal = document.getElementById("calendarModal");
const calImg = document.getElementById("cal-img");
const closeBtn = document.querySelector(".close-btn");

// Open modal when the image is clicked
calImg.onclick = function() {
  modal.style.display = "block";
}

// Close modal when 'X' is clicked
closeBtn.onclick = function() {
  modal.style.display = "none";
}

// Close modal if user clicks anywhere on the blurred background
window.onclick = function(event) {
  if (event.target == modal) {
    modal.style.display = "none";
  }
}
