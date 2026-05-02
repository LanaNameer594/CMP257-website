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

@WebServlet("/GetShoppingListServlet")
public class GetShoppingListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"error\": \"User not logged in\"}");
            out.flush();
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT sl.item_id, sl.is_checked, i.name, i.unit " +
                 "FROM shopping_list sl " +
                 "JOIN ingredients i ON sl.ingredient_id = i.ingredient_id " +
                 "WHERE sl.user_id = ?"
             )) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                StringBuilder jsonBuilder = new StringBuilder("[");
                boolean first = true;

                while (rs.next()) {
                    if (!first) {
                        jsonBuilder.append(",");
                    }
                    first = false;

                    String name = rs.getString("name") != null ? rs.getString("name").replace("\"", "\\\"") : "";
                    String unit = rs.getString("unit") != null ? rs.getString("unit") : "";

                    jsonBuilder.append("{")
                        .append("\"item_id\": ").append(rs.getInt("item_id")).append(",")
                        .append("\"name\": \"").append(name).append("\",")
                        .append("\"unit\": \"").append(unit).append("\",")
                        .append("\"is_checked\": ").append(rs.getBoolean("is_checked"))
                        .append("}");
                }
                jsonBuilder.append("]");

                out.print(jsonBuilder.toString());
                out.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("[]");
            out.flush();
        }
    }
}