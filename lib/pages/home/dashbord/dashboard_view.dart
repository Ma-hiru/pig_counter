import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/user.dart';
import 'package:pig_counter/stores/user.dart';
import 'package:pig_counter/widgets/dashboard/dashboard_menu.dart';
import 'package:pig_counter/widgets/dashboard/dashboard_profile_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final UserController _userController = Get.find<UserController>();

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("退出登录"),
        content: const Text("确定要退出当前账号吗？"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _userController.updateUserProfile(UserProfile.empty());
              Navigator.pushNamed(context, "/login");
            },
            child: const Text(
              "退出",
              style: TextStyle(color: ColorConstants.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: CustomScrollView(
        slivers: [
          // 沉浸式头像区（无 AppBar，自带 status bar padding）
          SliverToBoxAdapter(
            child: Obx(
              () => DashboardProfileCard(
                profile: _userController.profile.value,
                onLoginTap: () => Navigator.pushNamed(context, "/login"),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: UIConstants.gapSize.xl)),

          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: UIConstants.contentPaddingFromSides,
            ),
            sliver: SliverList.list(
              children: [
                // ── 账户 ──────────────────────────────────
                DashboardMenuSection(
                  title: "账户",
                  items: [
                    DashboardMenuItem(
                      icon: LucideIcons.user_round_pen,
                      iconColor: ColorConstants.themeColor,
                      label: "编辑资料",
                      subtitle: "修改姓名、组织等信息",
                      onTap: () {},
                    ),
                    DashboardMenuItem(
                      icon: LucideIcons.lock_keyhole,
                      iconColor: const Color(0xFF7B5EA7),
                      label: "修改密码",
                      onTap: () {},
                    ),
                  ],
                ),

                SizedBox(height: UIConstants.gapSize.xl),

                // ── 功能 ──────────────────────────────────
                DashboardMenuSection(
                  title: "功能",
                  items: [
                    DashboardMenuItem(
                      icon: LucideIcons.history,
                      iconColor: const Color(0xFF2196F3),
                      label: "历史任务",
                      subtitle: "查看已完成或已归档的任务",
                      onTap: () {},
                    ),
                    DashboardMenuItem(
                      icon: LucideIcons.chart_bar,
                      iconColor: const Color(0xFFFF7043),
                      label: "数据导出",
                      subtitle: "将识别结果导出为表格",
                      onTap: () {},
                    ),
                  ],
                ),

                SizedBox(height: UIConstants.gapSize.xl),

                // ── 系统 ──────────────────────────────────
                DashboardMenuSection(
                  title: "系统",
                  items: [
                    DashboardMenuItem(
                      icon: LucideIcons.settings,
                      iconColor: Colors.grey.shade600,
                      label: "设置",
                      onTap: () {},
                    ),
                    DashboardMenuItem(
                      icon: LucideIcons.info,
                      iconColor: Colors.grey.shade600,
                      label: "关于",
                      subtitle: "版本信息与帮助文档",
                      onTap: () {},
                    ),
                    DashboardMenuItem(
                      icon: LucideIcons.log_out,
                      iconColor: ColorConstants.errorColor,
                      label: "退出登录",
                      destructive: true,
                      onTap: _logout,
                    ),
                  ],
                ),

                SizedBox(height: UIConstants.gapSize.xxxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
