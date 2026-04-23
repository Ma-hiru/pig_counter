class Validator {
  static String? username(String? value) {
    final text = (value ?? "").trim();
    if (text.isEmpty) return "请输入用户名";
    if (text.length < 3) return "用户名至少 3 位";
    if (text.length > 32) return "用户名最多 32 位";
    final usernamePattern = RegExp(r'^[a-zA-Z0-9_\-@.]+$');
    if (!usernamePattern.hasMatch(text)) {
      return "用户名仅支持字母、数字和 _ - @ .";
    }
    return null;
  }

  static String? password(String? value) {
    final text = (value ?? "").trim();
    if (text.isEmpty) return "请输入密码";
    if (text.length < 6) return "密码至少 6 位";
    if (text.length > 64) return "密码最多 64 位";
    return null;
  }
}
