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
    
    public boolean registerUser(String fName, String lName, String uName, String email, String pass) {
        // Exact column names from your SQL: firstname, lastname, username, password_hash, email
        String sql = "INSERT INTO users (firstname, lastname, username, password_hash, email) VALUES (?, ?, ?, ?, ?)";

        try {
            // Forces the driver to load safely within the current context
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Try-with-resources ensures the connection closes, preventing "Illegal Access" errors
            try (Connection conn = DBConnection.getConnection(); 
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                
                pstmt.setString(1, fName);
                pstmt.setString(2, lName);
                pstmt.setString(3, uName);
                pstmt.setString(4, pass); // Matches your SQL 'password_hash' column
                pstmt.setString(5, email);

                return pstmt.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException | SQLException e) {
            // Check the Console for "Duplicate entry" or "Unknown column"
            e.printStackTrace();
            return false;
        }
    }
    
 // Retrieves a user's details based on their username
    public String[] getUserDetails(String username) {
        String query = "SELECT firstname, lastname, email FROM users WHERE username = ?";
        String[] userDetails = new String[3]; // Array to hold [firstName, lastName, email]

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            // Put the logged-in username into the query
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                // If we found the user in the database, grab their data!
                if (rs.next()) {
                    userDetails[0] = rs.getString("firstname");
                    userDetails[1] = rs.getString("lastname");
                    userDetails[2] = rs.getString("email");
                    return userDetails;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error fetching user details: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null; // Return null if the user isn't found or an error occurs
    }
}