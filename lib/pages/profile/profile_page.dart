import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/user.dart';
import 'package:pig_counter/stores/user.dart';
import 'package:pig_counter/widgets/header/navigator_app_bar.dart';
import 'package:pig_counter/widgets/settings/settings_menu_section.dart';
import 'package:pig_counter/widgets/settings/settings_menu_section_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController _userController = Get.find<UserController>();

  String displayOrDash(String value) {
    return value.isNotEmpty ? value : "-";
  }

  String get displayRole {
    if (_userController.profile.value.admin) return "管理员";
    return "普通用户";
  }

  String get displayLoginStatus {
    if (_userController.isLoggedIn.value) return "已登录";
    return "未登录";
  }

  Widget buildProfileHeader(UserProfile profile) {
    final displayName = profile.name.isNotEmpty
        ? profile.name
        : profile.username;
    return Container(
      width: .infinity,
      padding: .all(UIConstants.gapSize.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(UIConstants.borderRadius),
        border: .all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: UIConstants.uiSize.lg,
            backgroundColor: ColorConstants.themeColor.withAlpha(40),
            backgroundImage: profile.profilePicture.isNotEmpty
                ? NetworkImage(profile.profilePicture)
                : null,
            child: profile.profilePicture.isEmpty
                ? Text(
                    displayName.isNotEmpty ? displayName[0] : "?",
                    style: TextStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontConstants.fontSize.lg,
                      color: ColorConstants.themeColor,
                      fontWeight: .w700,
                    ),
                  )
                : null,
          ),
          SizedBox(width: UIConstants.gapSize.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  displayOrDash(displayName),
                  style: TextStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontConstants.fontSize.lg,
                    fontWeight: .w700,
                    color: ColorConstants.defaultTextColor,
                  ),
                ),
                SizedBox(height: UIConstants.gapSize.sm),
                Text(
                  displayOrDash(profile.organization),
                  style: TextStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontConstants.fontSize.xs,
                    color: ColorConstants.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SettingsMenuSectionItem buildReadonlyItem({
    required String label,
    required String value,
    String? subtitle,
  }) {
    return SettingsMenuSectionItem(
      label: label,
      subtitle: subtitle,
      value: displayOrDash(value),
      flat: true,
      flatColor: ColorConstants.defaultTextColor,
      onTap: () {},
    );
  }

  Widget buildContent(UserProfile profile) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        buildProfileHeader(profile),
        SizedBox(height: UIConstants.gapSize.xl),
        SettingsMenuSection(
          title: "基本信息",
          items: [
            buildReadonlyItem(label: "姓名", value: profile.name),
            buildReadonlyItem(label: "用户名", value: profile.username),
            buildReadonlyItem(label: "组织", value: profile.organization),
          ],
        ),
        SizedBox(height: UIConstants.gapSize.xl),
        SettingsMenuSection(
          title: "账号信息",
          items: [
            buildReadonlyItem(label: "账号ID", value: profile.id.toString()),
            buildReadonlyItem(label: "组织ID", value: profile.orgId.toString()),
            buildReadonlyItem(label: "角色", value: displayRole),
            buildReadonlyItem(
              label: "登录状态",
              value: displayLoginStatus,
              subtitle: "账号由管理员统一创建并分发",
            ),
          ],
        ),
        SizedBox(height: UIConstants.gapSize.xxxl),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigatorAppbar(title: "用户资料"),
      body: Container(
        width: .infinity,
        height: .infinity,
        color: ColorConstants.backgroundColor,
        child: SingleChildScrollView(
          padding: const .symmetric(
            horizontal: UIConstants.contentPaddingFromSides,
            vertical: UIConstants.contentPaddingFromSides,
          ),
          child: Obx(() => buildContent(_userController.profile.value)),
        ),
      ),
    );
  }
}
