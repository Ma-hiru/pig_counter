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
    xs: 5,
    sm: 10,
    md: 16,
    lg: 22,
    xl: 28,
    xxl: 36,
    xxxl: 44,
  );
  static const SizeEnum gapSize = SizeEnum(
    xs: 2,
    sm: 4,
    md: 8,
    lg: 12,
    xl: 16,
    xxl: 24,
    xxxl: 32,
  );
  static const double borderRadius = 8.0;
  static const double toastDistanceFromTop = 50.0;
  static const double contentPaddingFromSides = 20.0;
}
