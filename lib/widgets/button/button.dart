import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../constants/ui.dart';

class AppButton {
  static Widget normal({
    required String label,
    bool disabled = false,
    bool filled = false,
    bool blocked = true,
    bool loading = false,
    Function()? onPressed,
  }) {
    final buttonColor = ButtonColor(
      disabled: disabled || loading,
      filled: filled,
    );
    return SizedBox(
      width: blocked ? double.infinity : null,
      child: OutlinedButton(
        onPressed: () {
          if (!disabled && !loading) onPressed?.call();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: buttonColor.backgroundColor,
          overlayColor: buttonColor.overlayColor,
          padding: .symmetric(vertical: UIConstants.gapSize.lg),
          side: BorderSide(
            color: buttonColor.themeColor,
            width: UIConstants.gapSize.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: .circular(UIConstants.borderRadius),
          ),
        ),
        child: loading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: buttonColor.textColor,
                    ),
                  ),
                  SizedBox(width: UIConstants.gapSize.md),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: FontConstants.fontSize.md,
                      fontFamily: FontConstants.fontFamily,
                      color: buttonColor.textColor,
                    ),
                  ),
                ],
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: FontConstants.fontSize.md,
                  fontFamily: FontConstants.fontFamily,
                  color: buttonColor.textColor,
                ),
              ),
      ),
    );
  }

  static Widget text({
    required String label,
    bool disabled = false,
    Function()? onPressed,
    Color? color,
  }) {
    final buttonColor = ButtonColor(disabled: disabled, filled: false);
    return OutlinedButton(
      onPressed: () {
        if (!disabled) onPressed?.call();
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: buttonColor.backgroundColor,
        overlayColor: buttonColor.overlayColor,
        padding: .symmetric(vertical: UIConstants.gapSize.lg),
        side: .none,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(UIConstants.borderRadius),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: FontConstants.fontSize.md,
          fontFamily: FontConstants.fontFamily,
          color: buttonColor.textColor,
        ),
      ),
    );
  }
}

class ButtonColor {
  bool disabled;
  bool filled;

  ButtonColor({required this.disabled, required this.filled});

  Color get themeColor => disabled
      ? ColorConstants.themeColor.withAlpha(150)
      : ColorConstants.themeColor;

  Color get overlayColor => disabled
      ? Colors.transparent
      : filled
      ? ColorConstants.textColorOnTheme.withAlpha(150)
      : themeColor.withAlpha(150);

  Color get textColor {
    var textColor = filled ? ColorConstants.textColorOnTheme : themeColor;
    if (disabled) return textColor.withAlpha(150);
    return textColor;
  }

  Color get backgroundColor => filled ? themeColor : Colors.transparent;
}
