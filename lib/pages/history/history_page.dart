import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pig_counter/constants/err.dart';
import 'package:pig_counter/constants/routes.dart';
import 'package:pig_counter/models/routes/stats_route_param.dart';
import 'package:pig_counter/stores/user.dart';
import 'package:pig_counter/utils/task_fetcher.dart';
import 'package:pig_counter/utils/toast.dart';
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
  final UserController _userController = Get.find<UserController>();

  Worker? _loginWorker;
  List<Task> _allTaskList = [];
  List<Task> _taskList = [];

  Future refreshTaskData() async {
    if (!_userController.isLoggedIn.value ||
        _userController.profile.value.id <= 0) {
      if (!mounted) return;
      return setState(() {
        _allTaskList = [];
        _taskList = [];
      });
    }

    try {
      final tasks = await fetchEmployeeTasksWithDetails(
        _userController.profile.value.id,
      );
      final historyTasks = tasks
          .where((task) => task.completed || task.outdate)
          .toList();
      if (!mounted) return;
      setState(() {
        _allTaskList = historyTasks;
        _taskList = historyTasks;
      });
    } on StateError catch (err) {
      Toast.showToast(.error(err.message));
    } catch (err) {
      if (err == ErrConstants.responseFormatError) {
        Toast.showToast(.error(ErrMsgConstants.responseFormatError));
      } else {
        Toast.showToast(.error(ErrMsgConstants.networkError));
      }
    }
  }

  Widget buildBlank() {
    final isLoggedIn = _userController.isLoggedIn.value;
    return Center(
      child: GestureDetector(
        onTap: () => indicatorKey.currentState?.show(),
        child: AppTips.icon(
          text: isLoggedIn ? "暂无历史任务，点击刷新" : "请先登录后查看历史",
          type: .refresh,
        ),
      ),
    );
  }

  void search(String keyword) {
    final normalized = keyword.trim().toLowerCase();
    setState(() {
      if (normalized.isEmpty) {
        _taskList = _allTaskList;
      } else {
        _taskList = _allTaskList.where((task) {
          return task.name.toLowerCase().contains(normalized) ||
              task.id.toString().contains(normalized);
        }).toList();
      }
    });
  }

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
    _loginWorker = ever<bool>(_userController.isLoggedIn, (_) {
      refreshTaskData();
    });
    refreshTaskData();
  }

  @override
  void dispose() {
    _loginWorker?.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigatorAppbar(title: "历史"),
      body: Container(
        width: .infinity,
        height: .infinity,
        color: ColorConstants.backgroundColor,
        child: RefreshIndicator(
          key: indicatorKey,
          onRefresh: refreshTaskData,
          color: ColorConstants.themeColor,
          backgroundColor: Colors.white,
          child: _taskList.isNotEmpty ? buildContent() : buildBlank(),
        ),
      ),
    );
  }
}
