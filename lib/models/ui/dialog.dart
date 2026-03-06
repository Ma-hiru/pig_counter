import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../constants/color.dart';

enum DialogType { info, success, error }

class DialogData {
  final String title;
  final String description;
  final DialogType type;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const DialogData({
    required this.title,
    required this.description,
    this.type = DialogType.info,
    this.confirmText = "确定",
    this.cancelText = "取消",
    this.onConfirm,
    this.onCancel,
  });

  Color get headerColor {
    switch (type) {
      case DialogType.info:
        return ColorConstants.themeColor;
      case DialogType.success:
        return ColorConstants.successColor;
      case DialogType.error:
        return ColorConstants.errorColor;
    }
  }

  Color get confirmButtonColor {
    switch (type) {
      case DialogType.info:
        return ColorConstants.themeColor;
      case DialogType.success:
        return ColorConstants.successColor;
      case DialogType.error:
        return ColorConstants.errorColor;
    }
  }

  IconData get icon {
    switch (type) {
      case DialogType.info:
        return LucideIcons.info;
      case DialogType.success:
        return LucideIcons.circle_check;
      case DialogType.error:
        return LucideIcons.circle_alert;
    }
  }

  factory DialogData.info({
    required String title,
    required String description,
    String confirmText = "确定",
    String cancelText = "取消",
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return DialogData(
      title: title,
      description: description,
      type: DialogType.info,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  factory DialogData.success({
    required String title,
    required String description,
    String confirmText = "确定",
    String cancelText = "取消",
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return DialogData(
      title: title,
      description: description,
      type: DialogType.success,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  factory DialogData.error({
    required String title,
    required String description,
    String confirmText = "确定",
    String cancelText = "取消",
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return DialogData(
      title: title,
      description: description,
      type: DialogType.error,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }
}
