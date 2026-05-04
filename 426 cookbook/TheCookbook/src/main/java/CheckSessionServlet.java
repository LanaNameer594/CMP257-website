import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/check-session")
public class CheckSessionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Grab the session, but DO NOT create a new one if it doesn't exist
        HttpSession session = request.getSession(false); 
        
        // Assuming you saved a "user" or "userId" attribute when they logged in
        if (session != null && session.getAttribute("userId") != null) {
            // User is logged in!
            response.setStatus(HttpServletResponse.SC_OK); 
        } else {
            // NO user logged in! Send the 401 Error!
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
        }
    }
}