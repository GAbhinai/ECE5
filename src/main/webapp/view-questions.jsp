
<%@ page import="java.util.List,java.util.Map" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
HttpSession adminSession = request.getSession(false);

if (adminSession == null ||
    adminSession.getAttribute("adminId") == null) {
    response.sendRedirect("admin-login.jsp");
    return;
}

List<Map<String, Object>> questions =
    (List<Map<String, Object>>) request.getAttribute("questions");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Questions - CodeQuest</title>
    <link rel="stylesheet" href="css/style.css">

    <style>
        .details-row {
            background: #10172a;
        }

        .details-box {
            padding: 20px;
            line-height: 1.8;
        }

        .details-box p {
            margin: 8px 0;
        }

        .answer {
            color: #75e6a5;
            font-weight: bold;
        }

        .action-buttons {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .delete-button {
            background: #dc3545 !important;
            color: white;
        }

        .success-message {
            color: #75e6a5;
            margin: 15px 0;
        }

        .error-message {
            color: #ff8989;
            margin: 15px 0;
        }
    </style>
</head>

<body>

<nav class="navbar">
    <a class="logo" href="admin-dashboard.jsp">CodeQuest</a>
    <a href="add-question.jsp">Add Question</a>
    <a href="admin-dashboard.jsp">Dashboard</a>
</nav>

<main>
    <h1>Programming Questions</h1>

    <% if ("1".equals(request.getParameter("deleted"))) { %>
        <p class="success-message">
            Question permanently deleted successfully.
        </p>
    <% } %>

    <% if ("1".equals(request.getParameter("deactivated"))) { %>
        <p class="success-message">
            Question removed from student missions.
            Existing submissions have been preserved.
        </p>
    <% } %>

    <% if ("notfound".equals(request.getParameter("error"))) { %>
        <p class="error-message">Question was not found.</p>
    <% } %>

    <% if ("deletefailed".equals(request.getParameter("error"))) { %>
        <p class="error-message">
            Unable to remove the question. Please check the
            server logs or database constraints.
        </p>
    <% } %>

    <table>
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Category</th>
            <th>Difficulty</th>
            <th>XP</th>
            <th>Action</th>
        </tr>

        <%
        if (questions != null && !questions.isEmpty()) {
            for (Map<String, Object> q : questions) {
                String detailsId = "details-" + q.get("id");
        %>

        <tr>
            <td><%= q.get("id") %></td>
            <td><%= q.get("title") %></td>
            <td><%= q.get("category") %></td>
            <td><%= q.get("difficulty") %></td>
            <td><%= q.get("xp") %></td>

            <td>
                <div class="action-buttons">

                    <button type="button"
                        onclick="toggleDetails('<%= detailsId %>', this)">
                        View Details
                    </button>

                    <form action="delete-question"
                          method="post"
                          style="display:inline"
                          onsubmit="return confirm(
                              'Are you sure you want to remove this question?'
                          );">

                        <input type="hidden"
                               name="missionId"
                               value="<%= q.get("id") %>">

                        <button type="submit" class="delete-button">
                            Delete
                        </button>
                    </form>

                </div>
            </td>
        </tr>

        <tr id="<%= detailsId %>"
            class="details-row"
            style="display:none">

            <td colspan="6">
                <div class="details-box">

                    <h3><%= q.get("title") %></h3>

                    <p><strong>Question:</strong></p>
                    <p><%= q.get("description") %></p>

                    <p><strong>Option A:</strong> <%= q.get("a") %></p>
                    <p><strong>Option B:</strong> <%= q.get("b") %></p>
                    <p><strong>Option C:</strong> <%= q.get("c") %></p>
                    <p><strong>Option D:</strong> <%= q.get("d") %></p>

                    <p class="answer">
                        Correct Answer: <%= q.get("answer") %>
                    </p>

                    <p>Reward: <%= q.get("xp") %> XP</p>

                </div>
            </td>
        </tr>

        <%
            }
        } else {
        %>

        <tr>
            <td colspan="6">No active questions found.</td>
        </tr>

        <%
        }
        %>
    </table>
</main>

<script>
    function toggleDetails(id, button) {
        const row = document.getElementById(id);

        if (row.style.display === "none") {
            row.style.display = "table-row";
            button.textContent = "Hide Details";
        } else {
            row.style.display = "none";
            button.textContent = "View Details";
        }
    }
</script>

</body>
</html>
