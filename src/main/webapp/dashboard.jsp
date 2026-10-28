<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%!
    public String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    // Make sure the student is logged in.
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String studentName =
        (String) request.getAttribute("studentName");

    Integer studentXP =
        (Integer) request.getAttribute("studentXP");

    Integer studentLevel =
        (Integer) request.getAttribute("studentLevel");

    Integer completed =
        (Integer) request.getAttribute("completed");

    if (studentName == null) studentName = "Student";
    if (studentXP == null) studentXP = 0;
    if (studentLevel == null) studentLevel = 1;
    if (completed == null) completed = 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Student Dashboard | CodeQuest</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            background: #090d1b;
            color: #eef1ff;
            font-family: Arial, sans-serif;
        }

        .navbar {
            min-height: 72px;
            padding: 15px 5%;
            background: #10172a;
            border-bottom: 1px solid #293450;
        }

        .brand {
            color: #aab5ff;
            font-size: 25px;
            font-weight: 800;
            text-decoration: none;
        }

        .nav-links {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 22px;
        }

        .nav-links a {
            color: #c4cce5;
            text-decoration: none;
        }

        .nav-links a:hover,
        .nav-links a.active {
            color: #aab5ff;
        }

        .dashboard-container {
            width: min(1150px, 92%);
            margin: 45px auto;
        }

        .welcome-panel {
            padding: 35px;
            margin-bottom: 30px;
            border: 1px solid #34416b;
            border-radius: 20px;
            background: linear-gradient(120deg, #222b55, #151d36);
        }

        .welcome-panel h1 {
            margin-bottom: 12px;
            font-size: clamp(27px, 4vw, 38px);
            font-weight: 800;
        }

        .welcome-panel p {
            margin: 0;
            color: #bac5e3;
            line-height: 1.8;
        }

        .highlight {
            color: #aab5ff;
        }

        .section-title {
            margin-bottom: 20px;
            font-size: 23px;
            font-weight: 750;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
            margin-bottom: 35px;
        }

        .stat-card {
            padding: 25px;
            border: 1px solid #2d3a5a;
            border-radius: 17px;
            background: #141c30;
        }

        .stat-label {
            margin-bottom: 15px;
            color: #aebbd9;
            font-size: 14px;
        }

        .stat-value {
            color: #aab5ff;
            font-size: 32px;
            font-weight: 800;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
        }

        .action-card {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            padding: 25px;
            border: 1px solid #2d3a5a;
            border-radius: 17px;
            background: #141c30;
        }

        .action-card h3 {
            margin-bottom: 12px;
            font-size: 19px;
            font-weight: 750;
        }

        .action-card p {
            flex-grow: 1;
            color: #aebbd9;
            line-height: 1.7;
        }

        .action-button {
            display: inline-block;
            margin-top: 12px;
            padding: 12px 17px;
            border: none;
            border-radius: 9px;
            background: linear-gradient(100deg, #7185ff, #7559ed);
            color: white;
            font-weight: 700;
            text-decoration: none;
        }

        .action-button:hover {
            color: white;
            filter: brightness(1.1);
        }

        footer {
            padding: 25px;
            color: #8492b3;
            text-align: center;
        }

        @media (max-width: 800px) {
            .stats-grid,
            .actions-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .navbar {
                gap: 15px;
            }
        }

        @media (max-width: 560px) {
            .stats-grid,
            .actions-grid {
                grid-template-columns: 1fr;
            }

            .welcome-panel {
                padding: 25px;
            }

            .nav-links {
                gap: 12px;
                font-size: 14px;
            }
        }
    </style>
</head>

<body>

<nav class="navbar d-flex justify-content-between align-items-center">
    <a class="brand"
       href="<%= request.getContextPath() %>/dashboard">
        CodeQuest
    </a>

    <div class="nav-links">
        <a class="active"
           href="<%= request.getContextPath() %>/dashboard">
            Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/courses">
            Courses
        </a>

        <a href="<%= request.getContextPath() %>/missions">
            Missions
        </a>

        <a href="<%= request.getContextPath() %>/leaderboard">
            Leaderboard
        </a>

        <a href="<%= request.getContextPath() %>/logout">
            Logout
        </a>
    </div>
</nav>

<main class="dashboard-container">

    <section class="welcome-panel">
        <h1>
            Welcome back,
            <span class="highlight"><%= escapeHtml(studentName) %></span>!
        </h1>

        <p>
            Continue your coding journey with CodeQuest.
            Learn new concepts, practise programming and
            track your progress.
        </p>
    </section>

    <h2 class="section-title">Your Learning Progress</h2>

    <section class="stats-grid">

        <div class="stat-card">
            <div class="stat-label">Total Experience Points</div>
            <div class="stat-value"><%= studentXP %> XP</div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Current Level</div>
            <div class="stat-value"><%= studentLevel %></div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Completed Missions</div>
            <div class="stat-value"><%= completed %></div>
        </div>

    </section>

    <h2 class="section-title">Continue Learning</h2>

    <section class="actions-grid">

        <div class="action-card">
            <h3>Java Programming</h3>
            <p>
                Learn Java fundamentals, object-oriented programming,
                collections and exception handling.
            </p>

            <a class="action-button"
               href="<%= request.getContextPath() %>/courses">
                Explore Courses
            </a>
        </div>

        <div class="action-card">
            <h3>Coding Missions</h3>
            <p>
                Practise programming problems and improve
                your problem-solving skills.
            </p>

            <a class="action-button"
               href="<%= request.getContextPath() %>/missions">
                Start Practising
            </a>
        </div>

        <div class="action-card">
            <h3>Leaderboard</h3>
            <p>
                Explore student rankings and compare
                your learning progress.
            </p>

            <a class="action-button"
               href="<%= request.getContextPath() %>/leaderboard">
                View Leaderboard
            </a>
        </div>

    </section>

</main>

<footer>
    CodeQuest &middot; Learn. Practise. Progress.
</footer>

</body>
</html>
