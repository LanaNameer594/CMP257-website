// Grab our elements
const navBtn = document.getElementById('loginBtn'); // Renamed variable for clarity
const loginScreen = document.getElementById('loginScreen');
const profileScreen = document.getElementById('profileScreen');
const loginForm = document.getElementById('loginForm');

// 1. Create a state variable to track if the user is logged in
let isLoggedIn = false; 

// 2. Update the Navigation Button Click Behavior
navBtn.addEventListener('click', () => {
    if (isLoggedIn) {
        // If they are logged in, clicking the button scrolls to or shows the profile
        profileScreen.scrollIntoView({ behavior: 'smooth' }); 
        
        // Alternatively, if your profile is on a separate HTML page, you would do:
        // window.location.href = "profile.html";
    } else {
        // If they are NOT logged in, show the login overlay
        loginScreen.classList.remove('hidden');
    }
});

// 3. Update the Login Form Submission Behavior
loginForm.addEventListener('submit', function(e) {
    e.preventDefault(); // Prevent page reload
    
    // Hide the login screen
    loginScreen.classList.add('hidden'); 
    
    // Update the state to logged in
    isLoggedIn = true;
    
    // Change the button text from LOGIN to MY PROFILE
    navBtn.textContent = 'MY PROFILE';
    
    // (Optional) Automatically scroll them down to their new profile hub
    profileScreen.scrollIntoView({ behavior: 'smooth' });
    
    alert("Welcome back to The Cookbook!");
});

// --- Tab Switching Logic (Remains the same) ---
function openTab(tabName) {
    let tabContents = document.getElementsByClassName("tab-content");
    for (let i = 0; i < tabContents.length; i++) {
        tabContents[i].classList.remove("active-content");
    }

    let tabBtns = document.getElementsByClassName("tab-btn");
    for (let i = 0; i < tabBtns.length; i++) {
        tabBtns[i].classList.remove("active");
    }

    document.getElementById(tabName).classList.add("active-content");
    event.currentTarget.classList.add("active");
};

// --- Profile Picture Upload Preview Logic ---
document.addEventListener('DOMContentLoaded', () => {
    const fileInput = document.getElementById('file-input');
    const settingsPfp = document.querySelector('.profile-picture'); 
    const headerAvatar = document.querySelector('.avatar'); 

    // Safety check to make sure the elements exist on the page
    if (fileInput) {
        fileInput.addEventListener('change', function(event) {
            const file = event.target.files[0]; 
            
            if (file) {
                const imageUrl = URL.createObjectURL(file);
                
                // Update images if they exist
                if (settingsPfp) settingsPfp.src = imageUrl;
                if (headerAvatar) headerAvatar.src = imageUrl;
                
                console.log("Profile picture successfully updated!");
            }
        });
    } else {
        console.error("Could not find the file input element. Check your HTML IDs.");
    }
});

// --- Edit / Save Profile Toggle Logic ---
const profileToggleBtn = document.getElementById('profileToggleBtn');

// Grab all the inputs in the settings EXCEPT the file upload button
const profileInputs = document.querySelectorAll('.general-info input:not(#file-input)');

let isEditingProfile = false;

if (profileToggleBtn) {
    profileToggleBtn.addEventListener('click', () => {
        // Toggle our state variable between true and false
        isEditingProfile = !isEditingProfile;

        if (isEditingProfile) {
            // MODE: EDITING
            // 1. Enable all the text inputs
            profileInputs.forEach(input => input.disabled = false);
            
            // 2. Change the button to look like a Save button
            profileToggleBtn.textContent = 'Save Changes';
            profileToggleBtn.classList.add('save-active');
            
            // 3. Focus on the first input (First Name) automatically
            document.getElementById('first-name').focus();
        } else {
            // MODE: SAVING
            // 1. Disable all the text inputs again
            profileInputs.forEach(input => input.disabled = true);
            
            // 2. Revert the button back to the Edit Profile look
            profileToggleBtn.textContent = 'Edit Profile';
            profileToggleBtn.classList.remove('save-active');
            
            // (In a real app, this is where you would send the updated data to your Java backend!)
            console.log("Profile changes locked and saved!");
        }
    });
}