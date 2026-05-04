document.addEventListener("DOMContentLoaded", () => {
    const API_BASE = window.location.origin + "/TheCookbook";


    // --- 2. LOGOUT LOGIC ---
    // Your HTML has id="logoutBtn"
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', () => {
            window.location.href = API_BASE + '/LogoutServlet';
        });
    }

    // --- 3. EDIT PROFILE LOGIC ---
    // Your HTML has id="profileToggleBtn"
    const profileToggleBtn = document.getElementById('profileToggleBtn');
    const fields = ['first-name', 'last-name', 'username', 'email', 'password'];

    if (profileToggleBtn) {
        profileToggleBtn.addEventListener('click', function() {
            const isEditing = this.textContent === "Save Changes";

            if (!isEditing) {
                // Enable inputs
                fields.forEach(id => {
                    const input = document.getElementById(id);
                    if (input) input.disabled = false;
                });
                this.textContent = "Save Changes";
                this.classList.add("save-active"); 
            } else {
                // Collect and Save data
                const updatedData = {
                    firstName: document.getElementById('first-name').value,
                    lastName: document.getElementById('last-name').value,
                    username: document.getElementById('username').value,
                    email: document.getElementById('email').value
                };

                fetch(API_BASE + '/EditProfileServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(updatedData)
                })
                .then(res => {
                    if (res.ok) {
                        alert("Profile Updated!");
                        fields.forEach(id => {
                            const input = document.getElementById(id);
                            if (input) input.disabled = true;
                        });
                        this.textContent = "Edit Profile";
                        this.classList.remove("save-active");
                    }
                });
            }
        });
    }

    // --- 4. LOAD USER DATA ON START ---
    if (window.location.pathname.includes("profile.html")) {
        fetch(API_BASE + '/GetUserDetailsServlet')
            .then(res => res.json())
            .then(data => {
                if(document.getElementById('first-name')) document.getElementById('first-name').value = data.firstName;
                if(document.getElementById('last-name')) document.getElementById('last-name').value = data.lastName;
                if(document.getElementById('username')) document.getElementById('username').value = data.username;
                if(document.getElementById('email')) document.getElementById('email').value = data.email;
                if(document.getElementById('welcome-text')) document.getElementById('welcome-text').textContent = "Welcome, " + data.firstName + "!";
            })
            .catch(err => console.log("Not logged in or error fetching details"));
    }
});

// Keep this outside for the onclick events in your HTML
function openTab(tabName) {
    let tabContents = document.getElementsByClassName("tab-content");
    for (let i = 0; i < tabContents.length; i++) {
        tabContents[i].style.display = "none";
        tabContents[i].classList.remove("active-content");
    }
    let tabBtns = document.getElementsByClassName("tab-btn");
    for (let i = 0; i < tabBtns.length; i++) {
        tabBtns[i].classList.remove("active");
    }
    document.getElementById(tabName).style.display = "block";
    document.getElementById(tabName).classList.add("active-content");
    event.currentTarget.classList.add("active");
}