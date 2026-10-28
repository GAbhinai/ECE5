
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

@WebServlet("/view-questions")
public class ViewQuestionsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        List<Map<String, Object>> questions = new ArrayList<>();

        String sql =
            "SELECT mission_id, title, description, category, " +
            "difficulty, option_a, option_b, option_c, option_d, " +
            "correct_answer, xp_reward " +
            "FROM missions " +
            "WHERE is_active = 1 " +
            "ORDER BY mission_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> q = new HashMap<>();

                q.put("id", rs.getInt("mission_id"));
                q.put("title", rs.getString("title"));
                q.put("description", rs.getString("description"));
                q.put("category", rs.getString("category"));
                q.put("difficulty", rs.getString("difficulty"));
                q.put("a", rs.getString("option_a"));
                q.put("b", rs.getString("option_b"));
                q.put("c", rs.getString("option_c"));
                q.put("d", rs.getString("option_d"));
                q.put("answer", rs.getString("correct_answer"));
                q.put("xp", rs.getInt("xp_reward"));

                questions.add(q);
            }

            request.setAttribute("questions", questions);

            request.getRequestDispatcher("/view-questions.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load programming questions", e);
        }
    }
}
