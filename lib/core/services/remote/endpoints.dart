class EndPoint {
  static String localUrl = "";
  static String remoteUrl = "http://23.21.86.102:3000/api";
  static String baseUrl = remoteUrl;
  static String get mediaBaseUrl => baseUrl.replaceFirst('/api', '');

  // auth
  static String login = "/auth/login/";
  static String register = "/auth/register/";
  static String changePassword = "/auth/change-password/";
  static String logout = "/auth/logout/";

  static String forgotPassword = "/auth/forgot-password/";
  static String resendOtp = "/auth/resend-otp";
  static String verifyOtp = "/auth/verify-otp";
  static String resetPassword = "/auth/reset-password/";
  static String refreshToken = "/auth/token/refresh";
  static String verifyEmail = "/auth/verify-email/";
  static String checkToken = "/auth/check-token";
}

class ApiKey {
  static String message = "message";
  static String authorization = "Authorization";
  static String firstName = "first_name";
  static String lastName = "last_name";
  static String email = "email";
  static String password = "password";
  static String role = "role";
  static String slug = "slug";
  static String isActive = "is_active";
  static String isVerified = "is_verified";
  static String student = "student";
  static String accessToken = "access";
  static String refreshToken = "refresh";
  static String user = "user";
  static String isLoggedIn = "is_logged_in";
  static String oldPassword = "old_password";
  static String newPassword = "new_password";
  static String image = "image";
  static String errors = "errors";
}
