import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';

import 'loading_icon.dart';

enum AppTipsType { blank, loading, noNetwork, error, refresh }

class AppTips {
  static double get defaultIconSize => UIConstants.uiSize.xxl;

  static Widget _buildIcon(AppTipsType type, double? size) {
    final IconData icon;
    switch (type) {
      case .noNetwork:
        icon = LucideIcons.wifi_off;
        break;
      case .blank:
        icon = LucideIcons.eye_off;
        break;
      case .error:
        icon = LucideIcons.circle_alert;
        break;
      case .refresh:
        icon = LucideIcons.refresh_ccw;
        break;
      case .loading:
        return LoadingIcon(size: size ?? defaultIconSize);
    }
    return Icon(icon, size: size ?? defaultIconSize);
  }

  static Widget _buildText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: ColorConstants.defaultTextColor,
        fontSize: FontConstants.fontSize.md,
        fontFamily: FontConstants.fontFamily,
        fontWeight: .w500,
      ),
      overflow: .fade,
    );
  }

  static Widget text(String text) {
    return Container(
      width: .infinity,
      padding: .symmetric(
        horizontal: UIConstants.contentPaddingFromSides,
        vertical: UIConstants.gapSize.md,
      ),
      child: _buildText(text),
    );
  }

  static Widget icon({
    AppTipsType type = .loading,
    String? text,
    double? size,
  }) {
    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      mainAxisSize: .min,
      spacing: text is String ? UIConstants.gapSize.lg : 0,
      children: [_buildIcon(type, size), if (text is String) _buildText(text)],
    );
  }
}
