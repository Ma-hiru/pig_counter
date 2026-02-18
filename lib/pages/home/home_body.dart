import 'package:flutter/material.dart';
import 'package:pig_counter/pages/home/dashbord/dashboard_view.dart';
import 'package:pig_counter/pages/home/stats/stats_view.dart';
import 'package:pig_counter/pages/home/task/task_view.dart';

Widget getHomeBody({required int currentIndex}) {
  return IndexedStack(
    index: currentIndex,
    children: [TaskView(), StatsView(), DashboardView()],
  );
}
