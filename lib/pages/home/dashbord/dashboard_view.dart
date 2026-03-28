import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/routes.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/stores/user.dart';
import 'package:pig_counter/widgets/dashboard/dashboard_menu_section_item.dart';
import 'package:pig_counter/widgets/dashboard/dashboard_profile_card.dart';

import '../../../widgets/dashboard/dashboard_menu_section.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final UserController _userController = Get.find<UserController>();

  Widget buildProfileCard() {
    return DashboardProfileCard(
      profile: _userController.profile.value,
      isLoggedIn: _userController.isLoggedIn.value,
    );
  }

  List<Widget> buildItems() {
    return [
      DashboardMenuSection(
        title: "账户",
        items: [
          DashboardMenuSectionItem(
            icon: LucideIcons.user_round,
            iconColor: ColorConstants.themeColor,
            label: "查看用户资料",
            subtitle: "账号由管理员下发，仅支持查看",
            onTap: () {
              Navigator.pushNamed(context, RoutesPathConstants.profile);
            },
          ),
        ],
      ),
      SizedBox(height: UIConstants.gapSize.xl),
      DashboardMenuSection(
        title: "功能",
        items: [
          DashboardMenuSectionItem(
            icon: LucideIcons.history,
            iconColor: const Color(0xFF2196F3),
            label: "历史任务",
            subtitle: "查看已归档的任务",
            onTap: () {
              Navigator.pushNamed(context, RoutesPathConstants.history);
            },
          ),
        ],
      ),
      SizedBox(height: UIConstants.gapSize.xl),
      Obx(
        () => DashboardMenuSection(
          title: "系统",
          items: [
            DashboardMenuSectionItem(
              icon: LucideIcons.settings,
              iconColor: Colors.grey.shade600,
              label: "设置",
              onTap: () {
                Navigator.pushNamed(context, RoutesPathConstants.settings);
              },
            ),
            if (_userController.isLoggedIn.value)
              DashboardMenuSectionItem(
                icon: LucideIcons.log_out,
                iconColor: ColorConstants.errorColor,
                label: "退出登录",
                flat: true,
                onTap: () => _userController.logout(context),
              ),
          ],
        ),
      ),
      SizedBox(height: UIConstants.gapSize.xxxl),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: .light,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Obx(() => buildProfileCard())),
          SliverToBoxAdapter(child: SizedBox(height: UIConstants.gapSize.xl)),
          SliverPadding(
            padding: const .symmetric(
              horizontal: UIConstants.contentPaddingFromSides,
            ),
            sliver: SliverList.list(children: buildItems()),
          ),
        ],
      ),
    );
  }
}
