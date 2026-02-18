import 'package:flutter/material.dart';
import 'package:pig_counter/constants/ui.dart';

BottomNavigationBar getHomeTabBar({
  required int currentIndex,
  Function(int)? onTap,
}) {
  return BottomNavigationBar(
    items: UIConstants.tabList
        .map(
          (tabData) => BottomNavigationBarItem(
            icon: Image.asset(tabData.icon, width: 25, height: 25),
            activeIcon: Image.asset(tabData.activeIcon, width: 25, height: 25),
            label: tabData.label,
          ),
        )
        .toList(),
    enableFeedback: false,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black,
    showUnselectedLabels: true,
    currentIndex: currentIndex,
    onTap: onTap,
  );
}
