
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
import java.util.HashSet;
import java.util.Set;

@WebServlet("/submit-all-answers")
public class SubmitAllAnswersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        // 1. Validate student login.
        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Object userIdObject = session.getAttribute("userId");

        if (!(userIdObject instanceof Integer)) {
            session.invalidate();
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) userIdObject;

        // 2. Retrieve all submitted mission IDs.
        String[] missionIds = request.getParameterValues("missionIds");

        if (missionIds == null || missionIds.length == 0) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "No missions were submitted.");
            return;
        }

        // Prevent duplicate mission IDs in the submitted request.
        Set<Integer> uniqueMissionIds = new HashSet<>();

        for (String idText : missionIds) {

            if (idText == null || !idText.trim().matches("[1-9]\\d*")) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid mission ID.");
                return;
            }

            try {
                int id = Integer.parseInt(idText.trim());

                if (!uniqueMissionIds.add(id)) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Duplicate mission ID.");
                    return;
                }

            } catch (NumberFormatException e) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Mission ID is out of range.");
                return;
            }
        }

        int correctCount = 0;
        int totalXP = 0;

        // 3. Process all answers in one transaction.
        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {

                String checkSql =
                        "SELECT correct_answer, xp_reward " +
                        "FROM missions " +
                        "WHERE mission_id = ? AND is_active = 1 " +
                        "FOR UPDATE";

                String insertSql =
                        "INSERT INTO mission_submissions " +
                        "(user_id, mission_id, selected_answer, " +
                        "is_correct, xp_awarded) " +
                        "VALUES (?, ?, ?, ?, ?)";

                try (PreparedStatement checkStatement =
                             con.prepareStatement(checkSql);
                     PreparedStatement insertStatement =
                             con.prepareStatement(insertSql)) {

                    for (Integer missionId : uniqueMissionIds) {

                        // 4. Verify the mission exists and is active.
                        checkStatement.setInt(1, missionId);

                        String correctAnswer;
                        int reward;

                        try (ResultSet rs =
                                     checkStatement.executeQuery()) {

                            if (!rs.next()) {
                                throw new IllegalArgumentException(
                                        "Mission " + missionId +
                                        " does not exist or is inactive.");
                            }

                            correctAnswer =
                                    rs.getString("correct_answer");

                            reward = rs.getInt("xp_reward");
                        }

                        // 5. Get the answer associated with this mission.
                        String answer = request.getParameter(
                                "answer_" + missionId);

                        if (answer == null ||
                                !answer.matches("[ABCD]")) {
                            throw new IllegalArgumentException(
                                    "Please answer every question.");
                        }

                        // 6. Calculate the reward.
                        boolean isCorrect =
                                answer.equalsIgnoreCase(correctAnswer);

                        int awardedXP = isCorrect ? reward : 0;

                        // 7. Save the student's answer.
                        insertStatement.setInt(1, userId);
                        insertStatement.setInt(2, missionId);
                        insertStatement.setString(3, answer);
                        insertStatement.setBoolean(4, isCorrect);
                        insertStatement.setInt(5, awardedXP);

                        insertStatement.executeUpdate();

                        if (isCorrect) {
                            correctCount++;
                            totalXP += awardedXP;
                        }
                    }
                }

                // 8. Award the total XP for all correct answers.
                if (totalXP > 0) {

                    String updateXP =
                            "UPDATE users SET " +
                            "xp = xp + ?, " +
                            "level = FLOOR((xp + ?) / 100) + 1 " +
                            "WHERE user_id = ?";

                    try (PreparedStatement ps =
                                 con.prepareStatement(updateXP)) {

                        ps.setInt(1, totalXP);
                        ps.setInt(2, totalXP);
                        ps.setInt(3, userId);

                        if (ps.executeUpdate() != 1) {
                            throw new SQLException(
                                    "Student account was not found.");
                        }
                    }
                }

                // Save everything only if all answers were processed.
                con.commit();

            } catch (Exception e) {

                con.rollback();

                if (e instanceof IllegalArgumentException) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            e.getMessage());
                    return;
                }

                if (e instanceof SQLException &&
                        ((SQLException) e).getErrorCode() == 1062) {

                    response.sendRedirect(
                            "missions?error=alreadyAttempted");
                    return;
                }

                throw e;

            } finally {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException ignored) {
                    // Connection will close automatically.
                }
            }

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to submit all answers.", e);
        }

        // 9. Store the results for the result page.
        session.setAttribute("resultCorrect", correctCount);
        session.setAttribute("resultXP", totalXP);
        session.setAttribute("resultTotal", uniqueMissionIds.size());

        // Redirect to the existing mission result page.
        response.sendRedirect("mission-result.jsp");
    }
}
