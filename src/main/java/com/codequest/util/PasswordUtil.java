
package com.codequest.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class PasswordUtil {

    private static final int ITERATIONS = 210000;
    private static final int KEY_LENGTH = 256;
    private static final int SALT_LENGTH = 16;

    public static String hash(String password) throws Exception {

        byte[] salt = new byte[SALT_LENGTH];

        SecureRandom random = new SecureRandom();
        random.nextBytes(salt);

        byte[] hashedPassword = derive(
            password, salt, ITERATIONS
        );

        return ITERATIONS + ":"
            + Base64.getEncoder().encodeToString(salt) + ":"
            + Base64.getEncoder().encodeToString(hashedPassword);
    }

    public static boolean verify(
            String password, String storedPassword)
            throws Exception {

        if (password == null || storedPassword == null) {
            return false;
        }

        String[] parts = storedPassword.split(":", -1);

        if (parts.length != 3) {
            return false;
        }

        int iterations = Integer.parseInt(parts[0]);

        if (iterations < 1 || iterations > 1000000) {
            return false;
        }

        byte[] salt =
            Base64.getDecoder().decode(parts[1]);

        byte[] expectedHash =
            Base64.getDecoder().decode(parts[2]);

        if (salt.length != SALT_LENGTH) {
            return false;
        }

        byte[] actualHash = derive(
            password, salt, iterations
        );

        return MessageDigest.isEqual(
            expectedHash, actualHash
        );
    }

    private static byte[] derive(
            String password,
            byte[] salt,
            int iterations) throws Exception {

        PBEKeySpec spec = new PBEKeySpec(
            password.toCharArray(),
            salt,
            iterations,
            KEY_LENGTH
        );

        try {
            SecretKeyFactory factory =
                SecretKeyFactory.getInstance(
                    "PBKDF2WithHmacSHA256"
                );

            return factory.generateSecret(spec).getEncoded();

        } finally {
            spec.clearPassword();
        }
    }
}