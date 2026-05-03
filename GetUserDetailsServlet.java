import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/GetUserDetailsServlet")
public class GetUserDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        String username = (String) session.getAttribute("loggedInUser");
        UserManager um = new UserManager();
        
        // Ensure you added the getUserDetails method to your UserManager from our previous messages!
        String[] details = um.getUserDetails(username); 
        
        if (details != null) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            // Send data to Javascript as JSON
            out.print("{\"firstName\":\"" + details[0] + "\", \"lastName\":\"" + details[1] + "\", \"email\":\"" + details[2] + "\", \"username\":\"" + username + "\"}");
            out.flush();
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}