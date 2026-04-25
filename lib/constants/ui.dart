import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';

import '../models/ui/size.dart';
import '../models/ui/tab.dart';

class UIConstants {
  static const List<TabItem> tabList = [
    TabItem(
      icon: Icon(LucideIcons.list_check),
      activeIcon: Icon(
        LucideIcons.list_check,
        color: ColorConstants.themeColor,
      ),
      label: "任务",
    ),
    TabItem(
      icon: Icon(LucideIcons.chart_no_axes_column),
      activeIcon: Icon(
        LucideIcons.chart_no_axes_column,
        color: ColorConstants.themeColor,
      ),
      label: "统计",
    ),
    TabItem(
      icon: Icon(LucideIcons.user_round),
      activeIcon: Icon(
        LucideIcons.user_round,
        color: ColorConstants.themeColor,
      ),
      label: "我的",
    ),
  ];
  static const SizeEnum uiSize = SizeEnum(
    xs: 6,
    sm: 11,
    md: 17,
    lg: 23,
    xl: 34,
    xxl: 44,
    xxxl: 56,
  );
  static const SizeEnum gapSize = SizeEnum(
    xs: 3,
    sm: 6,
    md: 10,
    lg: 14,
    xl: 18,
    xxl: 26,
    xxxl: 36,
  );
  static const double borderRadius = 10.0;
  static const double toastDistanceFromTop = 56.0;
  static const double contentPaddingFromSides = 22.0;
}
