
package com.codequest.servlet;

import com.codequest.util.DBConnection;

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

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Check whether the student is logged in.
        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("userId") == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int userId;

        try {
            userId = ((Number) session.getAttribute("userId")).intValue();
        } catch (ClassCastException e) {
            session.invalidate();

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String sql =
            "SELECT u.username, u.xp, u.level, " +
            "(SELECT COUNT(*) " +
            " FROM mission_submissions s " +
            " WHERE s.user_id = u.user_id " +
            " AND s.is_correct = TRUE) AS completed " +
            "FROM users u " +
            "WHERE u.user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    session.invalidate();

                    response.sendRedirect(
                        request.getContextPath() + "/login.jsp"
                    );
                    return;
                }

                // Send student details to dashboard.jsp.
                request.setAttribute(
                    "studentName",
                    rs.getString("username")
                );

                request.setAttribute(
                    "studentXP",
                    rs.getInt("xp")
                );

                request.setAttribute(
                    "studentLevel",
                    rs.getInt("level")
                );

                request.setAttribute(
                    "completed",
                    rs.getInt("completed")
                );
            }

            // Display the dashboard.
            request.getRequestDispatcher("/dashboard.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            getServletContext().log(
                "Unable to retrieve student dashboard.", e
            );

            throw new ServletException(
                "Unable to retrieve student dashboard.", e
            );
        }
    }
}