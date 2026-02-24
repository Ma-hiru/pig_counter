import 'package:flutter/material.dart';
import 'package:pig_counter/constants/app.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';

class LoginLogo extends StatefulWidget {
  const LoginLogo({super.key});

  @override
  State<LoginLogo> createState() => _LoginLogoState();
}

class _LoginLogoState extends State<LoginLogo> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      alignment: .center,
      width: double.infinity,
      height: screenHeight * 0.4,
      child: Center(
        child: Text(
          APPConstants.appName,
          style: TextStyle(
            fontFamily: FontConstants.logoFontFamily,
            color: ColorConstants.themeColor,
            fontWeight: .bold,
            fontSize: FontConstants.fontSize.xxl,
          ),
        ),
      ),
    );
  }
}
