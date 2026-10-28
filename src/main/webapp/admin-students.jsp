<%@ page import="java.util.List,java.util.Map" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession adminSession = request.getSession(false);

    if (adminSession == null ||
        adminSession.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    List<Map<String, Object>> students =
        (List<Map<String, Object>>) request.getAttribute("students");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Manage Students | CodeQuest</title>
    <link rel="stylesheet" href="css/style.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            background: #0b1020;
            color: #edf1ff;
            font-family: Arial, sans-serif;
        }

        .topbar {
            min-height: 76px;
            padding: 0 7%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            background: #151e34;
            border-bottom: 1px solid #303d5e;
        }

        .logo {
            color: #8ca8ff;
            font-size: 27px;
            font-weight: 800;
            text-decoration: none;
        }

        .topbar a:last-child {
            color: #edf1ff;
            text-decoration: none;
        }

        .container {
            max-width: 1300px;
            margin: 0 auto;
            padding: 45px 24px;
        }

        h1 {
            margin-top: 0;
            font-size: 34px;
        }

        .description {
            margin-bottom: 28px;
            color: #aab6d4;
            line-height: 1.7;
        }

        .student-table-wrapper {
            overflow-x: auto;
            border: 1px solid #303d5e;
            border-radius: 12px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #151e34;
        }

        th, td {
            padding: 17px;
            text-align: left;
            border-bottom: 1px solid #303d5e;
            white-space: nowrap;
        }

        th {
            background: #1b2642;
            color: #aebfff;
        }

        td {
            color: #edf1ff;
        }

        tbody tr:hover {
            background: #202c49;
        }

        .empty {
            padding: 35px;
            color: #aab6d4;
            text-align: center;
        }

        .back-button {
            display: inline-block;
            margin-top: 28px;
            padding: 12px 20px;
            border-radius: 8px;
            background: #657cff;
            color: white;
            text-decoration: none;
        }

        @media (max-width: 600px) {
            .topbar {
                padding: 0 16px;
            }

            .logo {
                font-size: 22px;
            }

            .container {
                padding: 28px 14px;
            }

            h1 {
                font-size: 27px;
            }

            th, td {
                padding: 12px;
                font-size: 13px;
            }
        }
    </style>
</head>

<body>

    <nav class="topbar">
        <a href="index.html" class="logo">CodeQuest</a>
        <a href="admin-dashboard.jsp">Admin Dashboard</a>
    </nav>

    <main class="container">

        <h1>Manage Students</h1>

        <p class="description">
            View registered students, their completed missions,
            and their earned experience points.
        </p>

        <div class="student-table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Student ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Completed Missions</th>
                        <th>Total XP</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                        if (students == null || students.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="5" class="empty">
                                No registered students found.
                            </td>
                        </tr>
                    <%
                        } else {
                            for (Map<String, Object> student : students) {
                    %>
                        <tr>
                            <td><%= student.get("id") %></td>
                            <td><%= student.get("username") %></td>
                            <td><%= student.get("email") %></td>
                            <td><%= student.get("completed") %></td>
                            <td><%= student.get("xp") %></td>
                        </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>

        <a href="admin-dashboard.jsp" class="back-button">
            &larr; Back to Dashboard
        </a>

    </main>

</body>
</html>