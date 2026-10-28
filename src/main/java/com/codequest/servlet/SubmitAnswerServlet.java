
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

@WebServlet("/submit-answer")
public class SubmitAnswerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check student session
        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Validate student ID
        Object userIdObject = session.getAttribute("userId");

        int userId;

        try {
            if (userIdObject instanceof Integer) {
                userId = (Integer) userIdObject;
            } else {
                userId = Integer.parseInt(
                        userIdObject.toString());
            }
        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Invalid student session");
            return;
        }

        if (userId <= 0) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Invalid student ID");
            return;
        }

        // 3. Get request parameters
        String missionIdText =
                request.getParameter("missionId");

        String answer =
                request.getParameter("answer");

        // 4. Validate mission ID
        if (missionIdText == null ||
                missionIdText.trim().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Mission ID is missing");
            return;
        }

        int missionId;

        try {
            missionId = Integer.parseInt(
                    missionIdText.trim());
        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid mission ID: " + missionIdText);
            return;
        }

        if (missionId <= 0) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Mission ID must be a positive number");
            return;
        }

        // 5. Validate selected answer
        if (answer == null ||
                !answer.matches("[ABCD]")) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Please select a valid answer");
            return;
        }

        boolean correct = false;
        int awardedXP = 0;

        // 6. Process submission
        try (Connection con =
                     DBConnection.getConnection()) {

            if (con == null) {
                throw new SQLException(
                        "Database connection is unavailable");
            }

            con.setAutoCommit(false);

            try {

                // Check whether the mission exists
                // and retrieve its correct answer and XP.
                String missionSql =
                        "SELECT correct_answer, xp_reward " +
                        "FROM missions " +
                        "WHERE mission_id = ? AND is_active = 1";

                try (PreparedStatement ps =
                             con.prepareStatement(missionSql)) {

                    ps.setInt(1, missionId);

                    try (ResultSet rs =
                                 ps.executeQuery()) {

                        if (!rs.next()) {

                            con.rollback();

                            response.sendError(
                                    HttpServletResponse.SC_BAD_REQUEST,
                                    "Mission not found or inactive");
                            return;
                        }

                        String correctAnswer =
                                rs.getString("correct_answer");

                        correct = answer.equalsIgnoreCase(
                                correctAnswer);

                        if (correct) {
                            awardedXP =
                                    rs.getInt("xp_reward");
                        }
                    }
                }

                // Insert the student's submission.
                // The database should have a UNIQUE constraint
                // on (user_id, mission_id) to prevent duplicates.
                String insertSql =
                        "INSERT INTO mission_submissions " +
                        "(user_id, mission_id, selected_answer, " +
                        "is_correct, xp_awarded) " +
                        "VALUES (?, ?, ?, ?, ?)";

                try (PreparedStatement ps =
                             con.prepareStatement(insertSql)) {

                    ps.setInt(1, userId);
                    ps.setInt(2, missionId);
                    ps.setString(3, answer);
                    ps.setBoolean(4, correct);
                    ps.setInt(5, awardedXP);

                    ps.executeUpdate();
                }

                // Award XP only for a correct answer.
                if (correct && awardedXP > 0) {

                    String updateSql =
                            "UPDATE users SET " +
                            "xp = xp + ?, " +
                            "level = FLOOR((xp + ?) / 100) + 1 " +
                            "WHERE user_id = ?";

                    try (PreparedStatement ps =
                                 con.prepareStatement(updateSql)) {

                        ps.setInt(1, awardedXP);
                        ps.setInt(2, awardedXP);
                        ps.setInt(3, userId);

                        int updatedRows =
                                ps.executeUpdate();

                        if (updatedRows != 1) {
                            throw new SQLException(
                                    "Student account not found");
                        }
                    }
                }

                // Commit submission and XP changes together.
                con.commit();

            } catch (SQLException e) {

                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    e.addSuppressed(rollbackError);
                }

                // MySQL duplicate-key error.
                if (e.getErrorCode() == 1062) {

                    response.sendRedirect(
                            "missions?error=alreadyAttempted");
                    return;
                }

                throw e;
            }

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to submit answer. " +
                    "Check the database schema and connection.",
                    e);
        }

        // 7. Store result for the result page.
        session.setAttribute(
                "resultCorrect", correct);

        session.setAttribute(
                "resultXP", awardedXP);

        // 8. Redirect to result page.
        response.sendRedirect("mission-result.jsp");
    }
}
