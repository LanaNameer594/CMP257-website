import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/EditProfileServlet")
public class EditProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Read JSON data sent from script.js
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            sb.append(line);
        }
        
        // 2. Logic to parse JSON and update Database
        // (You'll use an UPDATE users SET firstname=?, lastname=? WHERE username=? query)
        
        response.setStatus(HttpServletResponse.SC_OK); // Tells JS "Success!"
    }
}