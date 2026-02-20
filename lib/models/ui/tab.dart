import 'package:flutter/material.dart';

class TabItem {
  final Icon icon;
  final Icon activeIcon;
  final String label;

  const TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
