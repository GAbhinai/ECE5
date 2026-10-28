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

@WebServlet("/admin-students")
public class AdminStudentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect("admin-login.jsp");
            return;
        }

        List<Map<String, Object>> students = new ArrayList<>();

        String sql =
            "SELECT " +
            "u.user_id, " +
            "u.username, " +
            "u.email, " +
            "COALESCE(SUM(m.xp_reward), 0) AS total_xp, " +
            "COUNT(DISTINCT s.mission_id) AS completed_missions " +
            "FROM users u " +
            "LEFT JOIN mission_submissions s " +
            "ON u.user_id = s.user_id " +
            "LEFT JOIN missions m " +
            "ON s.mission_id = m.mission_id " +
            "GROUP BY u.user_id, u.username, u.email " +
            "ORDER BY total_xp DESC, u.username ASC";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Map<String, Object> student = new HashMap<>();

                student.put("id", rs.getInt("user_id"));
                student.put("username", rs.getString("username"));
                student.put("email", rs.getString("email"));
                student.put("xp", rs.getInt("total_xp"));
                student.put(
                    "completed",
                    rs.getInt("completed_missions")
                );

                students.add(student);
            }

        } catch (SQLException e) {

            throw new ServletException(
                "Unable to load registered students. " +
                "Please check your database table and column names.",
                e
            );
        }

        request.setAttribute("students", students);

        request.getRequestDispatcher("/admin-students.jsp")
               .forward(request, response);
    }
}