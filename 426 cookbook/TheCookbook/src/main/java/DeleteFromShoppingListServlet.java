import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/DeleteFromShoppingListServlet")
public class DeleteFromShoppingListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Retrieve the current session (do not create a new one if it doesn't exist)
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Option 1: Remove the shopping list attribute from the session
            session.removeAttribute("shopping_list");
            
            // Option 2: If your list is an active list object that you want to clear instead of removing:
            // List<Object> list = (List<Object>) session.getAttribute("shopping_list");
            // if (list != null) {
            //     list.clear();
            // }
            
            // Note: If your app uses a Database, call your DAO here to delete items from the database.
            // ShoppingListDAO dao = new ShoppingListDAO();
            // dao.clearList(userId);
        }

        // Send a successful JSON or text response back to the client
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("{\"message\": \"Shopping list cleared successfully\"}");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle GET requests by forwarding to the POST method to allow flexibility
        doPost(request, response);
    }
}