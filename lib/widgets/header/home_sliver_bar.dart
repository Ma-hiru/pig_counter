import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../constants/ui.dart';

class HomeSliverBar extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool? disableSliver;

  const HomeSliverBar({
    super.key,
    required this.title,
    required this.subTitle,
    this.disableSliver,
  });

  @override
  Widget build(BuildContext context) {
    if (disableSliver == true) {
      return AppBar(
        shadowColor: Colors.grey.shade100,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        toolbarHeight:
            FontConstants.fontSize.lg +
            FontConstants.fontSize.sm +
            UIConstants.gapSize.md,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontConstants.fontSize.md * 1.1,
            color: ColorConstants.themeColor,
            fontWeight: .w700,
            height: 1,
          ),
        ),
      );
    }
    return SliverAppBar(
      pinned: true,
      shadowColor: Colors.grey.shade100,
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      toolbarHeight:
          FontConstants.fontSize.lg +
          FontConstants.fontSize.sm +
          UIConstants.gapSize.md,
      expandedHeight:
          FontConstants.fontSize.lg +
          FontConstants.fontSize.sm +
          UIConstants.gapSize.xl,
      collapsedHeight:
          FontConstants.fontSize.lg +
          FontConstants.fontSize.sm +
          UIConstants.gapSize.md,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontConstants.fontSize.md * 1.1,
          color: ColorConstants.themeColor,
          fontWeight: .w700,
          height: 1,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: .fromHeight(0),
        child: Padding(
          padding: .only(bottom: UIConstants.gapSize.sm),
          child: Text(
            subTitle,
            style: TextStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.fontSize.sm * 0.7,
              color: ColorConstants.defaultTextColor,
              fontWeight: .normal,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
