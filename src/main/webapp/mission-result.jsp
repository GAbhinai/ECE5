<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession studentSession = request.getSession(false);

    if (studentSession == null ||
            studentSession.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer correct = (Integer) session.getAttribute("resultCorrect");
    Integer total = (Integer) session.getAttribute("resultTotal");
    Integer xp = (Integer) session.getAttribute("resultXP");

    if (correct == null || total == null || xp == null) {
        response.sendRedirect("missions");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mission Results - CodeQuest</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
    <a class="logo" href="dashboard">CodeQuest</a>
</nav>

<main class="panel">
    <h1>All Answers Submitted!</h1>

    <h2>Results</h2>

    <p>Total Questions Attempted: <%= total %></p>

    <p>Correct Answers: <%= correct %></p>

    <p>Incorrect Answers: <%= total - correct %></p>

    <p>Total XP Earned: <%= xp %></p>

    <a href="missions">Continue to Missions</a>
</main>

</body>
</html>