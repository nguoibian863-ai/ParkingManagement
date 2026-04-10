package util;

import java.nio.charset.StandardCharsets;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public final class PasswordUtil {

    private static final String PREFIX = "pbkdf2";
    private static final int SALT_LEN = 16;
    private static final int KEY_LEN_BITS = 256;
    private static final int DEFAULT_ITERATIONS = 100_000;

    private PasswordUtil() {}

    public static String hashPassword(String password) {
        if (password == null) password = "";
        byte[] salt = new byte[SALT_LEN];
        new SecureRandom().nextBytes(salt);
        byte[] hash = pbkdf2(password.toCharArray(), salt, DEFAULT_ITERATIONS, KEY_LEN_BITS);
        return PREFIX
                + "$" + DEFAULT_ITERATIONS
                + "$" + Base64.getEncoder().encodeToString(salt)
                + "$" + Base64.getEncoder().encodeToString(hash);
    }

    public static boolean verifyPassword(String password, String stored) {
        if (stored == null || stored.isEmpty()) return false;
        if (stored.startsWith(PREFIX + "$")) {
            String[] parts = stored.split("\\$");
            if (parts.length != 4) return false;
            int iterations;
            try {
                iterations = Integer.parseInt(parts[1]);
            } catch (NumberFormatException e) {
                return false;
            }
            byte[] salt;
            byte[] expected;
            try {
                salt = Base64.getDecoder().decode(parts[2]);
                expected = Base64.getDecoder().decode(parts[3]);
            } catch (IllegalArgumentException e) {
                return false;
            }
            byte[] actual = pbkdf2((password != null ? password : "").toCharArray(), salt, iterations, expected.length * 8);
            return constantTimeEquals(expected, actual);
        }
        // Legacy fallback: plain compare
        return (password != null ? password : "").equals(stored);
    }

    public static boolean needsUpgrade(String stored) {
        return stored != null && !stored.isEmpty() && !stored.startsWith(PREFIX + "$");
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int keyLenBits) {
        try {
            return pbkdf2WithAlgo("PBKDF2WithHmacSHA256", password, salt, iterations, keyLenBits);
        } catch (RuntimeException ex) {
            return pbkdf2WithAlgo("PBKDF2WithHmacSHA1", password, salt, iterations, keyLenBits);
        }
    }

    private static byte[] pbkdf2WithAlgo(String algo, char[] password, byte[] salt, int iterations, int keyLenBits) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, keyLenBits);
            SecretKeyFactory skf = SecretKeyFactory.getInstance(algo);
            return skf.generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException(e);
        }
    }

    private static boolean constantTimeEquals(byte[] a, byte[] b) {
        if (a == null || b == null) return false;
        if (a.length != b.length) return false;
        int r = 0;
        for (int i = 0; i < a.length; i++) r |= (a[i] ^ b[i]);
        return r == 0;
    }
}

