
package com.codequest.servlet;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

@WebServlet("/bulk-upload-questions")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 6 * 1024 * 1024
)
public class BulkUploadQuestionsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("bulk-upload-questions.jsp");
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Check whether the admin is logged in.
        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("adminId") == null) {

            response.sendRedirect("admin-login.jsp");
            return;
        }

        // Read the uploaded CSV file.
        Part filePart;

        try {
            filePart = request.getPart("csvFile");

        } catch (IllegalStateException e) {

            response.sendRedirect(
                "bulk-upload-questions.jsp?error=filesize"
            );
            return;
        }

        if (filePart == null || filePart.getSize() == 0) {

            response.sendRedirect(
                "bulk-upload-questions.jsp?error=nofile"
            );
            return;
        }

        // Validate the file extension.
        String fileName = filePart.getSubmittedFileName();

        if (fileName == null ||
                !fileName.toLowerCase(Locale.ROOT).endsWith(".csv")) {

            response.sendRedirect(
                "bulk-upload-questions.jsp?error=invalidfile"
            );
            return;
        }

        List<String[]> rows = new ArrayList<>();

        // Read and validate the CSV file.
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(
                    filePart.getInputStream(),
                    StandardCharsets.UTF_8))) {

            String line;
            boolean firstLine = true;

            while ((line = reader.readLine()) != null) {

                if (line.trim().isEmpty()) {
                    continue;
                }

                // Remove UTF-8 BOM if present.
                if (firstLine && line.startsWith("\uFEFF")) {
                    line = line.substring(1);
                }

                String[] columns = parseCsvLine(line);

                // Validate the CSV header.
                if (firstLine) {

                    firstLine = false;

                    if (columns.length != 10 ||
                            !columns[0].trim().equalsIgnoreCase("title") ||
                            !columns[1].trim().equalsIgnoreCase("description") ||
                            !columns[2].trim().equalsIgnoreCase("category") ||
                            !columns[3].trim().equalsIgnoreCase("difficulty") ||
                            !columns[4].trim().equalsIgnoreCase("option_a") ||
                            !columns[5].trim().equalsIgnoreCase("option_b") ||
                            !columns[6].trim().equalsIgnoreCase("option_c") ||
                            !columns[7].trim().equalsIgnoreCase("option_d") ||
                            !columns[8].trim().equalsIgnoreCase("correct_answer") ||
                            !columns[9].trim().equalsIgnoreCase("xp_reward")) {

                        response.sendRedirect(
                            "bulk-upload-questions.jsp?error=header"
                        );
                        return;
                    }

                    continue;
                }

                // Every data row must contain 10 columns.
                if (columns.length != 10) {

                    response.sendRedirect(
                        "bulk-upload-questions.jsp?error=format"
                    );
                    return;
                }

                String title = columns[0].trim();
                String description = columns[1].trim();
                String category = columns[2].trim();
                String difficulty = columns[3].trim();
                String optionA = columns[4].trim();
                String optionB = columns[5].trim();
                String optionC = columns[6].trim();
                String optionD = columns[7].trim();
                String answer = columns[8].trim().toUpperCase(Locale.ROOT);

                // Validate required fields.
                if (title.isEmpty() ||
                        description.isEmpty() ||
                        category.isEmpty() ||
                        difficulty.isEmpty() ||
                        optionA.isEmpty() ||
                        optionB.isEmpty() ||
                        optionC.isEmpty() ||
                        optionD.isEmpty() ||
                        !answer.matches("[ABCD]")) {

                    response.sendRedirect(
                        "bulk-upload-questions.jsp?error=data"
                    );
                    return;
                }

                // Validate XP reward.
                int xp;

                try {
                    xp = Integer.parseInt(columns[9].trim());

                    if (xp < 0) {
                        throw new NumberFormatException();
                    }

                } catch (NumberFormatException e) {

                    response.sendRedirect(
                        "bulk-upload-questions.jsp?error=xp"
                    );
                    return;
                }

                rows.add(new String[] {
                    title,
                    description,
                    category,
                    difficulty,
                    optionA,
                    optionB,
                    optionC,
                    optionD,
                    answer,
                    String.valueOf(xp)
                });
            }

        } catch (IOException e) {

            throw new ServletException(
                "Unable to read CSV file.", e
            );
        }

        // Check whether the CSV contains any questions.
        if (rows.isEmpty()) {

            response.sendRedirect(
                "bulk-upload-questions.jsp?error=empty"
            );
            return;
        }

        // SQL to identify questions already in the database.
        String duplicateSql =
            "SELECT mission_id FROM missions " +
            "WHERE LOWER(TRIM(title)) = LOWER(TRIM(?)) " +
            "AND LOWER(TRIM(description)) = LOWER(TRIM(?)) " +
            "LIMIT 1";

        // SQL to insert new questions.
        String insertSql =
            "INSERT INTO missions " +
            "(title, description, category, difficulty, " +
            "option_a, option_b, option_c, option_d, " +
            "correct_answer, xp_reward) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        int insertedCount = 0;
        int duplicateCount = 0;

        // Track duplicates within the same CSV file.
        Set<String> seenInCsv = new HashSet<>();

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try (
                PreparedStatement checkStmt =
                    con.prepareStatement(duplicateSql);

                PreparedStatement insertStmt =
                    con.prepareStatement(insertSql)
            ) {

                for (String[] row : rows) {

                    String title = row[0];
                    String description = row[1];

                    String duplicateKey =
                        title.trim().toLowerCase(Locale.ROOT)
                        + "\u0000"
                        + description.trim().toLowerCase(Locale.ROOT);

                    // Skip duplicates found earlier in this CSV.
                    if (!seenInCsv.add(duplicateKey)) {
                        duplicateCount++;
                        continue;
                    }

                    // Check for duplicates already in MySQL.
                    checkStmt.setString(1, title);
                    checkStmt.setString(2, description);

                    boolean alreadyExists;

                    try (ResultSet rs = checkStmt.executeQuery()) {
                        alreadyExists = rs.next();
                    }

                    if (alreadyExists) {
                        duplicateCount++;
                        continue;
                    }

                    // Insert a new question.
                    insertStmt.setString(1, row[0]);
                    insertStmt.setString(2, row[1]);
                    insertStmt.setString(3, row[2]);
                    insertStmt.setString(4, row[3]);
                    insertStmt.setString(5, row[4]);
                    insertStmt.setString(6, row[5]);
                    insertStmt.setString(7, row[6]);
                    insertStmt.setString(8, row[7]);
                    insertStmt.setString(9, row[8]);
                    insertStmt.setInt(10, Integer.parseInt(row[9]));

                    insertStmt.executeUpdate();
                    insertedCount++;
                }

                // Save all successful insertions.
                con.commit();

            } catch (SQLException e) {

                // Roll back if an insertion fails.
                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    e.addSuppressed(rollbackError);
                }

                throw e;
            }

        } catch (SQLException e) {

            throw new ServletException(
                "Unable to insert questions into the missions table.",
                e
            );
        }

        // Redirect with insertion and duplicate counts.
        response.sendRedirect(
            "bulk-upload-questions.jsp?success=" + insertedCount
            + "&duplicates=" + duplicateCount
        );
    }

    // Parse CSV rows while supporting commas inside quoted fields.
    private String[] parseCsvLine(String line) {

        List<String> values = new ArrayList<>();
        StringBuilder value = new StringBuilder();
        boolean insideQuotes = false;

        for (int i = 0; i < line.length(); i++) {

            char ch = line.charAt(i);

            if (ch == '"') {

                // Handle escaped double quotes ("").
                if (insideQuotes &&
                        i + 1 < line.length() &&
                        line.charAt(i + 1) == '"') {

                    value.append('"');
                    i++;

                } else {
                    insideQuotes = !insideQuotes;
                }

            } else if (ch == ',' && !insideQuotes) {

                values.add(value.toString());
                value.setLength(0);

            } else {
                value.append(ch);
            }
        }

        values.add(value.toString());

        return values.toArray(new String[0]);
    }
}
