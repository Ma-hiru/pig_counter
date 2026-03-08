import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/user.dart';

import '../../constants/routes.dart';
import 'dashboard_profile_card_avatar.dart';
import 'dashboard_profile_card_badge.dart';

class DashboardProfileCard extends StatefulWidget {
  final UserProfile profile;
  final bool isLoggedIn;

  const DashboardProfileCard({
    super.key,
    required this.profile,
    required this.isLoggedIn,
  });

  @override
  State<DashboardProfileCard> createState() => _DashboardProfileCardState();
}

class _DashboardProfileCardState extends State<DashboardProfileCard> {
  bool avatarLoadError = false;
  late final DashboardProfileCardAvatar DashboardAvatar =
      DashboardProfileCardAvatar(widget.profile);

  UserProfile get profile => widget.profile;

  bool get isLoggedIn => widget.isLoggedIn;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 6) return "夜深了";
    if (hour < 12) return "早上好";
    if (hour < 14) return "中午好";
    if (hour < 18) return "下午好";
    return "晚上好";
  }

  Widget buildGuestContent(BuildContext context) {
    return Row(
      children: [
        DashboardAvatar.GuestAvatar,
        SizedBox(width: UIConstants.gapSize.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RoutesPathConstants.login);
                },
                child: Text(
                  "点击登录",
                  style: TextStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontConstants.fontSize.md,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: UIConstants.gapSize.sm),
              Text(
                "登录后即可查看任务和统计数据",
                style: TextStyle(
                  fontSize: FontConstants.fontSize.xs,
                  fontFamily: FontConstants.fontFamily,
                  color: Colors.white.withAlpha(180),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLoggedInContent() {
    final badges = [
      if (profile.organization.isNotEmpty) ...[
        DashboardProfileCardBadge(profile.organization),
        SizedBox(width: UIConstants.gapSize.md),
      ],
      if (profile.admin) DashboardProfileCardBadge("管理员"),
    ];
    final avatar = (profile.profilePicture.isNotEmpty && !avatarLoadError)
        ? DashboardAvatar.LoggedAvatar
        : DashboardAvatar.BlankAvatar;

    return Row(
      children: [
        avatar,
        SizedBox(width: UIConstants.gapSize.xl),
        Expanded(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Text(
                "$greeting，${DashboardAvatar.displayName} !",
                style: TextStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontConstants.fontSize.md,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: UIConstants.gapSize.sm),
              Row(children: badges),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    DashboardAvatar.onTap = () {
      if (!isLoggedIn) Navigator.pushNamed(context, RoutesPathConstants.login);
    };
    DashboardAvatar.onAvatarLoadError = () {
      setState(() => avatarLoadError = true);
    };
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      alignment: .centerLeft,
      width: .infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorConstants.themeColor,
            ColorConstants.themeColor.withAlpha(200),
          ],
          begin: .topLeft,
          end: .bottomRight,
        ),
      ),
      padding: .symmetric(
        vertical: topPadding + UIConstants.gapSize.xxl,
        horizontal: UIConstants.contentPaddingFromSides,
      ),
      child: isLoggedIn ? buildLoggedInContent() : buildGuestContent(context),
    );
  }
}
