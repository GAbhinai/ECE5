
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
HttpSession adminSession = request.getSession(false);
if (adminSession == null ||
    adminSession.getAttribute("adminId") == null) {
    response.sendRedirect("admin-login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Mission - CodeQuest</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <a class="logo" href="admin-dashboard.jsp">CodeQuest</a>
        <a href="view-questions">View Questions</a>
    </nav>

    <main class="form-card">
        <h1>Create Programming Mission</h1>

        <%
        if ("1".equals(request.getParameter("success"))) {
        %>
            <p class="success">Question added successfully!</p>
        <%
        }
        if (request.getParameter("error") != null) {
        %>
            <p class="error">Please check the question details.</p>
        <%
        }
        %>

        <form action="add-question" method="post">
            <label>Question Title</label>
            <input name="title" required maxlength="150">

            <label>Description</label>
            <textarea name="description" rows="4"
                      required></textarea>

            <label>Category</label>
            <select name="category" required>
                <option value="Java">Java</option>
                <option value="SQL">SQL</option>
                <option value="DSA">DSA</option>
            </select>

            <label>Difficulty</label>
            <select name="difficulty" required>
                <option value="Easy">Easy</option>
                <option value="Medium">Medium</option>
                <option value="Hard">Hard</option>
            </select>

            <label>Option A</label>
            <input name="optionA" required maxlength="255">

            <label>Option B</label>
            <input name="optionB" required maxlength="255">

            <label>Option C</label>
            
            <input name="optionC" required maxlength="255">

            <label>Option D</label>
            <input name="optionD" required maxlength="255">

            <label>Correct Answer</label>
            <select name="correctAnswer" required>
                <option value="A">Option A</option>
                <option value="B">Option B</option>
                <option value="C">Option C</option>
                <option value="D">Option D</option>
            </select>

            <label>XP Reward</label>
            <input type="number" name="xpReward"
                   min="0" max="10000" value="10" required>

            <button type="submit">Save Question</button>
        </form>
    </main>
</body>
</html>
