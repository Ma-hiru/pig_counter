import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../constants/ui.dart';

AppBar NavigatorAppbar({required String title}) {
  return AppBar(
    toolbarHeight: UIConstants.uiSize.xxl,
    elevation: 1,
    shadowColor: Colors.grey.shade100,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    animateColor: true,
    title: Text(
      title,
      style: TextStyle(
        fontFamily: FontConstants.fontFamily,
        fontSize: FontConstants.fontSize.md,
        color: ColorConstants.themeColor,
        fontWeight: .w700,
      ),
      overflow: .fade,
    ),
    centerTitle: false,
  );
}
