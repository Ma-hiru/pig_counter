import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';

import '../models/ui/toast.dart';

class Toast {
  static Future<ToastFuture?> showToast(ToastData data) async {
    if (data.message.isEmpty) return null;
    return showToastWidget(
      Toast._getContentWidget(data),
      duration: data.duration,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      position: .top,
      animationBuilder: _okToastAnimationBuilder,
    );
  }

  static Widget _getContentWidget(ToastData data) {
    return Container(
      padding: .symmetric(
        horizontal: UIConstants.gapSize.lg,
        vertical: UIConstants.gapSize.md,
      ),
      decoration: BoxDecoration(
        color: data.backgroundColor,
        borderRadius: .circular(UIConstants.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          data.icon,
          SizedBox(width: UIConstants.gapSize.md),
          Text(
            data.message,
            style: TextStyle(
              color: data.textColor,
              fontSize: FontConstants.fontSize.md,
              fontFamily: FontConstants.fontFamily,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  static Widget _okToastAnimationBuilder(
    BuildContext context,
    Widget child,
    AnimationController controller,
    double percent,
  ) {
    return Transform.translate(
      offset: Offset(0, -UIConstants.toastDistanceFromTop * (1 - percent)),
      child: Opacity(opacity: percent, child: child),
    );
  }
}
