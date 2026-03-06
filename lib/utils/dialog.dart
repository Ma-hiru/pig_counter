import 'package:awesome_dialog/awesome_dialog.dart' as ad;
import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';

import '../models/ui/dialog.dart';

class AppDialog {
  static void show(BuildContext context, DialogData data) {
    ad.AwesomeDialog(
      context: context,
      dialogType: .noHeader,
      title: data.title,
      desc: data.description,
      btnCancelText: data.cancelText,
      btnOkText: data.confirmText,
      btnCancelColor: ColorConstants.secondaryTextColor,
      btnOkColor: data.confirmButtonColor,
      titleTextStyle: TextStyle(
        fontSize: FontConstants.fontSize.md,
        fontFamily: FontConstants.fontFamily,
        fontWeight: FontWeight.w600,
        color: ColorConstants.defaultTextColor,
      ),
      descTextStyle: TextStyle(
        fontSize: FontConstants.fontSize.sm,
        fontFamily: FontConstants.fontFamily,
        color: ColorConstants.secondaryTextColor,
      ),
      buttonsTextStyle: TextStyle(
        fontSize: FontConstants.fontSize.sm,
        fontFamily: FontConstants.fontFamily,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      buttonsBorderRadius: .circular(UIConstants.borderRadius),
      btnCancelOnPress: data.onCancel ?? () {},
      btnOkOnPress: data.onConfirm ?? () {},
    ).show();
  }
}
