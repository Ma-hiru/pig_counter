import 'package:flutter/material.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../constants/ui.dart';
import '../../../models/api/task.dart';
import '../../../widgets/header/home_sliver_bar.dart';
import '../../../widgets/stats/stats_building_progress.dart';
import '../../../widgets/stats/stats_overview.dart';
import '../../../widgets/stats/stats_pen_table.dart';
import '../../../widgets/stats/stats_task_meta.dart';
import '../../../widgets/stats/stats_task_selector.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  List<Task> _taskList = [];
  int _selectedIndex = 0;

  Task? get _selected => _taskList.isEmpty ? null : _taskList[_selectedIndex];

  Future<void> _refresh() async {
    setState(() {
      _taskList = List.generate(10, Task.test);
      _selectedIndex = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  List<Widget> _buildSlivers() {
    final task = _selected;
    if (task == null) {
      return [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 200,
            child: Center(
              child: Text(
                "暂无任务数据",
                style: TextStyle(
                  color: ColorConstants.secondaryTextColor,
                  fontSize: FontConstants.fontSize.sm,
                ),
              ),
            ),
          ),
        ),
      ];
    }
    return [
      SliverToBoxAdapter(
        child: StatsTaskSelector(
          taskList: _taskList,
          selectedIndex: _selectedIndex,
          onSelect: (i) => setState(() => _selectedIndex = i),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: UIConstants.gapSize.xl)),
      SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: UIConstants.contentPaddingFromSides,
        ),
        sliver: SliverList.list(
          children: [
            StatsTaskMeta(taskData: task),
            SizedBox(height: UIConstants.gapSize.xl),
            StatsOverview(taskData: task),
            SizedBox(height: UIConstants.gapSize.xl),
            StatsBuildingProgress(taskData: task),
            SizedBox(height: UIConstants.gapSize.xl),
            StatsPenTable(taskData: task),
            SizedBox(height: UIConstants.gapSize.xxxl),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      color: ColorConstants.themeColor,
      backgroundColor: Colors.white,
      child: CustomScrollView(
        slivers: [
          HomeSliverBar(title: "任务统计", subTitle: "共 ${_taskList.length} 个任务"),
          SliverToBoxAdapter(child: SizedBox(height: UIConstants.gapSize.lg)),
          ..._buildSlivers(),
        ],
      ),
    );
  }
}
