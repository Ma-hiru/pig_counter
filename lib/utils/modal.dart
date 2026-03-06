import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';

import '../models/ui/modal.dart';

class AppModal {
  static void show(BuildContext context, ModalData data) {
    final controller = TextEditingController(text: data.initialValue);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UIConstants.borderRadius * 2),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: UIConstants.contentPaddingFromSides,
          right: UIConstants.contentPaddingFromSides,
          top: UIConstants.gapSize.xl,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + UIConstants.gapSize.xl,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 拖拽指示条
              Center(
                child: Container(
                  width: UIConstants.uiSize.xxl,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: UIConstants.gapSize.xl),
              // 标题
              Text(
                data.title,
                style: TextStyle(
                  fontSize: FontConstants.fontSize.lg,
                  fontFamily: FontConstants.fontFamily,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.defaultTextColor,
                ),
              ),
              if (data.description != null) ...[
                SizedBox(height: UIConstants.gapSize.sm),
                Text(
                  data.description!,
                  style: TextStyle(
                    fontSize: FontConstants.fontSize.xs,
                    fontFamily: FontConstants.fontFamily,
                    color: ColorConstants.secondaryTextColor,
                  ),
                ),
              ],
              SizedBox(height: UIConstants.gapSize.xl),
              // 输入框
              TextFormField(
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
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: UIConstants.gapSize.lg,
                    vertical: UIConstants.gapSize.lg,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      UIConstants.borderRadius,
                    ),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      UIConstants.borderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: ColorConstants.themeColor,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      UIConstants.borderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: ColorConstants.errorColor,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      UIConstants.borderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: ColorConstants.errorColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: UIConstants.gapSize.xl),
              // 按钮
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: UIConstants.uiSize.xxl,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              UIConstants.borderRadius,
                            ),
                          ),
                        ),
                        child: Text(
                          data.cancelText,
                          style: TextStyle(
                            fontSize: FontConstants.fontSize.sm,
                            fontFamily: FontConstants.fontFamily,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.secondaryTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: UIConstants.gapSize.lg),
                  Expanded(
                    child: SizedBox(
                      height: UIConstants.uiSize.xxl,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            Navigator.pop(ctx);
                            data.onConfirm?.call(controller.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.themeColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              UIConstants.borderRadius,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          data.confirmText,
                          style: TextStyle(
                            fontSize: FontConstants.fontSize.sm,
                            fontFamily: FontConstants.fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: UIConstants.gapSize.md),
            ],
          ),
        ),
      ),
    );
  }
}
