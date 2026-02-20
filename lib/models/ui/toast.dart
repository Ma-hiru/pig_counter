import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';

enum ToastType { normal, success, error }

class ToastData {
  final String message;
  final Duration duration;
  final ToastType type;

  const ToastData({
    required this.message,
    this.type = .normal,
    this.duration = const Duration(seconds: 3),
  });

  Color get backgroundColor {
    switch (type) {
      case ToastType.normal:
        return ColorConstants.themeColor;
      case ToastType.success:
        return ColorConstants.successColor;
      case ToastType.error:
        return ColorConstants.errorColor;
    }
  }

  Color get textColor {
    return Colors.white;
  }

  Icon get icon {
    switch (type) {
      case ToastType.normal:
        return Icon(
          LucideIcons.info,
          color: textColor,
          size: FontConstants.fontSize.md,
        );
      case ToastType.success:
        return Icon(
          LucideIcons.circle_check,
          color: textColor,
          size: FontConstants.fontSize.md,
        );
      case ToastType.error:
        return Icon(
          LucideIcons.circle_alert,
          color: textColor,
          size: FontConstants.fontSize.md,
        );
    }
  }

  factory ToastData.normal(String message) {
    return ToastData(message: message, type: .normal);
  }

  factory ToastData.success(String message) {
    return ToastData(message: message, type: .success);
  }

  factory ToastData.error(String message) {
    return ToastData(message: message, type: .error);
  }
}
