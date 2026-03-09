import 'package:flutter/services.dart';
import 'package:pig_counter/utils/toast.dart';

class ExitUtil {
  static DateTime? _lastBackPress;

  /// 处理返回键，双击退出程序。返回 true 表示应拦截（不退出）。
  static bool handleBackPress() {
    final now = DateTime.now();
    if (_lastBackPress != null &&
        now.difference(_lastBackPress!) < const Duration(seconds: 2)) {
      SystemNavigator.pop();
      return false;
    }
    _lastBackPress = now;
    Toast.showToast(.normal("再按一次退出程序"));
    return true;
  }
}
