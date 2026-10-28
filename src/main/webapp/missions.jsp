
<%@ page import="java.util.List,java.util.Map" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession studentSession = request.getSession(false);

    if (studentSession == null ||
            studentSession.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> missions =
            (List<Map<String, Object>>) request.getAttribute("missions");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Programming Missions - CodeQuest</title>

    <link rel="stylesheet" href="css/style.css">

    <style>
        .missions-container {
            max-width: 1150px;
            margin: 30px auto;
            padding: 20px;
        }

        .missions-heading {
            margin-bottom: 25px;
        }

        .mission-card {
            margin: 25px 0;
            padding: 28px;
            background: #151e34;
            border: 1px solid #303d5e;
            border-radius: 14px;
            color: #edf1ff;
        }

        .mission-card h2 {
            margin-top: 0;
            line-height: 1.5;
        }

        .mission-card p {
            line-height: 1.7;
            color: #b8c4e0;
        }

        .answer-option {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px;
            margin: 12px 0;
            background: #0f172a;
            border: 1px solid #303d5e;
            border-radius: 10px;
            cursor: pointer;
            color: #edf1ff;
            transition: background 0.2s, border-color 0.2s;
        }

        .answer-option:hover {
            border-color: #7185ff;
        }

        .answer-option:has(input:checked) {
            background: #1b2745;
            border-color: #7185ff;
        }

        .answer-option input[type="radio"] {
            width: 18px;
            height: 18px;
            accent-color: #657cff;
            flex-shrink: 0;
            cursor: pointer;
        }

        .submit-all-container {
            margin: 30px 0;
            padding: 25px;
            text-align: center;
            background: #151e34;
            border: 1px solid #303d5e;
            border-radius: 14px;
        }

        .answer-progress {
            margin-bottom: 18px;
            color: #b8c4e0;
            font-size: 16px;
        }

        .submit-all-btn {
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            background: #657cff;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        .submit-all-btn:disabled {
            background: #414b68;
            color: #9ca8c5;
            cursor: not-allowed;
            opacity: 0.7;
        }

        .no-missions {
            padding: 30px;
            text-align: center;
            background: #151e34;
            color: #edf1ff;
            border-radius: 14px;
        }

        /* Updated navigation */
        .navbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
            padding: 18px 5%;
            background: #0f172a;
        }

        .navbar a {
            color: #edf1ff;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }

        .navbar a:hover {
            color: #8ea0ff;
        }

        .navbar .logo {
            margin-right: auto;
            font-size: 24px;
            font-weight: bold;
            color: #8ea0ff;
        }

        @media (max-width: 650px) {
            .missions-container {
                padding: 12px;
            }

            .mission-card {
                padding: 18px;
            }

            .navbar {
                justify-content: center;
                gap: 15px;
            }

            .navbar .logo {
                width: 100%;
                margin-right: 0;
                text-align: center;
            }
        }
    </style>
</head>

<body>

<!-- Updated navigation bar -->
<nav class="navbar">
    <a class="logo" href="dashboard">CodeQuest</a>
    <a href="dashboard">Dashboard</a>
    <a href="missions">Practice Questions</a>
    <a href="courses">Courses</a>
    <a href="leaderboard">Leaderboard</a>
    <a href="logout">Logout</a>
</nav>

<main class="missions-container">

    <section class="missions-heading">
        <h1>Available Missions</h1>
        <p>Answer every question to submit your answers.</p>
    </section>

    <% if (missions == null || missions.isEmpty()) { %>

        <section class="no-missions">
            <h2>All caught up!</h2>
            <p>No new missions are available. Check again later.</p>
        </section>

    <% } else { %>

        <!-- One form for all questions -->
        <form id="allMissionsForm"
              action="submit-all-answers"
              method="post">

            <%
                int questionNumber = 1;

                for (Map<String, Object> m : missions) {
                    String missionId = String.valueOf(m.get("id"));
            %>

                <section class="mission-card">

                    <h2>
                        Question <%= questionNumber %>:
                        <%= m.get("title") %>
                    </h2>

                    <p><%= m.get("description") %></p>

                    <p>
                        Category: <%= m.get("category") %>
                    </p>

                    <p>
                        Difficulty: <%= m.get("difficulty") %>
                    </p>

                    <p>
                        Reward: <%= m.get("xp") %> XP
                    </p>

                    <input type="hidden"
                           name="missionIds"
                           value="<%= missionId %>">

                    <p><strong>Select your answer:</strong></p>

                    <label class="answer-option">
                        <input type="radio"
                               name="answer_<%= missionId %>"
                               value="A"
                               required>
                        <span>A. <%= m.get("a") %></span>
                    </label>

                    <label class="answer-option">
                        <input type="radio"
                               name="answer_<%= missionId %>"
                               value="B"
                               required>
                        <span>B. <%= m.get("b") %></span>
                    </label>

                    <label class="answer-option">
                        <input type="radio"
                               name="answer_<%= missionId %>"
                               value="C"
                               required>
                        <span>C. <%= m.get("c") %></span>
                    </label>

                    <label class="answer-option">
                        <input type="radio"
                               name="answer_<%= missionId %>"
                               value="D"
                               required>
                        <span>D. <%= m.get("d") %></span>
                    </label>

                </section>

            <%
                    questionNumber++;
                }
            %>

            <!-- One submit button for all questions -->
            <div class="submit-all-container">

                <p id="answerProgress" class="answer-progress">
                    Answered 0 of <%= missions.size() %> questions
                </p>

                <button type="submit"
                        id="submitAllButton"
                        class="submit-all-btn"
                        disabled>
                    Submit All Answers
                </button>

            </div>

        </form>

    <% } %>

</main>

<script>
document.addEventListener("DOMContentLoaded", function () {

    const form = document.getElementById("allMissionsForm");

    if (!form) {
        return;
    }

    const submitButton = document.getElementById("submitAllButton");
    const progress = document.getElementById("answerProgress");

    const missionIdInputs =
        form.querySelectorAll('input[name="missionIds"]');

    const totalQuestions = missionIdInputs.length;

    function updateSubmitButton() {

        let answeredQuestions = 0;

        missionIdInputs.forEach(function (missionInput) {

            const missionId = missionInput.value;

            const selectedAnswer = form.querySelector(
                'input[name="answer_' + missionId + '"]:checked'
            );

            if (selectedAnswer) {
                answeredQuestions++;
            }
        });

        progress.textContent =
            "Answered " + answeredQuestions +
            " of " + totalQuestions + " questions";

        submitButton.disabled =
            totalQuestions === 0 ||
            answeredQuestions !== totalQuestions;
    }

    form.querySelectorAll('input[type="radio"]').forEach(
        function (radio) {
            radio.addEventListener("change", updateSubmitButton);
        }
    );

    form.addEventListener("submit", function (event) {

        updateSubmitButton();

        if (submitButton.disabled) {
            event.preventDefault();
            alert("Please answer every question before submitting.");
            return;
        }

        if (!form.checkValidity()) {
            event.preventDefault();
            form.reportValidity();
        }
    });

    updateSubmitButton();
});
</script>

</body>
</html>
