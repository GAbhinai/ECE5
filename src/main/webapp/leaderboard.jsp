<%@ page import="java.util.List,java.util.Map" %>
<%
    List<Map<String, Object>> players =
        (List<Map<String, Object>>) request.getAttribute("players");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leaderboard - CodeQuest</title>
    <link rel="stylesheet" href="css/style.css">

    <style>
        .leaderboard-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 45px 24px;
        }

        .leaderboard-container h1 {
            margin-bottom: 12px;
        }

        .leaderboard-description {
            margin-bottom: 28px;
        }

        .leaderboard-table-wrapper {
            width: 100%;
            overflow-x: auto;
            border-radius: 10px;
        }

        .leaderboard-table {
            width: 100%;
            border-collapse: collapse;
            background: #151e34;
        }

        .leaderboard-table th,
        .leaderboard-table td {
            padding: 17px 16px;
            text-align: left;
            border-bottom: 1px solid #303d5e;
        }

        .leaderboard-table th {
            background: #172139;
            color: #aebfff;
            font-weight: 700;
            white-space: nowrap;
        }

        .leaderboard-table td {
            color: #edf1ff;
        }

        .leaderboard-table tbody tr:hover {
            background: #1b2642;
        }

        .rank-cell {
            width: 100px;
            font-weight: 700;
            white-space: nowrap;
        }

        .rank-medal {
            font-size: 18px;
        }

        .empty-message {
            text-align: center !important;
            padding: 30px !important;
            color: #aab6d4 !important;
        }

        .leaderboard-action {
            margin-top: 32px;
        }

        @media (max-width: 600px) {
            .leaderboard-container {
                padding: 28px 14px;
            }

            .leaderboard-table th,
            .leaderboard-table td {
                padding: 13px 12px;
                font-size: 13px;
            }
        }
    </style>
</head>

<body>

    <nav class="navbar">
        <a class="logo" href="index.html">CodeQuest</a>
        <a href="missions">Missions</a>
        <a href="login.jsp">Student Login</a>
    </nav>

    <main class="leaderboard-container">

        <h1>Global Leaderboard</h1>

        <p class="leaderboard-description">
            Earn XP by solving programming missions and climb the ranks.
        </p>

        <div class="leaderboard-table-wrapper">
            <table class="leaderboard-table">
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Rank Medal</th>
                        <th>Username</th>
                        <th>Level</th>
                        <th>Completed Missions</th>
                        <th>Total XP</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                        if (players == null || players.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="6" class="empty-message">
                                No players yet. Be the first!
                            </td>
                        </tr>
                    <%
                        } else {
                            for (Map<String, Object> p : players) {
                                Object rankObject = p.get("rank");

                                int rank = rankObject instanceof Number
                                    ? ((Number) rankObject).intValue()
                                    : 0;

                                String medal = "";

                                if (rank == 1) {
                                    medal = "Gold";
                                } else if (rank == 2) {
                                    medal = "Silver";
                                } else if (rank == 3) {
                                    medal = "Bronze";
                                } else {
                                    medal = "-";
                                }
                    %>
                        <tr>
                            <td class="rank-cell"><%= rank %></td>
                            <td class="rank-medal"><%= medal %></td>
                            <td><%= p.get("username") %></td>
                            <td><%= p.get("level") %></td>
                            <td><%= p.get("completed") %></td>
                            <td><%= p.get("xp") %></td>
                        </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>

        <p class="leaderboard-action">
            <a class="btn" href="missions">Solve More Missions</a>
        </p>

    </main>

</body>
</html>