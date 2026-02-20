import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../constants/ui.dart';

class AppButton {
  static Widget blockButton({
    required String label,
    bool disabled = false,
    bool filled = false,
    Function()? onPressed,
  }) {
    final themeColor = disabled
        ? ColorConstants.themeColor.withAlpha(100)
        : ColorConstants.themeColor;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          if (!disabled) onPressed?.call();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? themeColor : Colors.transparent,
          overlayColor: ColorConstants.themeColor.withAlpha(30),
          padding: .symmetric(vertical: UIConstants.gapSize.md),
          side: BorderSide(color: ColorConstants.themeColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: .circular(UIConstants.borderRadius),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: FontConstants.fontSize.md,
            fontFamily: FontConstants.fontFamily,
            color: filled ? Colors.white : themeColor,
          ),
        ),
      ),
    );
  }
}
