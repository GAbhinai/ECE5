
package com.codequest.servlet;

import com.codequest.util.DBConnection;
import com.codequest.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String identity = request.getParameter("identity");
        String password = request.getParameter("password");

        String contextPath = request.getContextPath();
        String loginPage = contextPath + "/login.jsp";

        // Validate the submitted fields.
        if (identity == null || password == null
                || identity.trim().isEmpty()
                || password.isEmpty()) {

            response.sendRedirect(loginPage + "?error=invalid");
            return;
        }

        String sql =
            "SELECT user_id, username, password_hash " +
            "FROM users " +
            "WHERE username = ? OR email = ? " +
            "LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, identity.trim());
            ps.setString(2, identity.trim());

            try (ResultSet rs = ps.executeQuery()) {

                // Student account not found.
                if (!rs.next()) {
                    response.sendRedirect(loginPage + "?error=invalid");
                    return;
                }

                int userId = rs.getInt("user_id");
                String username = rs.getString("username");
                String storedPassword = rs.getString("password_hash");

                if (storedPassword == null || storedPassword.isEmpty()) {
                    response.sendRedirect(loginPage + "?error=invalid");
                    return;
                }

                // Verify the submitted password.
                boolean passwordMatches;

                try {
                    passwordMatches =
                        PasswordUtil.verify(password, storedPassword);

                } catch (Exception e) {

                    getServletContext().log(
                        "Password verification failed for user ID "
                        + userId, e
                    );

                    response.sendRedirect(loginPage + "?error=invalid");
                    return;
                }

                if (!passwordMatches) {
                    response.sendRedirect(loginPage + "?error=invalid");
                    return;
                }

                // Invalidate the previous session, if present.
                HttpSession oldSession = request.getSession(false);

                if (oldSession != null) {
                    oldSession.invalidate();
                }

                // Create a new authenticated session.
                HttpSession session = request.getSession(true);

                session.setAttribute("userId", userId);
                session.setAttribute("username", username);
                session.setMaxInactiveInterval(30 * 60);

                // Login successful: open the Student Portal.
                response.sendRedirect(contextPath + "/dashboard");
            }

        } catch (SQLException e) {

            getServletContext().log(
                "Database error during student login.", e
            );

            response.sendRedirect(loginPage + "?error=server");

        } catch (Exception e) {

            getServletContext().log(
                "Unexpected error during student login.", e
            );

            response.sendRedirect(loginPage + "?error=server");
        }
    }
}
