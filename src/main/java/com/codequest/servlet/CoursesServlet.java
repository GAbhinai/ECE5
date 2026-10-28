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

@WebServlet("/courses")
public class CoursesServlet extends HttpServlet {

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

        try {

            List<Course> courses = courseDAO.getAllCourses();

            request.setAttribute("courses", courses);

            request.getRequestDispatcher("/courses.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            getServletContext().log(
                "Unable to retrieve courses from the database.", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load courses. Please try again later."
            );
        }
    }
}