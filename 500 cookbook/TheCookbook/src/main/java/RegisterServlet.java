import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // These must match the 'name' attributes in your createAccount.html
        String fName = request.getParameter("firstName"); //
        String lName = request.getParameter("lastName");  //
        String uName = request.getParameter("username");  //
        String email = request.getParameter("email");     //
        String pass = request.getParameter("password");    //

        UserManager um = new UserManager();
        
        if (um.registerUser(fName, lName, uName, email, pass)) {
            // Redirect to login on success
            response.sendRedirect(request.getContextPath() + "/profile/login.html");
        } else {
            // Redirect back to registration on failure
            response.sendRedirect(request.getContextPath() + "/profile/createAccount.html?error=true");
        }
    }
}