import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uName = request.getParameter("username").trim();
        String pass = request.getParameter("password");

        UserManager um = new UserManager();
        
        // This dynamically grabs "/TheCookbook" (or whatever your project is named)
        String basePath = request.getContextPath();

        if (um.loginUser(uName, pass)) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", uName);
            
            // Sends you safely to: /TheCookbook/profile.html
            response.sendRedirect(basePath + "/profile/profile.html"); 
        } else {
            // Sends you safely to: /TheCookbook/login.html?error=true
            response.sendRedirect(basePath + "/profile/login.html?error=true");
        }
    }
}