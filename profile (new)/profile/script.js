// --- Wrap everything in DOMContentLoaded so HTML loads first ---
document.addEventListener('DOMContentLoaded', () => {

    // ==========================================
    // 1. LOGIN & NAVIGATION LOGIC
    // ==========================================
    const navBtn = document.getElementById('loginBtn'); 
    const loginScreen = document.getElementById('loginScreen');
    const profileScreen = document.getElementById('profileScreen');
    const loginForm = document.getElementById('loginForm');

    let isLoggedIn = false; 

    // Safety check: Only run this if navBtn actually exists on the page
    if (navBtn) {
        navBtn.addEventListener('click', () => {
            if (isLoggedIn) {
                if (profileScreen) profileScreen.scrollIntoView({ behavior: 'smooth' }); 
            } else {
                if (loginScreen) loginScreen.classList.remove('hidden');
            }
        });
    }

    // Safety check: Only run this if the login form exists
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault(); // Prevent page reload
            
            if (loginScreen) loginScreen.classList.add('hidden'); 
            isLoggedIn = true;
            if (navBtn) navBtn.textContent = 'MY PROFILE';
            if (profileScreen) profileScreen.scrollIntoView({ behavior: 'smooth' });
        });
    }

    // ==========================================
    // 2. PROFILE PICTURE PREVIEW LOGIC
    // ==========================================
    const fileInput = document.getElementById('file-input');
    const settingsPfp = document.querySelector('.profile-picture'); 
    const headerAvatar = document.querySelector('.avatar'); 

    if (fileInput) {
        fileInput.addEventListener('change', function(event) {
            const file = event.target.files[0]; 
            if (file) {
                const imageUrl = URL.createObjectURL(file);
                if (settingsPfp) settingsPfp.src = imageUrl;
                if (headerAvatar) headerAvatar.src = imageUrl;
                console.log("Profile picture successfully updated!");
            }
        });
    }

    // ==========================================
    // 3. EDIT / SAVE PROFILE TOGGLE LOGIC
    // ==========================================
    const profileToggleBtn = document.getElementById('profileToggleBtn');
    const profileInputs = document.querySelectorAll('.general-info input:not(#file-input)');
    
    let isEditingProfile = false;

    if (profileToggleBtn) {
        profileToggleBtn.addEventListener('click', () => {
            isEditingProfile = !isEditingProfile;

            if (isEditingProfile) {
                // MODE: EDITING
                profileInputs.forEach(input => input.disabled = false);
                profileToggleBtn.textContent = 'Save Changes';
                profileToggleBtn.classList.add('save-active');
                
                const firstNameInput = document.getElementById('first-name');
                if (firstNameInput) firstNameInput.focus();
            } else {
                // MODE: SAVING
                profileInputs.forEach(input => input.disabled = true);
                profileToggleBtn.textContent = 'Edit Profile';
                profileToggleBtn.classList.remove('save-active');
                console.log("Profile changes locked and saved!");
            }
        });
    }
	
	// ==========================================
	    // 6. LOGOUT LOGIC
	    // ==========================================
	    const logoutBtn = document.getElementById('logoutBtn');

	    if (logoutBtn) {
	        logoutBtn.addEventListener('click', () => {
	            // 1. Reset the login state
	            isLoggedIn = false;
	            
	            // 2. Change the top navigation button back to "LOGIN"
	            if (navBtn) navBtn.textContent = 'LOGIN';
	            
	            // 3. Un-hide the login screen overlay
	            if (loginScreen) loginScreen.classList.remove('hidden');
	            
	            // 4. Scroll back to the top just to be safe
	            window.scrollTo({ top: 0, behavior: 'smooth' });
	            
	            console.log("User successfully logged out.");
	        });
	    }
	
});

// ==========================================
// 4. TAB SWITCHING LOGIC (Must stay outside DOMContentLoaded to work with HTML onclick)
// ==========================================
function openTab(tabName) {
    let tabContents = document.getElementsByClassName("tab-content");
    for (let i = 0; i < tabContents.length; i++) {
        tabContents[i].classList.remove("active-content");
    }

    let tabBtns = document.getElementsByClassName("tab-btn");
    for (let i = 0; i < tabBtns.length; i++) {
        tabBtns[i].classList.remove("active");
    }

    const selectedTab = document.getElementById(tabName);
    if (selectedTab) {
        selectedTab.classList.add("active-content");
    }
    
    // Safely capture the event object to prevent browser errors
    const currentEvent = window.event;
    if (currentEvent && currentEvent.currentTarget) {
        currentEvent.currentTarget.classList.add("active");
    }
}