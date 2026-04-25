import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/err.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/stores/user.dart';
import 'package:pig_counter/utils/task_fetcher.dart';
import 'package:pig_counter/utils/toast.dart';
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
  final UserController _userController = Get.find<UserController>();

  List<Task> _taskList = [];
  Worker? _loginWorker;

  Future refreshTaskData() async {
    if (!_userController.isLoggedIn.value ||
        _userController.profile.value.id <= 0) {
      if (!mounted) return;
      return setState(() {
        _taskList = [];
      });
    }

    try {
      final tasks = await fetchEmployeeTasksWithDetails(
        _userController.profile.value.id,
      );
      if (!mounted) return;
      setState(() {
        _taskList = tasks;
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
    super.dispose();
  }

  Widget buildBlank() {
    final isLoggedIn = _userController.isLoggedIn.value;
    return Column(
      children: [
        HomeSliverBar(title: "任务列表", subTitle: "", disableSliver: true),
        Expanded(
          child: GestureDetector(
            onTap: () => indicatorKey.currentState?.show(),
            child: AppTips.icon(
              text: isLoggedIn ? "暂无任务，点击刷新" : "请先登录后查看任务",
              type: .refresh,
            ),
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
      itemBuilder: (ctx, index) =>
          TaskIntro(taskData: _taskList[index], onTaskUpdated: refreshTaskData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
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
                    child: SizedBox(
                      height: UIConstants.contentPaddingFromSides,
                    ),
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
      ),
    );
  }
}
