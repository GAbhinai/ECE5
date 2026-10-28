
package com.codequest.dao;

import com.codequest.model.Course;
import com.codequest.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class CourseDAO {

    // Retrieve all active courses
    public List<Course> getAllCourses() throws SQLException {

        List<Course> courses = new ArrayList<>();

        String sql =
            "SELECT course_id, title, description, category, " +
            "difficulty, duration, instructor, image_url " +
            "FROM courses " +
            "WHERE is_active = TRUE " +
            "ORDER BY course_id DESC";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Course course = new Course();

                course.setCourseId(rs.getInt("course_id"));
                course.setTitle(rs.getString("title"));
                course.setDescription(rs.getString("description"));
                course.setCategory(rs.getString("category"));
                course.setDifficulty(rs.getString("difficulty"));
                course.setDuration(rs.getString("duration"));
                course.setInstructor(rs.getString("instructor"));
                course.setImageUrl(rs.getString("image_url"));

                courses.add(course);
            }
        }

        return courses;
    }

    // Retrieve one active course using its ID
    public Course getCourseById(int courseId) throws SQLException {

        Course course = null;

        String sql =
            "SELECT course_id, title, description, category, " +
            "difficulty, duration, instructor, image_url " +
            "FROM courses " +
            "WHERE course_id = ? AND is_active = TRUE";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, courseId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    course = new Course();

                    course.setCourseId(rs.getInt("course_id"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setCategory(rs.getString("category"));
                    course.setDifficulty(rs.getString("difficulty"));
                    course.setDuration(rs.getString("duration"));
                    course.setInstructor(rs.getString("instructor"));
                    course.setImageUrl(rs.getString("image_url"));
                }
            }
        }

        return course;
    }

    // Retrieve all lessons belonging to a course
    public List<Map<String, Object>> getLessonsByCourseId(
            int courseId) throws SQLException {

        List<Map<String, Object>> lessons = new ArrayList<>();

        String sql =
            "SELECT lesson_id, course_id, title, content, lesson_order " +
            "FROM course_lessons " +
            "WHERE course_id = ? " +
            "ORDER BY lesson_order ASC";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, courseId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> lesson = new LinkedHashMap<>();

                    lesson.put("lesson_id", rs.getInt("lesson_id"));
                    lesson.put("course_id", rs.getInt("course_id"));
                    lesson.put("title", rs.getString("title"));
                    lesson.put("content", rs.getString("content"));
                    lesson.put("lesson_order", rs.getInt("lesson_order"));

                    lessons.add(lesson);
                }
            }
        }

        return lessons;
    }

    // Retrieve one lesson using its ID
    public Map<String, Object> getLessonById(
            int lessonId) throws SQLException {

        Map<String, Object> lesson = null;

        String sql =
            "SELECT lesson_id, course_id, title, content, lesson_order " +
            "FROM course_lessons " +
            "WHERE lesson_id = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, lessonId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    lesson = new LinkedHashMap<>();

                    lesson.put("lesson_id", rs.getInt("lesson_id"));
                    lesson.put("course_id", rs.getInt("course_id"));
                    lesson.put("title", rs.getString("title"));
                    lesson.put("content", rs.getString("content"));
                    lesson.put("lesson_order", rs.getInt("lesson_order"));
                }
            }
        }

        return lesson;
    }
}
