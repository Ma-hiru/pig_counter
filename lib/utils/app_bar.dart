import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../constants/font.dart';
import '../constants/ui.dart';

AppBar appTopBar(String title) {
  return AppBar(
    toolbarHeight: UIConstants.uiSize.xxl,
    iconTheme: IconThemeData(color: ColorConstants.themeColor),
    elevation: 1,
    shadowColor: Colors.grey.shade100,
    surfaceTintColor: ColorConstants.themeColor,
    backgroundColor: Colors.white,
    title: Text(
      title,
      style: TextStyle(
        fontFamily: FontConstants.fontFamily,
        fontSize: FontConstants.fontSize.md,
        color: ColorConstants.themeColor,
        fontWeight: .w700,
      ),
    ),
    centerTitle: false,
  );
}
