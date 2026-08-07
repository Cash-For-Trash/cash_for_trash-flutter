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
  static String refreshToken = "/auth/refresh-token";
  static String verifyEmail = "/auth/verify-email/";
  static String checkToken = "/auth/check-token";

  // garbage types
  static String garbageTypes = "/garbage-types";
  static String addresses = "/addresses";
  static String userProfile = "/user/profile";
  static String availabilities = "/availabilities";
  static String myAvailabilities = "/availabilities/my";
  static String areas = "/areas";
  static String pricing = "/pricing";

  // admin
  static String adminWorkers = "/admin/workers";
  static String adminCustomers = "/admin/customers";
  static String workerApprove = "/workers";
  static String rewardsAdmin = "/rewards";
  static String rewardRedeems = "/reward-redeems";
  static String myRedemptions = "/reward-redeems/my_redemptions";

  // collection requests
  static String collectionRequests = "/collection-requests";
  static String myCollectionRequests = "/collection-requests/my-collection-requests";
  static String workerCollectionRequests = "/workers/collection-requests";
  static String collectionAvailabilities(String addressId) =>
      "/collection-requests/addresses/$addressId/availabilities";

  // rewards & points
  static String rewards = "/rewards";
  static String customerPoints = "/customer/points";
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
  static String nationalId = "national_id";
  static String isApproved = "is_approved";
  static String areaId = "area_id";
  static String dayOfWeek = "day_of_week";
  static String fromTime = "from_time";
  static String toTime = "to_time";
  static String status = "status";
  static String weights = "weights";
  static String actualWeight = "actual_weight";
  static String garbageTypeId = "garbage_type_id";
}
