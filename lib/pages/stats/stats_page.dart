import 'package:flutter/material.dart';
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
    return ListView(
      children: [
        Padding(
          padding: .symmetric(horizontal: UIConstants.contentPaddingFromSides),
          child: StatsTaskMeta(taskData: routeParam.task),
        ),
        SizedBox(height: UIConstants.gapSize.xl),
        Padding(
          padding: .symmetric(horizontal: UIConstants.contentPaddingFromSides),
          child: StatsOverview(taskData: routeParam.task),
        ),
        SizedBox(height: UIConstants.gapSize.xl),
        Padding(
          padding: .symmetric(horizontal: UIConstants.contentPaddingFromSides),
          child: StatsBuildingProgress(taskData: routeParam.task),
        ),
        SizedBox(height: UIConstants.gapSize.xl),
        Padding(
          padding: .symmetric(horizontal: UIConstants.contentPaddingFromSides),
          child: StatsPenTable(taskData: routeParam.task),
        ),
        SizedBox(height: UIConstants.gapSize.xxxl),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeParam = getRouteParam();
    return Scaffold(
      appBar: NavigatorAppbar(title: "详细 ${routeParam.task.name}"),
      body: Padding(
        padding: .only(top: UIConstants.gapSize.md),
        child: buildContent(),
      ),
    );
  }
}
