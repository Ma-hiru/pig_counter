import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';

import 'loading_icon.dart';

enum AppTipsType { blank, loading, noNetwork }

class AppTips {
  static double get defaultIconSize => UIConstants.uiSize.xxl;

  static Widget _buildIcon(AppTipsType type, double? size) {
    if (type == .noNetwork) {
      return Icon(LucideIcons.wifi_off, size: size ?? defaultIconSize);
    } else if (type == .blank) {
      return Icon(LucideIcons.eye_off, size: size ?? defaultIconSize);
    } else {
      return LoadingIcon(size: size ?? defaultIconSize);
    }
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

  static Widget icon(String text, {AppTipsType type = .loading, double? size}) {
    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      mainAxisSize: .min,
      spacing: UIConstants.gapSize.lg,
      children: [_buildIcon(type, size), _buildText(text)],
    );
  }
}
