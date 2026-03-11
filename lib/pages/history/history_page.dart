import 'package:flutter/material.dart';
import 'package:pig_counter/constants/routes.dart';
import 'package:pig_counter/models/routes/stats_route_param.dart';
import 'package:pig_counter/widgets/tips/tips.dart';

import '../../constants/color.dart';
import '../../constants/ui.dart';
import '../../models/api/task.dart';
import '../../widgets/form/outline_input.dart';
import '../../widgets/header/navigator_app_bar.dart';
import '../../widgets/task/task_intro.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final indicatorKey = GlobalKey<RefreshIndicatorState>();
  final searchController = TextEditingController();
  List<Task> _taskList = [];

  Future refreshTaskData() async {
    setState(() {
      _taskList = List.generate(10, Task.test);
    });
  }

  Widget buildBlank() {
    return Center(
      child: GestureDetector(
        onTap: () => indicatorKey.currentState?.show(),
        child: AppTips.icon(text: "暂无数据，点击刷新", type: .refresh),
      ),
    );
  }

  void search(String keyword) {}

  Widget buildSearchInput() {
    return Padding(
      padding: .only(
        left: UIConstants.contentPaddingFromSides,
        right: UIConstants.contentPaddingFromSides,
        top: UIConstants.gapSize.md,
      ),
      child: OutlineFormInput(
        hitText: '输入关键词',
        controller: searchController,
        onChanged: search,
      ),
    );
  }

  Widget buildContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: buildSearchInput()),
        SliverPadding(
          padding: .symmetric(
            horizontal: UIConstants.contentPaddingFromSides,
            vertical: UIConstants.gapSize.md,
          ),
          sliver: SliverList.builder(
            itemCount: _taskList.length,
            itemBuilder: (ctx, index) => TaskIntro(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutesPathConstants.stats,
                  arguments: StatsRouteParam(_taskList[index]),
                );
              },
              taskData: _taskList[index],
              disableDetail: true,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    refreshTaskData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigatorAppbar(title: "历史"),
      body: RefreshIndicator(
        key: indicatorKey,
        onRefresh: refreshTaskData,
        color: ColorConstants.themeColor,
        backgroundColor: Colors.white,
        child: _taskList.isNotEmpty ? buildContent() : buildBlank(),
      ),
    );
  }
}
