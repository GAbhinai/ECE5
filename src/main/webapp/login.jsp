<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login | CodeQuest</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <style>
        .login-page {
            min-height: calc(100vh - 76px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .login-layout {
            width: min(1100px, 100%);
            display: grid;
            grid-template-columns: 1fr 1fr;
            overflow: hidden;
            border: 1px solid #303d5e;
            border-radius: 23px;
            background: #131b30;
            box-shadow: 0 25px 80px rgba(0, 0, 0, .35);
        }

        .login-welcome {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: clamp(28px, 5vw, 55px);
            background:
                radial-gradient(circle at 10% 10%, rgba(139, 92, 246, .25), transparent 45%),
                linear-gradient(145deg, #1b2647, #11182d);
        }

        .login-brand-icon {
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

        .login-welcome h1 {
            font-size: clamp(2rem, 4vw, 2.8rem);
            line-height: 1.15;
            margin-bottom: 18px;
        }

        .login-gradient {
            display: block;
            color: #a8b5ff;
        }

        .login-welcome > p {
            line-height: 1.9;
            color: #aab6d4;
        }

        .login-benefits {
            display: grid;
            gap: 14px;
            margin-top: 28px;
        }

        .login-benefit {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #dce3fb;
            font-size: .92rem;
        }

        .benefit-icon {
            display: grid;
            place-items: center;
            flex-shrink: 0;
            width: 30px;
            height: 30px;
            border-radius: 9px;
            background: rgba(113, 133, 255, .14);
            color: #aab7ff;
        }

        .login-form-side {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: clamp(28px, 5vw, 48px);
        }

        .login-eyebrow {
            margin-bottom: 10px;
            color: #9eacff;
            font-size: .78rem;
            font-weight: 800;
            letter-spacing: 1.8px;
        }

        .login-form-side h2 {
            font-size: 2rem;
            margin-bottom: 8px;
        }

        .login-subtitle {
            margin-bottom: 20px;
            font-size: .92rem;
        }

        .login-form label {
            display: block;
            margin-top: 19px;
        }

        .login-form input {
            display: block;
            box-sizing: border-box;
            width: 100%;
            margin-top: 8px;
            padding: 14px 16px;
        }

        .login-submit {
            display: flex;
            align-items: center;
            justify-content: center;
            box-sizing: border-box;
            width: 100%;
            min-height: 52px;
            margin-top: 27px;
            padding: 14px 22px;
            border: 0;
            border-radius: 12px;
            background: linear-gradient(100deg, #7185ff 0%, #7559ed 100%);
            color: #ffffff;
            font-family: inherit;
            font-size: 1rem;
            font-weight: 750;
            line-height: 1.3;
            text-align: center;
            white-space: normal;
            box-shadow: 0 8px 20px rgba(103, 91, 239, .18);
            cursor: pointer;
            transition: transform .18s ease, box-shadow .18s ease,
                        filter .18s ease;
        }

        .login-submit:hover {
            filter: brightness(1.08);
            box-shadow: 0 10px 24px rgba(103, 91, 239, .28);
            transform: translateY(-1px);
        }

        .login-submit:active {
            transform: translateY(0);
            box-shadow: 0 4px 12px rgba(103, 91, 239, .2);
        }

        .login-submit:focus-visible {
            outline: 3px solid #b8c2ff;
            outline-offset: 3px;
        }

        .login-bottom {
            margin-top: 23px;
            text-align: center;
            font-size: .9rem;
            color: #aab6d4;
        }

        .login-bottom a {
            color: #aab7ff;
            font-weight: 700;
        }

        .login-home {
            display: inline-block;
            margin-top: 20px;
            text-align: center;
            font-size: .9rem;
            color: #aebbe0;
        }

        .login-home:hover {
            color: white;
        }

        .login-footer {
            padding: 20px;
            text-align: center;
            font-size: .82rem;
            color: #7f8eaf;
        }

        .login-message {
            margin: 12px 0;
            padding: 12px 14px;
            border-radius: 8px;
        }

        .login-message.error {
            color: #ffd8d8;
            background: rgba(220, 53, 69, .15);
            border: 1px solid rgba(220, 53, 69, .45);
        }

        .login-message.success {
            color: #d4ffe3;
            background: rgba(25, 135, 84, .15);
            border: 1px solid rgba(25, 135, 84, .45);
        }

        @media (max-width: 700px) {
            .login-layout {
                grid-template-columns: 1fr;
            }

            .login-welcome,
            .login-form-side {
                padding: 30px;
            }

            .login-brand-icon {
                margin-bottom: 20px;
            }

            .login-page {
                padding: 25px 15px;
            }
        }
    </style>
</head>

<body>
<nav class="navbar">
    <a href="<%= request.getContextPath() %>/index.html" class="logo">CodeQuest</a>
    <a href="<%= request.getContextPath() %>/index.html">Back to Home</a>
</nav>

<main class="login-page">
    <div class="login-layout">

        <section class="login-welcome">
            <div class="login-brand-icon">C</div>

            <h1>
                Welcome back.
                <span class="login-gradient">Your next level awaits.</span>
            </h1>

            <p>
                Continue your coding journey with CodeQuest.
                Solve programming missions, improve your skills
                and track your progress as you learn.
            </p>

            <div class="login-benefits">
                <div class="login-benefit">
                    <span class="benefit-icon">&#10003;</span>
                    Practise Java, SQL and DSA
                </div>
                <div class="login-benefit">
                    <span class="benefit-icon">&#10003;</span>
                    Earn XP by completing missions
                </div>
                <div class="login-benefit">
                    <span class="benefit-icon">&#10003;</span>
                    Track your level and achievements
                </div>
            </div>
        </section>

        <section class="login-form-side">
            <div class="login-eyebrow">STUDENT PORTAL</div>
            <h2>Sign in</h2>
            <p class="login-subtitle">Enter your account details to continue.</p>

            <% if ("1".equals(request.getParameter("registered"))) { %>
                <p class="login-message success" role="status">
                    Registration successful! Please log in.
                </p>
            <% } %>

            <% String error = request.getParameter("error"); %>
            <% if ("invalid".equals(error)) { %>
                <p class="login-message error" role="alert">
                    Invalid username/email or password. Please try again.
                </p>
            <% } else if ("server".equals(error)) { %>
                <p class="login-message error" role="alert">
                    A server error occurred. Please check the server log and try again.
                </p>
            <% } else if (error != null) { %>
                <p class="login-message error" role="alert">
                    Unable to sign in. Please check your details and try again.
                </p>
            <% } %>

            <!--
              IMPORTANT:
              LoginServlet must read request.getParameter("identity")
              and request.getParameter("password"), and be mapped to /login.sig
            -->
            <form class="login-form"
                  action="<%= request.getContextPath() %>/login"
                  method="post">

                <label for="identity">Username or Email</label>
                <input
                    type="text"
                    id="identity"
                    name="identity"
                    placeholder="Enter your username or email"
                    autocomplete="username"
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

                <button type="submit" class="login-submit">
                    Sign In to Student Portal
                </button>
            </form>

            <div class="login-bottom">
                Don't have an account?
                <a href="<%= request.getContextPath() %>/register.jsp">Create an account</a>
            </div>

            <a href="<%= request.getContextPath() %>/index.html" class="login-home">
                Return to homepage
            </a>
        </section>

    </div>
</main>

<footer class="login-footer">
    CodeQuest &middot; Learn. Practise. Progress.
</footer>
</body>
</html>
