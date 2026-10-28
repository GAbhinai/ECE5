
package com.codequest.servlet;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/delete-question")
public class DeleteQuestionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Admin login required");
            return;
        }

        int missionId;

        try {
            missionId = Integer.parseInt(
                request.getParameter("missionId"));

            if (missionId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException | NullPointerException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid question ID");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                // Check whether the question exists
                boolean exists;

                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT mission_id FROM missions " +
                        "WHERE mission_id = ? FOR UPDATE")) {

                    ps.setInt(1, missionId);

                    try (ResultSet rs = ps.executeQuery()) {
                        exists = rs.next();
                    }
                }

                if (!exists) {
                    con.rollback();
                    response.sendRedirect(
                        "view-questions?error=notfound");
                    return;
                }

                // Check for existing student submissions
                boolean hasSubmissions;

                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT 1 FROM mission_submissions " +
                        "WHERE mission_id = ? LIMIT 1")) {

                    ps.setInt(1, missionId);

                    try (ResultSet rs = ps.executeQuery()) {
                        hasSubmissions = rs.next();
                    }
                }

                if (hasSubmissions) {

                    // Preserve history; hide this question
                    try (PreparedStatement ps =
                            con.prepareStatement(
                                "UPDATE missions SET is_active = 0 " +
                                "WHERE mission_id = ?")) {

                        ps.setInt(1, missionId);
                        ps.executeUpdate();
                    }

                    con.commit();

                    response.sendRedirect(
                        "view-questions?deactivated=1");
                    return;

                } else {

                    // No submissions: permanently delete it
                    try (PreparedStatement ps =
                            con.prepareStatement(
                                "DELETE FROM missions " +
                                "WHERE mission_id = ?")) {

                        ps.setInt(1, missionId);
                        ps.executeUpdate();
                    }

                    con.commit();

                    response.sendRedirect(
                        "view-questions?deleted=1");
                }

            } catch (SQLException e) {
                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    e.addSuppressed(rollbackError);
                }

                throw e;
            }

        } catch (SQLException e) {
            getServletContext().log(
                "Failed to delete/deactivate mission " + missionId,
                e);

            response.sendRedirect(
                "view-questions?error=deletefailed");
        }
    }
}
