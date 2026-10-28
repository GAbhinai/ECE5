
package com.codequest.servlet;

import com.codequest.dao.CourseDAO;
import com.codequest.model.Course;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/course-details")
public class CourseDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CourseDAO courseDAO;

    @Override
    public void init() {
        courseDAO = new CourseDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        // Validate the course ID
        if (id == null || !id.matches("\\d+")) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid course ID."
            );
            return;
        }

        try {
            int courseId = Integer.parseInt(id);

            // Retrieve course information
            Course course = courseDAO.getCourseById(courseId);

            if (course == null) {
                response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Course not found."
                );
                return;
            }

            // Retrieve lessons using CourseDAO
            List<Map<String, Object>> lessons =
                courseDAO.getLessonsByCourseId(courseId);

            // Send data to JSP
            request.setAttribute("course", course);
            request.setAttribute("lessons", lessons);

            request.getRequestDispatcher("/course-details.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            getServletContext().log(
                "Unable to retrieve course details.", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load course details."
            );
        }
    }
}
