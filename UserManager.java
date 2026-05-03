import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserManager {

    public boolean loginUser(String typedUsername, String typedPassword) {
        // The SQL query using your exact table column names
        String selectQuery = "SELECT * FROM users WHERE username = ? AND password_hash = ?";

        // Try-with-resources (Notice: NO semicolon at the end, just an opening curly brace!)
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(selectQuery)) {

            // Plug the typed credentials into the ? placeholders
            pstmt.setString(1, typedUsername);
            pstmt.setString(2, typedPassword);

            // Execute the query and store the results
            try (ResultSet rs = pstmt.executeQuery()) {
                
                // If rs.next() is true, it means the database found a matching row!
                if (rs.next()) {
                    // You can access other columns from that user's row like this:
                    String userEmail = rs.getString("email");
                    
                    System.out.println("Login Successful! Welcome, " + typedUsername);
                    System.out.println("Email on file: " + userEmail);
                    return true;
                } else {
                    System.out.println("Login Failed: Incorrect username or password.");
                    return false;
                }
            }

        } catch (SQLException e) {
            System.out.println("Database Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}