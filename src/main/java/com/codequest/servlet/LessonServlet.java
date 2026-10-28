package com.codequest.servlet;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.HashMap;
import java.util.Map;

@WebServlet("/lesson")
public class LessonServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        if (id == null || !id.matches("\\d+")) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid lesson ID."
            );
            return;
        }

        int lessonId = Integer.parseInt(id);

        String sql =
            "SELECT l.lesson_id, l.lesson_title, l.lesson_order, " +
            "l.lesson_content, l.estimated_minutes, " +
            "c.course_id, c.title AS course_title " +
            "FROM lessons l " +
            "JOIN courses c ON l.course_id = c.course_id " +
            "WHERE l.lesson_id = ? " +
            "AND l.is_active = TRUE " +
            "AND c.is_active = TRUE";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, lessonId);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Lesson not found."
                    );
                    return;
                }

                Map<String, Object> lesson = new HashMap<>();

                lesson.put("id", rs.getInt("lesson_id"));
                lesson.put("title", rs.getString("lesson_title"));
                lesson.put("order", rs.getInt("lesson_order"));
                lesson.put("content", rs.getString("lesson_content"));
                lesson.put("minutes", rs.getInt("estimated_minutes"));
                lesson.put("courseId", rs.getInt("course_id"));
                lesson.put("courseTitle", rs.getString("course_title"));

                request.setAttribute("lesson", lesson);

                request.getRequestDispatcher("/lesson.jsp")
                       .forward(request, response);
            }

        } catch (SQLException e) {

            getServletContext().log(
                "Unable to retrieve lesson.", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load lesson."
            );
        }
    }
}