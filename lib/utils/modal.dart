import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/widgets/button/button.dart';

import '../models/ui/modal.dart';

class AppModal {
  static Widget _buildIndicator() {
    return Center(
      child: Container(
        width: UIConstants.uiSize.xxl,
        height: UIConstants.uiSize.xs,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: .circular(UIConstants.uiSize.xs / 2),
        ),
      ),
    );
  }

  static Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: FontConstants.fontSize.md,
        fontFamily: FontConstants.fontFamily,
        fontWeight: FontWeight.w600,
        color: ColorConstants.defaultTextColor,
      ),
      overflow: .ellipsis,
    );
  }

  static Widget _buildDescription(String desc) {
    return Text(
      desc,
      style: TextStyle(
        fontSize: FontConstants.fontSize.xs,
        fontFamily: FontConstants.fontFamily,
        color: ColorConstants.secondaryTextColor,
      ),
    );
  }

  static Widget _buildInput({
    required ModalData data,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: data.keyboardType,
      validator: data.validator,
      autofocus: true,
      style: TextStyle(
        fontSize: FontConstants.fontSize.md,
        fontFamily: FontConstants.fontFamily,
        color: ColorConstants.defaultTextColor,
      ),
      decoration: InputDecoration(
        hintText: data.hintText,
        hintStyle: TextStyle(
          fontSize: FontConstants.fontSize.sm,
          fontFamily: FontConstants.fontFamily,
          color: ColorConstants.secondaryTextColor.withAlpha(
            (255 * 0.5).toInt(),
          ),
        ),
        contentPadding: .symmetric(
          horizontal: UIConstants.gapSize.lg,
          vertical: UIConstants.gapSize.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: .circular(UIConstants.borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: .circular(UIConstants.borderRadius),
          borderSide: BorderSide(
            color: ColorConstants.themeColor,
            width: UIConstants.gapSize.xs,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: .circular(UIConstants.borderRadius),
          borderSide: const BorderSide(color: ColorConstants.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: .circular(UIConstants.borderRadius),
          borderSide: BorderSide(
            color: ColorConstants.errorColor,
            width: UIConstants.gapSize.xs,
          ),
        ),
      ),
    );
  }

  static List<Widget> _buildButton({
    required BuildContext ctx,
    required ModalData data,
    required TextEditingController controller,
    required GlobalKey<FormState> formKey,
  }) {
    final height = UIConstants.uiSize.xxl;
    final cancel = SizedBox(
      height: height,
      child: AppButton.normal(
        label: data.cancelText,
        color: data.cancelColor,
        onPressed: () {
          Navigator.pop(ctx);
          data.onCancel?.call();
        },
      ),
    );
    final confirm = SizedBox(
      height: height,
      child: AppButton.normal(
        label: data.confirmText,
        color: data.confirmColor,
        filled: true,
        onPressed: () {
          if (data.hideInput == true ||
              (formKey.currentState?.validate() ?? false)) {
            Navigator.pop(ctx);
            data.onConfirm?.call(controller.text);
          }
        },
      ),
    );
    return [Expanded(child: cancel), Expanded(child: confirm)];
  }

  static void show(BuildContext context, ModalData data) {
    final controller = TextEditingController(text: data.initialValue);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(UIConstants.borderRadius)),
      ),
      builder: (ctx) => Padding(
        padding: .only(
          left: UIConstants.contentPaddingFromSides,
          right: UIConstants.contentPaddingFromSides,
          top: UIConstants.gapSize.md,
          bottom:
              MediaQuery.of(ctx).viewInsets.bottom +
              MediaQuery.of(ctx).padding.bottom +
              UIConstants.gapSize.md,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              // 拖拽指示条
              if (data.showIndicator == true) _buildIndicator(),
              SizedBox(height: UIConstants.gapSize.xl),
              // 标题
              _buildTitle(data.title),
              // 描述
              if (data.description != null) ...[
                SizedBox(height: UIConstants.gapSize.sm),
                _buildDescription(data.description!),
              ],
              // 输入框
              if (data.hideInput != true) ...[
                SizedBox(height: UIConstants.gapSize.xl),
                _buildInput(data: data, controller: controller),
              ],
              SizedBox(height: UIConstants.gapSize.xl),
              // 按钮
              Row(
                spacing: UIConstants.gapSize.lg,
                children: _buildButton(
                  ctx: ctx,
                  data: data,
                  controller: controller,
                  formKey: formKey,
                ),
              ),
              SizedBox(height: UIConstants.gapSize.md),
            ],
          ),
        ),
      ),
    );
  }
}
