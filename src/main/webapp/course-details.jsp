
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.codequest.model.Course" %>

<%!
    public String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }
%>

<%
    Course course = (Course) request.getAttribute("course");

    List<Map<String, Object>> lessons =
        (List<Map<String, Object>>) request.getAttribute("lessons");

    if (course == null) {
        response.sendError(404, "Course not found.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title><%= escapeHtml(course.getTitle()) %> | CodeQuest</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/courses.css">
</head>

<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">

        <a class="navbar-brand fw-bold"
           href="<%= request.getContextPath() %>/dashboard">
            CodeQuest
        </a>

        <button class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#mainNavbar"
                aria-controls="mainNavbar"
                aria-expanded="false"
                aria-label="Toggle navigation">

            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">

            <ul class="navbar-nav ms-auto">

                <li class="nav-item">
                    <a class="nav-link"
                       href="<%= request.getContextPath() %>/dashboard">
                        Dashboard
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link active"
                       href="<%= request.getContextPath() %>/courses">
                        Courses
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="<%= request.getContextPath() %>/missions">
                        Missions
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="<%= request.getContextPath() %>/leaderboard">
                        Leaderboard
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="<%= request.getContextPath() %>/logout">
                        Logout
                    </a>
                </li>

            </ul>
        </div>
    </div>
</nav>

<!-- Course Header -->
<header class="courses-header">
    <div class="container">

        <a href="<%= request.getContextPath() %>/courses"
           class="btn btn-outline-light btn-sm mb-4">
            &larr; All Courses
        </a>

        <h1><%= escapeHtml(course.getTitle()) %></h1>

        <p><%= escapeHtml(course.getDescription()) %></p>

        <div class="mt-3">

            <span class="badge text-bg-light">
                <%= escapeHtml(course.getDifficulty()) %>
            </span>

            <span class="badge text-bg-light">
                <%= escapeHtml(course.getDuration()) %>
            </span>

        </div>

    </div>
</header>

<!-- Main Content -->
<main class="container py-5">

    <div class="row g-4">

        <!-- Course Information and Lessons -->
        <div class="col-lg-8">

            <!-- Course Overview -->
            <div class="card border-0 shadow-sm">

                <div class="card-body p-4">

                    <h2 class="h4 fw-bold mb-3">
                        Course Overview
                    </h2>

                    <p>
                        <%= escapeHtml(course.getDescription()) %>
                    </p>

                    <p>
                        <strong>Category:</strong>
                        <%= escapeHtml(course.getCategory()) %>
                    </p>

                    <p>
                        <strong>Instructor:</strong>
                        <%= escapeHtml(course.getInstructor()) %>
                    </p>

                </div>
            </div>

            <!-- Lessons -->
            <div class="mt-4">

                <h2 class="h4 fw-bold mb-3">
                    Course Lessons
                </h2>

                <%
                    if (lessons != null && !lessons.isEmpty()) {

                        for (Map<String, Object> lesson : lessons) {

                            Object lessonId = lesson.get("lesson_id");
                            Object lessonOrder = lesson.get("lesson_order");
                            Object lessonTitle = lesson.get("title");
                %>

                <div class="card border-0 shadow-sm mb-3">

                    <div class="card-body d-flex
                                justify-content-between
                                align-items-center gap-3">

                        <div>

                            <h3 class="h6 fw-bold mb-2">

                                Lesson <%= lessonOrder != null
                                    ? lessonOrder : "" %>:

                                <%= escapeHtml(
                                    lessonTitle != null
                                        ? lessonTitle.toString()
                                        : "Untitled Lesson"
                                ) %>

                            </h3>

                            <small class="text-muted">
                                Course lesson
                            </small>

                        </div>

                        <%
                            if (lessonId != null) {
                        %>

                        <a class="btn btn-primary btn-sm"
                           href="<%= request.getContextPath() %>/lesson?id=<%= lessonId %>">

                            Start Lesson

                        </a>

                        <%
                            }
                        %>

                    </div>
                </div>

                <%
                        }

                    } else {
                %>

                <div class="alert alert-info">

                    Lessons have not been added to this course yet.

                </div>

                <%
                    }
                %>

            </div>

        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">

            <div class="card border-0 shadow-sm">

                <div class="card-body p-4">

                    <h2 class="h5 fw-bold">
                        What You'll Learn
                    </h2>

                    <ul class="mt-3">

                        <li>Understand the core concepts.</li>

                        <li>Learn through individual lessons.</li>

                        <li>Practise the concepts with questions.</li>

                        <li>Build your programming skills.</li>

                    </ul>

                    <a href="<%= request.getContextPath() %>/missions"
                       class="btn btn-outline-primary w-100 mt-3">

                        Explore Coding Missions

                    </a>

                </div>
            </div>

        </div>

    </div>

</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
