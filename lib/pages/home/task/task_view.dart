import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/widgets/task/task_intro.dart';
import 'package:pig_counter/widgets/tips/tips.dart';

import '../../../widgets/header/home_sliver_bar.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final indicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Task> _taskList = [];

  Future refreshTaskData() async {
    setState(() {
      _taskList = List.generate(10, Task.test);
    });
  }

  @override
  void initState() {
    super.initState();
    refreshTaskData();
  }

  Widget buildBlank() {
    return Column(
      children: [
        HomeSliverBar(title: "任务列表", subTitle: "", disableSliver: true),
        Expanded(
          child: GestureDetector(
            onTap: () => indicatorKey.currentState?.show(),
            child: AppTips.icon(text: "暂无数据，点击刷新", type: .refresh),
          ),
        ),
      ],
    );
  }

  Widget buildContent() {
    if (_taskList.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 200,
          alignment: Alignment.center,
          child: Text("暂无数据"),
        ),
      );
    }
    return SliverList.builder(
      itemCount: _taskList.length,
      itemBuilder: (ctx, index) => TaskIntro(taskData: _taskList[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: indicatorKey,
      onRefresh: refreshTaskData,
      color: ColorConstants.themeColor,
      backgroundColor: Colors.white,
      child: _taskList.isNotEmpty
          ? CustomScrollView(
              slivers: [
                HomeSliverBar(
                  title: "任务列表",
                  subTitle: "共 ${_taskList.length} 个任务",
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: UIConstants.contentPaddingFromSides),
                ),
                SliverPadding(
                  padding: .symmetric(
                    horizontal: UIConstants.contentPaddingFromSides,
                  ),
                  sliver: buildContent(),
                ),
              ],
            )
          : buildBlank(),
    );
  }
}
