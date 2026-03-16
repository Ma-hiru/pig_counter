import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/models/routes/stats_route_param.dart';

import '../../constants/ui.dart';
import '../../widgets/header/navigator_app_bar.dart';
import '../../widgets/stats/stats_building_progress.dart';
import '../../widgets/stats/stats_overview.dart';
import '../../widgets/stats/stats_pen_table.dart';
import '../../widgets/stats/stats_task_meta.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  StatsRouteParam getRouteParam() {
    return ModalRoute.of(context)?.settings.arguments as StatsRouteParam? ??
        StatsRouteParam.empty();
  }

  Widget buildContent() {
    final routeParam = getRouteParam();
    final gap = SizedBox(height: UIConstants.gapSize.xl);
    Widget getItem(Widget child) {
      return Padding(
        padding: .symmetric(horizontal: UIConstants.contentPaddingFromSides),
        child: child,
      );
    }

    return ListView(
      children: [
        getItem(StatsTaskMeta(taskData: routeParam.task)),
        gap,
        getItem(StatsOverview(taskData: routeParam.task)),
        gap,
        getItem(StatsBuildingProgress(taskData: routeParam.task)),
        gap,
        getItem(StatsPenTable(taskData: routeParam.task)),
        gap,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeParam = getRouteParam();
    return Scaffold(
      appBar: NavigatorAppbar(title: "详细 ${routeParam.task.name}"),
      body: Container(
        width: .infinity,
        height: .infinity,
        color: ColorConstants.backgroundColor,
        padding: .only(top: UIConstants.gapSize.md),
        child: buildContent(),
      ),
    );
  }
}
