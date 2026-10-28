
package com.codequest.servlet;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/leaderboard")
public class LeaderboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> players = new ArrayList<>();

        String sql = "SELECT u.username,u.xp,u.level," +
            "(SELECT COUNT(*) FROM mission_submissions s " +
            " WHERE s.user_id=u.user_id AND s.is_correct=TRUE) " +
            "AS completed FROM users u " +
            "ORDER BY u.xp DESC,u.user_id ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            int rank = 0;

            while (rs.next()) {
                rank++;

                Map<String, Object> player = new HashMap<>();
                player.put("rank", rank);
                player.put("username", rs.getString("username"));
                player.put("xp", rs.getInt("xp"));
                player.put("level", rs.getInt("level"));
                player.put("completed", rs.getInt("completed"));

                players.add(player);
            }

            request.setAttribute("players", players);

            request.getRequestDispatcher("/leaderboard.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load leaderboard", e);
        }
    }
}
