import 'dart:ui';

import '../models/tab.dart';

class UIConstants {
  static const List<TabItem> tabList = [
    TabItem(
      icon: "lib/assets/tab/ic_public_home_normal.png",
      activeIcon: "lib/assets/tab/ic_public_home_active.png",
      label: "任务",
    ),
    TabItem(
      icon: "lib/assets/tab/ic_public_pro_normal.png",
      activeIcon: "lib/assets/tab/ic_public_pro_active.png",
      label: "统计",
    ),
    TabItem(
      icon: "lib/assets/tab/ic_public_cart_normal.png",
      activeIcon: "lib/assets/tab/ic_public_cart_active.png",
      label: "我的",
    ),
  ];

  static const ColorConstants colors = ColorConstants();
}

class ColorConstants {
  final Color themeColor = const Color(0xFF2b5876);

  const ColorConstants();
}
