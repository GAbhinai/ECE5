
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/missions")
public class MissionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check student login.
        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Validate the logged-in student's ID.
        Object userIdObject = session.getAttribute("userId");

        if (!(userIdObject instanceof Integer)) {
            session.invalidate();
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) userIdObject;

        // 3. Get active missions that this student has not attempted.
        // Never expose correct_answer to the student-facing JSP.
        String sql =
                "SELECT m.mission_id, " +
                "m.title, " +
                "m.description, " +
                "m.category, " +
                "m.difficulty, " +
                "m.option_a, " +
                "m.option_b, " +
                "m.option_c, " +
                "m.option_d, " +
                "m.xp_reward " +
                "FROM missions m " +
                "WHERE m.is_active = 1 " +
                "AND NOT EXISTS ( " +
                "    SELECT 1 " +
                "    FROM mission_submissions s " +
                "    WHERE s.user_id = ? " +
                "    AND s.mission_id = m.mission_id " +
                ") " +
                "ORDER BY m.mission_id DESC";

        List<Map<String, Object>> missions = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> mission = new HashMap<>();

                    // Store the actual database mission ID.
                    mission.put("id", rs.getInt("mission_id"));

                    mission.put("title", rs.getString("title"));
                    mission.put("description",
                            rs.getString("description"));
                    mission.put("category", rs.getString("category"));
                    mission.put("difficulty",
                            rs.getString("difficulty"));

                    mission.put("a", rs.getString("option_a"));
                    mission.put("b", rs.getString("option_b"));
                    mission.put("c", rs.getString("option_c"));
                    mission.put("d", rs.getString("option_d"));

                    mission.put("xp", rs.getInt("xp_reward"));

                    missions.add(mission);
                }
            }

            // 4. Send the list to missions.jsp.
            request.setAttribute("missions", missions);

            request.getRequestDispatcher("/missions.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load active missions.", e);
        }
    }
}
