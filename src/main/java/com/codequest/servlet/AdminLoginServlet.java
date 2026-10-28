
package com.codequest.servlet;

import com.codequest.util.DBConnection;
import com.codequest.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null) {
            response.sendRedirect("admin-login.jsp?error=1");
            return;
        }

        String sql = "SELECT admin_id, username, password_hash " +
                     "FROM admins WHERE username=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() &&
                    PasswordUtil.verify(
                        password, rs.getString("password_hash"))) {

                    HttpSession old = request.getSession(false);
                    if (old != null) {
                        old.invalidate();
                    }

                    HttpSession session = request.getSession(true);
                    session.setAttribute("adminId",
                                         rs.getInt("admin_id"));
                    session.setAttribute("adminUsername",
                                         rs.getString("username"));
                    session.setMaxInactiveInterval(30 * 60);

                    response.sendRedirect("admin-dashboard.jsp");
                    return;
                }
            }

            response.sendRedirect("admin-login.jsp?error=1");

        } catch (Exception e) {
            throw new ServletException(
                "Unable to authenticate administrator", e);
        }
    }
}
