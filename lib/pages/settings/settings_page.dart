import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../constants/ui.dart';
import '../../widgets/header/navigator_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigatorAppbar(title: "设置"),
      body: Container(
        width: double.infinity,
        color: ColorConstants.backgroundColor,
        padding: const .symmetric(
          horizontal: UIConstants.contentPaddingFromSides,
        ),
        child: Column(
          mainAxisAlignment: .start,
          children: [
            SizedBox(),
            SizedBox()
          ],
        ),
      ),
    );
  }
}
