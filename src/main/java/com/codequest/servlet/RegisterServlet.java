
package com.codequest.servlet;

import com.codequest.util.DBConnection;
import com.codequest.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");

        if (username == null || email == null ||
            password == null || confirm == null ||
            !username.matches("[A-Za-z0-9_]{3,50}") ||
            !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$") ||
            password.length() < 8 || password.length() > 128 ||
            !password.equals(confirm)) {

            response.sendRedirect(
                "register.jsp?error=Invalid+input"
            );
            return;
        }

        String sql = "INSERT INTO users " +
            "(username,email,password_hash,xp,level) " +
            "VALUES (?,?,?,0,1)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, PasswordUtil.hash(password));
            ps.executeUpdate();

            response.sendRedirect("login.jsp?registered=1");

        } catch (SQLIntegrityConstraintViolationException e) {
            response.sendRedirect(
                "register.jsp?error=Username+or+email+already+exists"
            );
        } catch (Exception e) {
            throw new ServletException(
                "Unable to register student", e
            );
        }
    }
}
