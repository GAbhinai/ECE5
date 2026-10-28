<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create Account | CodeQuest</title>
<link rel="stylesheet" href="css/style.css">

<style>
* {
    box-sizing: border-box;
}

html, body {
    margin: 0;
    min-height: 100%;
}

body {
    min-height: 100vh;
    background: #0b1020;
    color: #edf1ff;
    font-family: Arial, Helvetica, sans-serif;
}

/* NAVBAR - fixed alignment */
body > .navbar {
    width: 100% !important;
    height: 76px !important;
    min-height: 76px !important;
    margin: 0 !important;
    padding: 0 7% !important;

    display: flex !important;
    flex-direction: row !important;
    align-items: center !important;
    justify-content: space-between !important;
    gap: 20px !important;

    position: relative !important;
    top: auto !important;
    left: auto !important;
    right: auto !important;

    background: #151e34 !important;
    border-bottom: 1px solid #293653 !important;
    box-sizing: border-box !important;
}

body > .navbar > a.logo {
    display: inline-block !important;
    width: auto !important;
    margin: 0 !important;
    padding: 0 !important;

    color: #8ca8ff !important;
    font-size: 28px !important;
    font-weight: 800 !important;
    letter-spacing: -0.7px !important;
    text-decoration: none !important;
    white-space: nowrap !important;
}

body > .navbar > a:last-child {
    display: inline-block !important;
    width: auto !important;
    margin: 0 !important;
    padding: 10px 0 !important;

    color: #edf1ff !important;
    font-size: 15px !important;
    text-decoration: none !important;
    white-space: nowrap !important;
}

body > .navbar > a:last-child:hover {
    color: #a8b5ff !important;
}

/* PAGE LAYOUT */
.register-page {
    width: 100%;
    min-height: calc(100vh - 120px);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px 24px;
}

.register-layout {
    width: 100%;
    max-width: 1230px;
    display: grid;
    grid-template-columns: 0.9fr 1.1fr;
    overflow: hidden;
    border: 1px solid #303d5e;
    border-radius: 24px;
    background: #131b30;
    box-shadow: 0 25px 80px rgba(0, 0, 0, 0.35);
    margin: 0 auto;
}

