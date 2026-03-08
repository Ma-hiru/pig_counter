import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';

import '../../constants/font.dart';
import '../../constants/ui.dart';
import '../../models/api/user.dart';

class DashboardProfileCardAvatar {
  final UserProfile profile;
  VoidCallback? onTap;
  VoidCallback? onAvatarLoadError;

  String get displayName {
    if (profile.name.isNotEmpty) {
      return profile.name;
    }
    return profile.username;
  }

  DashboardProfileCardAvatar(this.profile);

  Widget get GuestAvatar {
    return Container(
      alignment: .center,
      width: UIConstants.uiSize.xxxl,
      height: UIConstants.uiSize.xxxl,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: .circular(UIConstants.uiSize.xxxl / 2),
        border: .all(color: Colors.white.withAlpha(60), width: 2),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          Icons.person_outline,
          size: UIConstants.uiSize.xl,
          color: Colors.white.withAlpha(200),
        ),
      ),
    );
  }

  Widget get BlankAvatar {
    return Container(
      alignment: .center,
      width: UIConstants.uiSize.xxxl,
      height: UIConstants.uiSize.xxxl,
      decoration: BoxDecoration(
        shape: .circle,
        color: Colors.white.withAlpha(40),
        border: .all(color: Colors.white.withAlpha(80), width: 2),
      ),
      child: Text(
        displayName.isNotEmpty ? displayName[0] : "?",
        style: TextStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontConstants.fontSize.xl,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget get LoggedAvatar {
    if (profile.profilePicture.isNotEmpty) {
      return Container(
        width: UIConstants.uiSize.xxxl,
        height: UIConstants.uiSize.xxxl,
        decoration: BoxDecoration(
          shape: .circle,
          border: Border.all(color: Colors.white.withAlpha(80), width: 2),
        ),
        child: CircleAvatar(
          backgroundImage: NetworkImage(profile.profilePicture),
          backgroundColor: ColorConstants.themeColor,
          onBackgroundImageError: (_, _) => onAvatarLoadError?.call(),
        ),
      );
    }
    return BlankAvatar;
  }
}
