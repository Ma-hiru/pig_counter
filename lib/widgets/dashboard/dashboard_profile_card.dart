import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/user.dart';

/// 沉浸式头部卡片，无圆角、无外边距，自适应状态栏高度。
/// 未登录（token 为空）时显示引导登录区域。
class DashboardProfileCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onLoginTap;

  const DashboardProfileCard({
    super.key,
    required this.profile,
    this.onLoginTap,
  });

  bool get _isLoggedIn => profile.token.isNotEmpty;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 6) return "夜深了";
    if (hour < 12) return "早上好";
    if (hour < 14) return "中午好";
    if (hour < 18) return "下午好";
    return "晚上好";
  }

  String get _displayName =>
      profile.name.isNotEmpty ? profile.name : profile.username;

  String get _avatarText {
    if (profile.name.isNotEmpty) return profile.name.characters.first;
    if (profile.username.isNotEmpty) {
      return profile.username.characters.first.toUpperCase();
    }
    return "?";
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorConstants.themeColor, Color(0xFF4A8DA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        UIConstants.contentPaddingFromSides,
        topPadding + UIConstants.gapSize.xl,
        UIConstants.contentPaddingFromSides,
        UIConstants.gapSize.xxxl,
      ),
      child: _isLoggedIn ? _LoggedInContent(
        avatarText: _avatarText,
        greeting: _greeting,
        displayName: _displayName,
        profile: profile,
      ) : _GuestContent(onLoginTap: onLoginTap),
    );
  }
}

// ── 已登录内容 ────────────────────────────────────────────────
class _LoggedInContent extends StatelessWidget {
  final String avatarText;
  final String greeting;
  final String displayName;
  final UserProfile profile;

  const _LoggedInContent({
    required this.avatarText,
    required this.greeting,
    required this.displayName,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(40),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withAlpha(80), width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            avatarText,
            style: TextStyle(
              fontSize: FontConstants.fontSize.xl,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: UIConstants.gapSize.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$greeting，$displayName",
                style: TextStyle(
                  fontSize: FontConstants.fontSize.md,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              SizedBox(height: UIConstants.gapSize.sm),
              Row(
                children: [
                  if (profile.organization.isNotEmpty) ...[
                    _Badge(label: profile.organization),
                    SizedBox(width: UIConstants.gapSize.md),
                  ],
                  if (profile.admin) _Badge(label: "管理员"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── 未登录内容 ────────────────────────────────────────────────
class _GuestContent extends StatelessWidget {
  final VoidCallback? onLoginTap;

  const _GuestContent({this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(30),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withAlpha(60), width: 2),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.person_outline,
            size: 28,
            color: Colors.white.withAlpha(200),
          ),
        ),
        SizedBox(width: UIConstants.gapSize.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "您尚未登录",
                style: TextStyle(
                  fontSize: FontConstants.fontSize.md,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              SizedBox(height: UIConstants.gapSize.sm),
              Text(
                "登录后即可查看任务和统计数据",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withAlpha(180),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onLoginTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: UIConstants.gapSize.lg,
              vertical: UIConstants.gapSize.md,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withAlpha(100)),
            ),
            child: const Text(
              "去登录",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

