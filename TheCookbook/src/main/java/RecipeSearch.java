import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/RecipeSearch")
public class RecipeSearch extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set up the response to send JSON back to your JavaScript
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String searchQuery = request.getParameter("q");
        // String filterTag = request.getParameter("tag"); // Ready for when you want to filter by course/tag

        String url = "jdbc:mysql://localhost:3306/cookbook_app";
        String user = "root";        
        String password = "Iicba0802"; 

        try {
            // Load the MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);

            // FIX: Added all selected columns to GROUP BY to prevent MySQL strict mode crashes
            String sql = "SELECT r.recipe_name, r.img_src, r.directions, " +
                    "GROUP_CONCAT(i.name SEPARATOR ', ') AS ingredient_list " +
                    "FROM recipes r " +
                    "LEFT JOIN recipe_ingredients ri ON r.recipe_id = ri.recipe_id " +
                    "LEFT JOIN ingredients i ON ri.ingredient_id = i.ingredient_id " +
                    "WHERE (r.recipe_name LIKE ? OR i.name LIKE ?) " +
                    "GROUP BY r.recipe_id, r.recipe_name, r.img_src, r.directions";

            PreparedStatement st = conn.prepareStatement(sql);
            String searchPattern = "%" + (searchQuery != null ? searchQuery : "") + "%";
            st.setString(1, searchPattern);
            st.setString(2, searchPattern);

            ResultSet rs = st.executeQuery();

            StringBuilder json = new StringBuilder("[");
            
            while (rs.next()) {
                // FIX: Null checks added for every column to prevent NullPointerExceptions
                
                String rawName = rs.getString("recipe_name");
                String name = (rawName != null) ? rawName.replace("\"", "\\\"") : "Unknown Recipe";
                
                String rawImg = rs.getString("img_src");
                String img = (rawImg != null) ? rawImg : ""; 
                
                String rawIngredients = rs.getString("ingredient_list");
                String ingredients = (rawIngredients != null) ? rawIngredients.replace("\"", "\\\"") : "No ingredients listed";
                
                String rawDirections = rs.getString("directions");
                String directions = (rawDirections != null) ? rawDirections.replace("\"", "\\\"").replace("\n", "<br>") : "No instructions provided.";

                // FIX: Using the sanitized variables to build the JSON string
                json.append("{")
                    .append("\"name\":\"").append(name).append("\",")
                    .append("\"image\":\"").append(img).append("\",") 
                    .append("\"ingredients\":\"").append(ingredients).append("\",")
                    .append("\"instructions\":\"").append(directions).append("\"") 
                    .append("},");
            } // FIX: Added the missing closing brace for the while loop!
            
            // Remove the trailing comma if we added any recipes
            if (json.length() > 1) {
                json.setLength(json.length() - 1); 
            }
            json.append("]");

            out.print(json.toString());
            
            rs.close();
            st.close();
            conn.close();
            
        } catch (Exception e) {
            // This will print the exact crash reason in your Eclipse Console
            e.printStackTrace(); 
            response.setStatus(500);
            out.print("[]"); // Send empty JSON array to prevent JS frontend from crashing
        }
    }
}