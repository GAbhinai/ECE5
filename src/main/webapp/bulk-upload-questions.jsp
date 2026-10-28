<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession adminSession = request.getSession(false);

    if (adminSession == null || adminSession.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String duplicates = request.getParameter("duplicates");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bulk Upload Questions | CodeQuest</title>

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            min-height: 100vh;
            background: #0b1020;
            color: #edf1ff;
            font-family: Arial, sans-serif;
        }

        .upload-navbar {
            min-height: 76px;
            padding: 0 7%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            background: #151e34;
            border-bottom: 1px solid #303d5e;
        }

        .upload-navbar .logo {
            color: #8ca8ff;
            font-size: 27px;
            font-weight: bold;
            text-decoration: none;
        }

        .upload-navbar a:last-child {
            color: #edf1ff;
            text-decoration: none;
        }

        .upload-navbar a:last-child:hover { color: #aab7ff; }

        .upload-container {
            width: min(1125px, calc(100% - 32px));
            margin: 50px auto;
        }

        .upload-card {
            padding: 35px;
            background: #151e34;
            border: 1px solid #303d5e;
            border-radius: 18px;
        }

        .upload-card h1 { margin-top: 0; font-size: 30px; }

        .upload-description {
            color: #b6c1dc;
            line-height: 1.8;
        }

        .template-download-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
            margin: 25px 0;
            padding: 22px;
            background: #0b1020;
            border: 1px solid #34415f;
            border-radius: 12px;
        }

        .template-info { flex: 1; min-width: 220px; }

        .template-info h3 {
            color: #edf1ff;
            font-size: 18px;
            margin: 0 0 8px;
        }

        .template-info p {
            color: #b6c1dc;
            font-size: 14px;
            line-height: 1.7;
            margin: 0;
        }

        .template-download-button {
            display: inline-block;
            padding: 13px 20px;
            background: #6578ff;
            color: #fff;
            text-decoration: none;
            font-weight: bold;
            border-radius: 8px;
            text-align: center;
            white-space: nowrap;
            transition: background 0.2s ease;
        }

        .template-download-button:hover {
            background: #5065ed;
            color: #fff;
        }

        .upload-label {
            display: block;
            margin: 25px 0 10px;
            font-weight: bold;
        }

        .upload-input {
            display: block;
            width: 100%;
            padding: 15px;
            color: #edf1ff;
            background: #0b1020;
            border: 1px solid #364462;
            border-radius: 9px;
        }

        .upload-input:focus {
            outline: 2px solid #657cff;
            outline-offset: 2px;
        }

        .upload-button {
            display: inline-block;
            margin-top: 22px;
            padding: 13px 22px;
            background: #657cff;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s, transform 0.2s;
        }

        .upload-button:hover {
            background: #7d90ff;
            transform: translateY(-1px);
        }

        .upload-success, .upload-duplicate, .upload-error {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            margin: 22px 0;
            padding: 18px 20px;
            border-radius: 10px;
            line-height: 1.6;
        }

        .upload-success {
            background: #103c2b;
            border: 1px solid #22c55e;
            color: #bbf7d0;
        }

        .upload-duplicate {
            background: #3b3015;
            border: 1px solid #eab308;
            color: #fef08a;
        }

        .upload-error {
            background: #421d29;
            border: 1px solid #ef4444;
            color: #fecaca;
        }

        .message-icon { font-size: 22px; }

        .success-title, .duplicate-title, .error-title {
            display: block;
            margin-bottom: 4px;
            font-size: 17px;
            font-weight: bold;
        }

        .success-title { color: #86efac; }
        .duplicate-title { color: #fde047; }
        .error-title { color: #fca5a5; }

        .upload-note {
            margin-top: 30px;
            padding: 20px;
            background: #0b1020;
            border: 1px solid #202c47;
            border-radius: 10px;
            color: #b6c1dc;
            line-height: 1.8;
            font-size: 14px;
        }

        .upload-note strong { color: #edf1ff; }

        .upload-note code {
            display: block;
            margin: 12px 0;
            padding: 12px;
            background: #151e34;
            border-radius: 6px;
            color: #aab7ff;
            overflow-wrap: anywhere;
            line-height: 1.8;
        }

        .back-link {
            display: inline-block;
            margin-top: 25px;
            color: #aab7ff;
            text-decoration: none;
        }

        .back-link:hover { color: #fff; }

        @media (max-width: 600px) {
            .upload-navbar { padding: 0 16px; }
            .upload-navbar .logo { font-size: 22px; }
            .upload-container { margin: 25px auto; }
            .upload-card { padding: 22px; }
            .upload-card h1 { font-size: 25px; }

            .template-download-section {
                align-items: stretch;
                flex-direction: column;
            }

            .template-download-button, .upload-button { width: 100%; }
            .template-download-button { white-space: normal; }
        }
    </style>
</head>

<body>
    <nav class="upload-navbar">
        <a href="<%= request.getContextPath() %>/index.html" class="logo">CodeQuest</a>
        <a href="<%= request.getContextPath() %>/admin-dashboard.jsp">Admin Dashboard</a>
    </nav>

    <main class="upload-container">
        <section class="upload-card">
            <h1>Bulk Upload Questions</h1>

            <p class="upload-description">
                Upload a CSV file to import multiple programming questions into your CodeQuest question bank.
            </p>

            <!-- Excel template download -->
            <div class="template-download-section">
                <div class="template-info">
                    <h3>Excel Question Template</h3>
                    <p>
                        Download the Excel template, add your questions,
                        and save the completed sheet as CSV before uploading.
                    </p>
                </div>

                <a class="template-download-button"
                   href="<%= request.getContextPath() %>/CodeQuest_Question_Upload_Template.xlsx"
                   download="CodeQuest_Question_Upload_Template.xlsx">
                    Download Excel Template
                </a>
            </div>

            <% if (success != null && success.matches("\\d+")) { %>
                <div class="upload-success" role="status">
                    <span class="message-icon">&#10004;</span>
                    <div>
                        <span class="success-title">Upload Successful!</span>
                        <strong><%= success %> questions added successfully!</strong>
                        <div>Your questions have been added to the CodeQuest question bank.</div>
                    </div>
                </div>
            <% } %>

            <% if (duplicates != null && duplicates.matches("\\d+")
                    && Integer.parseInt(duplicates) > 0) { %>
                <div class="upload-duplicate" role="status">
                    <span class="message-icon">&#9888;</span>
                    <div>
                        <span class="duplicate-title">Duplicate Questions Skipped</span>
                        <strong><%= duplicates %> duplicate questions were not added.</strong>
                        <div>Questions that already exist or are repeated in the uploaded file were skipped.</div>
                    </div>
                </div>
            <% } %>

            <% if (error != null) { %>
                <div class="upload-error" role="alert">
                    <span class="message-icon">&#10006;</span>
                    <div>
                        <span class="error-title">Upload Failed</span>
                        <% if ("nofile".equals(error)) { %>
                            Please select a CSV file before uploading.
                        <% } else if ("invalidfile".equals(error)) { %>
                            Please upload a valid CSV file.
                        <% } else if ("header".equals(error)) { %>
                            The CSV column names do not match the required format.
                        <% } else if ("format".equals(error)) { %>
                            A row has an incorrect number of columns. Please check your CSV file.
                        <% } else if ("data".equals(error)) { %>
                            Please check your question data and correct answers.
                        <% } else if ("xp".equals(error)) { %>
                            XP must be a non-negative number.
                        <% } else if ("empty".equals(error)) { %>
                            The CSV file contains no questions to upload.
                        <% } else if ("filesize".equals(error)) { %>
                            The file is too large. The maximum allowed size is 5 MB.
                        <% } else { %>
                            An unexpected error occurred. Please check the CSV file and try again.
                        <% } %>
                    </div>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/bulk-upload-questions"
                  method="post" enctype="multipart/form-data">

                <label class="upload-label" for="csvFile">Select CSV File</label>

                <input class="upload-input"
                       type="file"
                       id="csvFile"
                       name="csvFile"
                       accept=".csv,text/csv"
                       required>

                <button class="upload-button" type="submit">Upload Questions</button>
            </form>

            <div class="upload-note">
                <strong>CSV column format</strong>
                <p>Your file must contain these columns in this order:</p>
                <code>title,description,category,difficulty,option_a,option_b,option_c,option_d,correct_answer,xp_reward</code>
                <p>Each subsequent row should contain one question. The correct answer must be A, B, C, or D.</p>
                <p>
                    <strong>Note:</strong> The current upload form accepts CSV files.
                    Open the downloaded Excel template and use File &rarr; Save As
                    &rarr; CSV UTF-8 before uploading.
                </p>
            </div>

            <a class="back-link" href="<%= request.getContextPath() %>/admin-dashboard.jsp">
                &larr; Back to Admin Dashboard
            </a>
        </section>
    </main>
</body>
</html>
