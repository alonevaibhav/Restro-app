// api_constants.dart

// Base URLs (you can comment/uncomment the one you need)
class ApiConstants {
  static const String baseUrl = "https://b-designer-api.vercel.app/";
// static const String baseUrl = "http://127.0.0.1:3000/";
// static const String baseUrl = "http://localhost:3000/";
}

/// Authentication Endpoints
class AuthEndpoints {
  static const String verifyUser = "auth/verify-user";
  static const String sendOtp = "auth/send-otp";
  static const String verifyOtp = "auth/verify-otp";
  static const String login = "architect/auth/login";
  static const String register = "architect/auth/register";
  static const String update = "architect/auth/update";
  static const String fetchProfile = "architect/auth/get-by-id";
}

/// Report Endpoints
class ReportEndpoints {
  static const String fetchReport = "architect/report/fetch-reports";
  static const String requestProject = "architect/report/request-project";
}

/// Rating Endpoints
class RatingEndpoints {
  static const String getMyRatings = "ratings/get-my-rating";
  static const String getRatings = "architect/get-rating-by-id";
}
