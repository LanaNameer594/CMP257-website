import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Capture the data from the form (using the 'name' attributes)
        String fName = request.getParameter("firstname");
        String lName = request.getParameter("lastname");
        String uName = request.getParameter("username");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        // 2. Pass it to the UserManager to talk to the Database
        UserManager um = new UserManager();
        boolean isSaved = um.registerUser(fName, lName, uName, email, pass);

        // 3. Decide where to go next
        if (isSaved) {
            // Success! Send them to the login page
            response.sendRedirect("login.html?success=true");
        } else {
            // Failure (likely duplicate username/email)
            response.sendRedirect("createAccount.html?error=true");
        }
    }
}