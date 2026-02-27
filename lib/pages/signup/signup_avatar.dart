import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pig_counter/constants/app.dart';
import 'package:pig_counter/constants/err.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/utils/toast.dart';

class SignupAvatar extends StatefulWidget {
  final void Function(File avatar)? onChange;

  const SignupAvatar({super.key, this.onChange});

  @override
  State<SignupAvatar> createState() => _SignupAvatarState();
}

class _SignupAvatarState extends State<SignupAvatar> {
  File? source;
  final ImagePicker picker = ImagePicker();

  void selectAvatar() async {
    try {
      final XFile? picked = await picker.pickImage(
        source: .gallery,
        imageQuality: APPConstants.avatarUploadQuality,
      );
      if (picked != null) {
        source = File(picked.path);
        if (widget.onChange != null) {
          widget.onChange!(source!);
        }
        setState(() {});
      }
    } catch (err) {
      if (kDebugMode) print("Failed to pick image: $err");
      Toast.showToast(.error(ErrMsgConstants.selectImageFailed));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(vertical: UIConstants.gapSize.xxl),
      alignment: .center,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade300,
            width: UIConstants.gapSize.xs,
          ),
        ),
        child: GestureDetector(
          onTap: selectAvatar,
          child: Stack(
            children: [
              CircleAvatar(
                radius: UIConstants.uiSize.xl,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: source != null ? FileImage(source!) : null,
                child: source == null
                    ? Icon(
                        Icons.person,
                        size: UIConstants.uiSize.xxl,
                        color: Colors.grey.shade400,
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ColorConstants.themeColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
