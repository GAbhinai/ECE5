<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
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
    List<Course> courses =
        (List<Course>) request.getAttribute("courses");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>CodeQuest | Courses</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/courses.css">
</head>

<body>

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

<header class="courses-header text-center">
    <div class="container">
        <h1>Explore Courses</h1>

        <p>
            Learn new skills, practise coding, and level up with CodeQuest.
        </p>
    </div>
</header>

<main class="container py-5">

    <div class="row mb-4">
        <div class="col-md-7">
            <h2 class="fw-bold">Available Courses</h2>
            <p class="text-muted">
                Choose a course and start learning at your own pace.
            </p>
        </div>
    </div>

    <div class="row g-4">

        <%
            if (courses != null && !courses.isEmpty()) {

                for (Course course : courses) {
        %>

        <div class="col-md-6 col-lg-4">

            <div class="card course-card h-100">

                <div class="course-banner">
                    <span>
                        <%= escapeHtml(course.getCategory()) %>
                    </span>
                </div>

                <div class="card-body d-flex flex-column">

                    <h5 class="card-title fw-bold">
                        <%= escapeHtml(course.getTitle()) %>
                    </h5>

                    <p class="card-text text-muted">
                        <%= escapeHtml(course.getDescription()) %>
                    </p>

                    <div class="course-meta mt-auto mb-3">

                        <span class="badge text-bg-primary">
                            <%= escapeHtml(course.getDifficulty()) %>
                        </span>

                        <span class="badge text-bg-secondary">
                            <%= escapeHtml(course.getDuration()) %>
                        </span>

                    </div>

                    <p class="small text-muted">
                        Instructor:
                        <%= escapeHtml(course.getInstructor()) %>
                    </p>

                    <a class="btn btn-primary w-100"
                       href="<%= request.getContextPath() %>/course-details?id=<%= course.getCourseId() %>">
                        View Course
                    </a>

                </div>
            </div>
        </div>

        <%
                }

            } else {
        %>

        <div class="col-12">
            <div class="alert alert-info">
                No courses are available right now.
            </div>
        </div>

        <%
            }
        %>

    </div>
</main>

<footer class="text-center py-4 text-muted">
    <p class="mb-0">&copy; 2026 CodeQuest. Keep learning and coding.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>