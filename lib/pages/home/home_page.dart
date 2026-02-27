import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';

import 'home_body.dart';
import 'home_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorConstants.backgroundColor,
        child: getHomeBody(currentIndex: _currentTabIndex),
      ),
      bottomNavigationBar: getHomeTabBar(
        currentIndex: _currentTabIndex,
        onTap: (value) => setState(() => _currentTabIndex = value),
      ),
    );
  }
}
