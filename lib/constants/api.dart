class UserAPI {
  final String loginByAccount = "/user/login";
  final String signupByAccount = "/user/signup";
  final String logout = "/user/logout";
  final String detail = "/user";

  const UserAPI();
}

class APIConstants {
  static const UserAPI user = UserAPI();
}
