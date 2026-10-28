<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.Map" %>

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
    Map<String, Object> lesson =
        (Map<String, Object>) request.getAttribute("lesson");

    if (lesson == null) {
        response.sendError(404, "Lesson not found.");
        return;
    }

    int courseId = (Integer) lesson.get("courseId");

    String content = (String) lesson.get("content");

    if (content == null) {
        content = "";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>
        <%= escapeHtml(String.valueOf(lesson.get("title"))) %>
        | CodeQuest
    </title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/courses.css">

    <style>
        .lesson-content {
            white-space: pre-wrap;
            overflow-wrap: anywhere;
            line-height: 1.8;
            font-size: 1.05rem;
        }
    </style>
</head>

<body>

<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand fw-bold"
           href="<%= request.getContextPath() %>/courses">
            CodeQuest
        </a>

        <a class="btn btn-outline-light btn-sm"
           href="<%= request.getContextPath() %>/course-details?id=<%= courseId %>">
            Back to Course
        </a>
    </div>
</nav>

<main class="container py-5">

    <div class="row justify-content-center">
        <div class="col-lg-9">

            <div class="mb-4">
                <p class="text-muted">
                    <%= escapeHtml(
                        String.valueOf(lesson.get("courseTitle"))
                    ) %>
                </p>

                <h1 class="fw-bold">
                    Lesson <%= lesson.get("order") %>:
                    <%= escapeHtml(
                        String.valueOf(lesson.get("title"))
                    ) %>
                </h1>

                <p class="text-muted">
                    Estimated time:
                    <%= lesson.get("minutes") %> minutes
                </p>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-body p-4 p-md-5">

                    <h2 class="h4 fw-bold mb-4">
                        Lesson Content
                    </h2>

                    <div class="lesson-content"><%= escapeHtml(content) %></div>

                </div>
            </div>

            <div class="d-flex justify-content-between gap-3 mt-4">

                <a class="btn btn-outline-primary"
                   href="<%= request.getContextPath() %>/course-details?id=<%= courseId %>">
                    Back to Lessons
                </a>

                <a class="btn btn-primary"
                   href="<%= request.getContextPath() %>/missions">
                    Practise Missions
                </a>

            </div>

        </div>
    </div>

</main>

</body>
</html>