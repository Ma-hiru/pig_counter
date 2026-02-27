import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';

BottomNavigationBar getHomeTabBar({
  required int currentIndex,
  Function(int)? onTap,
}) {
  return BottomNavigationBar(
    type: .fixed,
    backgroundColor: Colors.white,
    enableFeedback: false,
    selectedItemColor: ColorConstants.themeColor,
    selectedFontSize: FontConstants.fontSize.md,
    unselectedItemColor: Colors.black,
    unselectedFontSize: FontConstants.fontSize.md,
    showUnselectedLabels: true,
    currentIndex: currentIndex,
    onTap: onTap,
    items: UIConstants.tabList
        .map(
          (tabData) => BottomNavigationBarItem(
            icon: tabData.icon,
            activeIcon: tabData.activeIcon,
            label: tabData.label,
          ),
        )
        .toList(),
  );
}