/* LEFT PANEL */
.register-welcome {
    min-width: 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: clamp(32px, 4vw, 58px);
    background:
        radial-gradient(circle at 10% 10%, rgba(139, 92, 246, 0.25), transparent 45%),
        linear-gradient(145deg, #1b2647, #11182d);
}

.register-logo {
    display: grid;
    place-items: center;
    flex-shrink: 0;
    width: 58px;
    height: 58px;
    margin-bottom: 34px;
    border-radius: 17px;
    background: linear-gradient(135deg, #7185ff, #a78bfa);
    color: white;
    font-size: 28px;
    font-weight: 850;
}

.register-welcome h1 {
    margin: 0 0 20px;
    color: #edf1ff;
    font-size: clamp(32px, 3vw, 48px);
    line-height: 1.2;
    letter-spacing: -1.2px;
}

.register-gradient {
    display: block;
    color: #a8b5ff;
}

.register-welcome > p {
    margin: 0;
    color: #b6c1dc;
    font-size: 16px;
    line-height: 1.9;
}

.register-benefits {
    display: grid;
    gap: 16px;
    margin-top: 30px;
}

.register-benefit {
    display: flex;
    align-items: center;
    gap: 12px;
    color: #dce3fb;
    font-size: 14px;
    line-height: 1.5;
}

.benefit-icon {
    display: grid;
    place-items: center;
    flex-shrink: 0;
    width: 32px;
    height: 32px;
    border-radius: 10px;
    background: rgba(113, 133, 255, 0.15);
    color: #aab7ff;
    font-weight: bold;
}

/* RIGHT PANEL */
.register-form-side {
    min-width: 0;
    padding: clamp(32px, 4vw, 58px);
    display: flex;
    flex-direction: column;
    justify-content: center;
    background: #131b30;
    border-left: 1px solid rgba(48, 61, 94, 0.45);
}

.register-eyebrow {
    margin: 0 0 14px;
    color: #a8b5ff;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 2.5px;
}

.register-form-side h2 {
    margin: 0 0 10px;
    color: #edf1ff;
    font-size: clamp(28px, 2.5vw, 36px);
    line-height: 1.25;
}

.register-subtitle {
    margin: 0 0 24px;
    color: #b6c1dc;
    font-size: 15px;
    line-height: 1.7;
}

.register-form {
    display: flex;
    flex-direction: column;
    width: 100%;
    min-width: 0;
}

.register-form label {
    display: block;
    margin: 15px 0 8px;
    color: #edf1ff;
    font-size: 15px;
    font-weight: 500;
}

.register-form input {
    display: block;
    width: 100%;
    min-width: 0;
    height: 49px;
    margin: 0;
    padding: 0 15px;
    border: 1px solid #364462;
    border-radius: 8px;
    outline: none;
    background: #0b1020;
    color: #edf1ff;
    font-family: inherit;
    font-size: 14px;
}

.register-form input::placeholder {
    color: #78839c;
}

.register-form input:focus {
    border-color: #8295ff;
    box-shadow: 0 0 0 3px rgba(130, 149, 255, 0.12);
}

.password-hint {
    display: block;
    margin-top: 7px;
    color: #8998b9;
    font-size: 12px;
    line-height: 1.5;
}

.register-submit {
    width: 100%;
    min-height: 49px;
    margin-top: 25px;
    padding: 12px 18px;
    border: 0;
    border-radius: 9px;
    background: linear-gradient(135deg, #7185ff, #8b70f5);
    color: white;
    font-family: inherit;
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
    transition: transform 0.2s, filter 0.2s;
}

.register-submit:hover {
    filter: brightness(1.1);
    transform: translateY(-1px);
}

.register-bottom {
    margin-top: 22px;
    color: #aab6d4;
    font-size: 14px;
    text-align: center;
    line-height: 1.8;
}

.register-bottom a,
.register-home {
    color: #aab7ff;
    font-weight: 700;
    text-decoration: none;
}

.register-bottom a:hover,
.register-home:hover {
    color: white;
}

.register-home {
    display: block;
    margin-top: 16px;
    color: #aebbe0;
    font-size: 13px;
    font-weight: 500;
    text-align: center;
}

/* ERROR MESSAGES */
.error {
    margin: 12px 0;
    padding: 11px 13px;
    border: 1px solid rgba(248, 113, 113, 0.35);
    border-radius: 8px;
    background: rgba(127, 29, 29, 0.2);
    color: #fca5a5;
    font-size: 13px;
    line-height: 1.5;
}

#passwordError {
    display: none;
}

/* FOOTER */
.register-footer {
    padding: 20px;
    color: #7f8eaf;
    font-size: 12px;
    text-align: center;
}

/* TABLET */
@media (max-width: 850px) {
    .register-layout {
        max-width: 650px;
        grid-template-columns: 1fr;
    }

    .register-welcome {
        padding: 32px;
    }

    .register-logo {
        margin-bottom: 22px;
    }

    .register-welcome h1 {
        font-size: 35px;
    }

    .register-benefits {
        margin-top: 22px;
    }

    .register-form-side {
        padding: 32px;
        border-left: 0;
        border-top: 1px solid rgba(48, 61, 94, 0.65);
    }

    .register-page {
        padding: 30px 18px;
    }
}

/* MOBILE */
@media (max-width: 480px) {
    body > .navbar {
        padding: 0 16px !important;
        gap: 10px !important;
    }

    body > .navbar > a.logo {
        font-size: 22px !important;
    }

    body > .navbar > a:last-child {
        font-size: 12px !important;
    }

    .register-page {
        padding: 20px 12px;
    }

    .register-layout {
        border-radius: 16px;
    }

    .register-welcome,
    .register-form-side {
        padding: 24px 20px;
    }

    .register-welcome h1 {
        font-size: 30px;
    }

    .register-welcome > p {
        font-size: 14px;
    }

    .register-form-side h2 {
        font-size: 27px;
    }
}
</style>
</head>

<body>

<nav class="navbar">
    <a href="index.html" class="logo">CodeQuest</a>
    <a href="login.jsp">Already registered</a>
</nav>

<main class="register-page">
    <div class="register-layout">

        <section class="register-welcome">
            <div class="register-logo">C</div>

            <h1>
                Your coding journey starts
                <span class="register-gradient">with one step.</span>
            </h1>

            <p>
                Create your CodeQuest account and turn your programming
                practice into progress. Learn, solve missions, earn XP
                and build your developer skills.
            </p>

            <div class="register-benefits">
                <div class="register-benefit">
                    <span class="benefit-icon">&#10003;</span>
                    <span>Practise Java, SQL and DSA</span>
                </div>

                <div class="register-benefit">
                    <span class="benefit-icon">&#10003;</span>
                    <span>Complete missions and earn XP</span>
                </div>

                <div class="register-benefit">
                    <span class="benefit-icon">&#10003;</span>
                    <span>Track your level and achievements</span>
                </div>
            </div>
        </section>

        <section class="register-form-side">
            <div class="register-eyebrow">JOIN CODEQUEST</div>

            <h2>Create your account</h2>

            <p class="register-subtitle">
                Enter your details to begin your coding journey.
            </p>

            <%
                String error = request.getParameter("error");

                if (error != null) {
                    String message;

                    switch (error) {
                        case "username":
                            message = "This username is already taken.";
                            break;
                        case "email":
                            message = "This email is already registered.";
                            break;
                        case "password":
                            message = "The passwords do not match.";
                            break;
                        default:
                            message = "Registration failed. Please check your details and try again.";
                            break;
                    }
            %>
                <p class="error" role="alert"><%= message %></p>
            <%
                }
            %>

            <form class="register-form"
                  action="register"
                  method="post"
                  id="registerForm">

                <label for="username">Username</label>
                <input
                    type="text"
                    id="username"
                    name="username"
                    placeholder="Choose a username"
                    autocomplete="username"
                    maxlength="50"
                    required>

                <label for="email">Email address</label>
                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="you@example.com"
                    autocomplete="email"
                    required>

                <label for="password">Password</label>
                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="Create a password"
                    autocomplete="new-password"
                    minlength="8"
                    maxlength="128"
                    required>

                <span class="password-hint">
                    Use at least 8 characters.
                </span>

                <label for="confirmPassword">Confirm password</label>
                <input
                    type="password"
                    id="confirmPassword"
                    name="confirmPassword"
                    placeholder="Enter your password again"
                    autocomplete="new-password"
                    minlength="8"
                    maxlength="128"
                    required>

                <p id="passwordError" class="error" role="alert">
                    Passwords do not match.
                </p>

                <button type="submit" class="register-submit">
                    Create My Account &nbsp; &rarr;
                </button>
            </form>

            <div class="register-bottom">
                Already have an account?
                <a href="login.jsp">Sign in</a>
            </div>

            <a href="index.html" class="register-home">
                &larr; Return to homepage
            </a>
        </section>

    </div>
</main>

<footer class="register-footer">
    CodeQuest &middot; Learn. Practise. Progress.
</footer>

<script>
    const registerForm = document.getElementById("registerForm");
    const password = document.getElementById("password");
    const confirmPassword = document.getElementById("confirmPassword");
    const passwordError = document.getElementById("passwordError");

    function validatePasswords() {
        const mismatch =
            confirmPassword.value !== "" &&
            password.value !== confirmPassword.value;

        passwordError.style.display = mismatch ? "block" : "none";

        confirmPassword.setCustomValidity(
            mismatch ? "Passwords do not match." : ""
        );

        return !mismatch;
    }

    password.addEventListener("input", validatePasswords);
    confirmPassword.addEventListener("input", validatePasswords);

    registerForm.addEventListener("submit", function(event) {
        if (!validatePasswords()) {
            event.preventDefault();
            confirmPassword.reportValidity();
        }
    });
</script>

</body>
</html>