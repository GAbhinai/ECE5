
package com.codequest.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Scanner;

public class CreateAdminOnce {

    public static void main(String[] args) throws Exception {

        Scanner sc = new Scanner(System.in);

        System.out.print("Enter admin username: ");
        String username = sc.nextLine().trim();

        System.out.print("Enter admin password: ");
        String password = sc.nextLine();

        String sql = "INSERT INTO admins " +
                     "(username, password_hash) VALUES (?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, PasswordUtil.hash(password));

            ps.executeUpdate();

            System.out.println("Administrator created successfully.");
        }

        sc.close();
    }
}
