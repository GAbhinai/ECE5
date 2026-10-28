
package com.codequest.servlet;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/add-question")
public class AddQuestionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");
        String a = request.getParameter("optionA");
        String b = request.getParameter("optionB");
        String c = request.getParameter("optionC");
        String d = request.getParameter("optionD");
        String answer = request.getParameter("correctAnswer");
        String xpText = request.getParameter("xpReward");

        if (title == null || description == null ||
            category == null || difficulty == null ||
            a == null || b == null || c == null || d == null ||
            answer == null || xpText == null) {
            response.sendRedirect("add-question.jsp?error=1");
            return;
        }

        title = title.trim();
        description = description.trim();
        category = category.trim();
        difficulty = difficulty.trim();
        a = a.trim();
        b = b.trim();
        c = c.trim();
        d = d.trim();
        answer = answer.trim();

        int xp;

        try {
            xp = Integer.parseInt(xpText);
        } catch (NumberFormatException e) {
            response.sendRedirect("add-question.jsp?error=1");
            return;
        }

        boolean valid =
            !title.isEmpty() && title.length() <= 150 &&
            !description.isEmpty() &&
            description.length() <= 10000 &&
            a.length() <= 255 && !a.isEmpty() &&
            b.length() <= 255 && !b.isEmpty() &&
            c.length() <= 255 && !c.isEmpty() &&
            d.length() <= 255 && !d.isEmpty() &&
            ("Java".equals(category) ||
             "SQL".equals(category) || "DSA".equals(category)) &&
            ("Easy".equals(difficulty) ||
             "Medium".equals(difficulty) ||
             "Hard".equals(difficulty)) &&
            ("A".equals(answer) || "B".equals(answer) ||
             "C".equals(answer) || "D".equals(answer)) &&
            xp >= 0 && xp <= 10000;

        if (!valid) {
            response.sendRedirect("add-question.jsp?error=1");
            return;
        }

        String sql = "INSERT INTO missions " +
            "(title,description,category,difficulty," +
            "option_a,option_b,option_c,option_d," +
            "correct_answer,xp_reward) VALUES (?,?,?,?,?,?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, category);
            ps.setString(4, difficulty);
            ps.setString(5, a);
            ps.setString(6, b);
            ps.setString(7, c);
            ps.setString(8, d);
            ps.setString(9, answer);
            ps.setInt(10, xp);

            ps.executeUpdate();

            response.sendRedirect("add-question.jsp?success=1");

        } catch (SQLException e) {
            throw new ServletException("Unable to save question", e);
        }
    }
}
