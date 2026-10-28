
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Admin Login | CodeQuest</title>
    <link rel="stylesheet" href="css/style.css">

    <style>
        .admin-page {
            min-height: calc(100vh - 76px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 45px 20px;
        }

        .admin-layout {
            width: min(1000px, 100%);
            display: grid;
            grid-template-columns: 1fr 1fr;
            overflow: hidden;
            border: 1px solid #303d5e;
            border-radius: 23px;
            background: #131b30;
            box-shadow: 0 25px 80px rgba(0, 0, 0, .35);
        }

        .admin-welcome {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: clamp(28px, 5vw, 55px);
            background:
                radial-gradient(circle at 10% 10%,
                    rgba(139, 92, 246, .25), transparent 45%),
                linear-gradient(145deg, #1b2647, #11182d);
        }

        .admin-logo {
            display: grid;
            place-items: center;
            width: 55px;
            height: 55px;
            margin-bottom: 30px;
            border-radius: 16px;
            background: linear-gradient(135deg, #7185ff, #a78bfa);
            color: white;
            font-size: 27px;
            font-weight: 850;
        }

        .admin-welcome h1 {
            font-size: clamp(2rem, 4vw, 2.8rem);
            line-height: 1.15;
            margin-bottom: 18px;
        }

        .admin-gradient {
            color: #a8b5ff;
        }

        .admin-welcome p {
            line-height: 1.9;
            color: #aab6d4;
        }

        .admin-points {
            margin-top: 28px;
            display: grid;
            gap: 14px;
        }

        .admin-point {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #dce3fb;
            font-size: .92rem;
        }

        .point-icon {
            display: grid;
            place-items: center;
            flex-shrink: 0;
            width: 30px;
            height: 30px;
            border-radius: 9px;
            background: rgba(113, 133, 255, .14);
            color: #aab7ff;
        }

        .admin-form-side {
            padding: clamp(28px, 5vw, 48px);
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-eyebrow {
            margin-bottom: 10px;
            color: #9eacff;
            font-size: .78rem;
            font-weight: 800;
            letter-spacing: 1.8px;
        }

        .admin-form-side h2 {
            font-size: 2rem;
            margin-bottom: 8px;
        }

        .form-subtitle {
            margin-bottom: 22px;
            font-size: .92rem;
        }

        .admin-form label {
            margin-top: 19px;
        }

        .admin-form input {
            margin-top: 8px;
        }

        .admin-submit {
            width: 100%;
            margin-top: 27px;
            min-height: 49px;
        }

        .back-home {
            display: inline-block;
            margin-top: 25px;
            text-align: center;
            font-size: .9rem;
            color: #aebbe0;
        }

        .back-home:hover {
            color: white;
        }

        .admin-footer {
            padding: 20px;
            text-align: center;
            font-size: .82rem;
            color: #7f8eaf;
        }

        @media (max-width: 700px) {
            .admin-layout {
                grid-template-columns: 1fr;
            }

            .admin-welcome {
                padding: 30px;
            }

            .admin-logo {
                margin-bottom: 20px;
            }

            .admin-points {
                grid-template-columns: 1fr;
            }

            .admin-form-side {
                padding: 30px;
            }

            .admin-page {
                padding: 25px 15px;
            }
        }
    </style>
</head>

<body>

<nav class="navbar">
    <a href="index.html" class="logo">CodeQuest</a>
    <a href="index.html">Back to Home</a>
</nav>

<main class="admin-page">

    <div class="admin-layout">

        <!-- Left welcome panel -->
        <section class="admin-welcome">

            <div class="admin-logo">C</div>

            <h1>
                Manage your platform.
                <span class="admin-gradient">Lead the quest.</span>
            </h1>

            <p>
                Welcome to the CodeQuest administration portal.
                Manage programming missions, maintain questions and
                help students progress on their coding journey.
            </p>

            <div class="admin-points">

                <div class="admin-point">
                    <span class="point-icon">&#10003;</span>
                    Manage coding questions
                </div>

                <div class="admin-point">
                    <span class="point-icon">&#10003;</span>
                    Organize student missions
                </div>

                <div class="admin-point">
                    <span class="point-icon">&#10003;</span>
                    Track learning progress
                </div>

            </div>

        </section>

        <!-- Right login form -->
        <section class="admin-form-side">

            <div class="form-eyebrow">ADMINISTRATOR PORTAL</div>

            <h2>Welcome back</h2>

            <p class="form-subtitle">
                Sign in with your administrator credentials.
            </p>

            <% if ("1".equals(request.getParameter("error"))) { %>
                <p class="error" role="alert">
                    Invalid administrator username or password.
                    Please try again.
                </p>
            <% } %>

            <form class="admin-form"
                  action="admin-login"
                  method="post">

                <label for="username">Administrator username</label>

                <input
                    type="text"
                    id="username"
                    name="username"
                    placeholder="Enter your admin username"
                    autocomplete="username"
                    maxlength="50"
                    required
                >

                <label for="password">Password</label>

                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="Enter your password"
                    autocomplete="current-password"
                    required
                >

                <button type="submit" class="admin-submit">
                    Sign In to Admin Portal &nbsp; →
                </button>

            </form>

            <a href="index.html" class="back-home">
                Return to CodeQuest homepage
            </a>

        </section>

    </div>

</main>

<footer class="admin-footer">
    CodeQuest Administration · Secure access for authorized administrators
</footer>

</body>
</html>
