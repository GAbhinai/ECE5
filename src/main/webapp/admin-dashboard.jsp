
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession adminSession = request.getSession(false);

    if (adminSession == null ||
        adminSession.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    String adminName =
        (String) adminSession.getAttribute("adminUsername");

    if (adminName == null) {
        adminName = "Administrator";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CodeQuest - Admin Dashboard</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            background: #0b1020;
            color: #edf1ff;
            font-family: Arial, Helvetica, sans-serif;
        }

        /* Navbar */
        .admin-navbar {
            min-height: 76px;
            padding: 0 7%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            background: #151e34;
            border-bottom: 1px solid #303d5e;
        }

        .admin-navbar .logo {
            color: #8ca8ff;
            font-size: 27px;
            font-weight: 800;
            text-decoration: none;
        }

        .admin-welcome {
            color: #dce3fb;
            font-size: 14px;
        }

        /* Main container */
        .admin-container {
            max-width: 1300px;
            margin: 0 auto;
            padding: 45px 24px;
        }

        .admin-heading {
            margin-bottom: 30px;
        }

        .admin-heading h1 {
            margin: 0 0 12px;
            font-size: 34px;
        }

        .admin-heading p {
            margin: 0;
            color: #aab6d4;
            line-height: 1.7;
        }

        /* Dashboard grid */
        .admin-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px;
        }

        /* Dashboard cards */
        .admin-card {
            padding: 28px;
            border: 1px solid #303d5e;
            border-radius: 16px;
            background: #151e34;
            transition: transform 0.2s, border-color 0.2s,
                        box-shadow 0.2s;
        }

        .admin-card:hover {
            transform: translateY(-4px);
            border-color: #7185ff;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.18);
        }

        /* Icon container */
        .admin-card-icon {
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            border-radius: 15px;
            background: rgba(113, 133, 255, 0.15);
            border: 1px solid rgba(113, 133, 255, 0.2);
        }

        /* Font Awesome icons */
        .admin-card-icon i {
            font-size: 27px;
            color: #8192ff;
        }

        .admin-card h2 {
            margin: 0 0 10px;
            font-size: 21px;
        }

        .admin-card p {
            min-height: 48px;
            margin: 0 0 22px;
            color: #aab6d4;
            font-size: 14px;
            line-height: 1.7;
        }

        /* Action buttons */
        .admin-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            min-height: 43px;
            padding: 12px 20px;
            border-radius: 8px;
            background: #657cff;
            color: white;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            transition: background 0.2s;
        }

        .admin-action:hover {
            background: #7d90ff;
        }

        .admin-action.secondary {
            background: #263452;
            border: 1px solid #3b4b70;
        }

        .admin-action.secondary:hover {
            background: #344567;
        }

        .admin-action i {
            font-size: 14px;
        }

        /* Logout */
        .admin-logout {
            margin-top: 30px;
        }

        .admin-logout button {
            padding: 11px 22px;
            border: 1px solid #67404d;
            border-radius: 8px;
            background: #321d2a;
            color: #ffb7c5;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .admin-logout button:hover {
            background: #482534;
        }

        .admin-logout button i {
            margin-right: 7px;
        }

        /* Footer */
        .admin-footer {
            padding: 20px;
            color: #7f8eaf;
            text-align: center;
            font-size: 12px;
        }

        /* Responsive layout */
        @media (max-width: 650px) {
            .admin-navbar {
                padding: 0 18px;
            }

            .admin-navbar .logo {
                font-size: 22px;
            }

            .admin-welcome {
                font-size: 12px;
            }

            .admin-container {
                padding: 30px 16px;
            }

            .admin-heading h1 {
                font-size: 28px;
            }

            .admin-grid {
                grid-template-columns: 1fr;
            }

            .admin-card {
                padding: 23px;
            }
        }
    </style>
</head>

<body>

    <!-- Navigation bar -->
    <nav class="admin-navbar">

        <a href="<%= request.getContextPath() %>/index.html"
           class="logo">
            CodeQuest
        </a>

        <span class="admin-welcome">
            Welcome, <strong><%= adminName %></strong>
        </span>

    </nav>

    <!-- Main dashboard -->
    <main class="admin-container">

        <section class="admin-heading">
            <h1>Admin Dashboard</h1>

            <p>
                Manage your programming questions and help students
                improve their coding skills.
            </p>
        </section>

        <section class="admin-grid">

            <!-- Add New Question -->
            <div class="admin-card">

                <div class="admin-card-icon">
                    <i class="fa-solid fa-pen-to-square"
                       aria-hidden="true"></i>
                </div>

                <h2>Add New Question</h2>

                <p>
                    Create an individual programming question with
                    four options, a correct answer, and XP points.
                </p>

                <a href="<%= request.getContextPath() %>/add-question.jsp"
                   class="admin-action">

                    <i class="fa-solid fa-plus"
                       aria-hidden="true"></i>

                    Add Question
                </a>

            </div>

            <!-- Bulk Upload Questions -->
            <div class="admin-card">

                <div class="admin-card-icon">
                    <i class="fa-solid fa-file-arrow-up"
                       aria-hidden="true"></i>
                </div>

                <h2>Bulk Upload Questions</h2>

                <p>
                    Import multiple programming questions at once
                    using a CSV file instead of entering them individually.
                </p>

                <a href="<%= request.getContextPath() %>/bulk-upload-questions.jsp"
                   class="admin-action">

                    <i class="fa-solid fa-upload"
                       aria-hidden="true"></i>

                    Upload Questions
                </a>

            </div>

            <!-- View Questions -->
            <div class="admin-card">

                <div class="admin-card-icon">
                    <i class="fa-solid fa-book-open"
                       aria-hidden="true"></i>
                </div>

                <h2>View Questions</h2>

                <p>
                    View your existing questions, review their details,
                    and manage questions in the question bank.
                </p>

                <a href="<%= request.getContextPath() %>/view-questions"
                   class="admin-action secondary">

                    <i class="fa-solid fa-list-check"
                       aria-hidden="true"></i>

                    View All Questions
                </a>

            </div>

            <!-- Manage Students -->
            <div class="admin-card">

                <div class="admin-card-icon">
                    <i class="fa-solid fa-users"
                       aria-hidden="true"></i>
                </div>

                <h2>Manage Students</h2>

                <p>
                    View registered students, review their coding progress,
                    and track their mission completion and XP.
                </p>

                <a href="<%= request.getContextPath() %>/admin-students"
                   class="admin-action secondary">

                    <i class="fa-solid fa-user-graduate"
                       aria-hidden="true"></i>

                    View Students
                </a>

            </div>

        </section>

        <!-- Logout -->
        <form class="admin-logout"
              action="<%= request.getContextPath() %>/admin-logout"
              method="post">

            <button type="submit">
                <i class="fa-solid fa-right-from-bracket"
                   aria-hidden="true"></i>
                Logout
            </button>

        </form>

    </main>

    <!-- Footer -->
    <footer class="admin-footer">
        CodeQuest &middot; Admin Dashboard
    </footer>

</body>
</html>
