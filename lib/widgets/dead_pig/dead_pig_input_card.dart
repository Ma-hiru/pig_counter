import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/routes/upload_route_param.dart';
import 'package:pig_counter/widgets/button/button.dart';

class DeadPigInputCard extends StatelessWidget {
  final UploadRouteParam routeParam;
  final String today;
  final TextEditingController quantityController;
  final TextEditingController remarkController;
  final String selectedImagePath;
  final bool submitting;
  final VoidCallback onSelectImage;
  final VoidCallback onSubmit;

  const DeadPigInputCard({
    super.key,
    required this.routeParam,
    required this.today,
    required this.quantityController,
    required this.remarkController,
    required this.selectedImagePath,
    required this.submitting,
    required this.onSelectImage,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(UIConstants.gapSize.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "栏舍：${routeParam.pen.name}",
            style: TextStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.fontSize.sm,
              color: ColorConstants.defaultTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: UIConstants.gapSize.sm),
          Text(
            "上报日期：$today",
            style: TextStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.fontSize.xs,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
          SizedBox(height: UIConstants.gapSize.lg),
          TextField(
            controller: quantityController,
            keyboardType: const TextInputType.numberWithOptions(
              signed: false,
              decimal: false,
            ),
            decoration: InputDecoration(
              labelText: "死猪数量",
              hintText: "请输入大于 0 的整数",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(UIConstants.borderRadius),
              ),
            ),
          ),
          SizedBox(height: UIConstants.gapSize.md),
          TextField(
            controller: remarkController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: "备注（可选）",
              hintText: "可填写异常说明",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(UIConstants.borderRadius),
              ),
            ),
          ),
          SizedBox(height: UIConstants.gapSize.md),
          AppButton.normal(
            label: selectedImagePath.isEmpty ? "选择上报图片" : "重新选择上报图片",
            onPressed: onSelectImage,
          ),
          if (selectedImagePath.isNotEmpty) ...[
            SizedBox(height: UIConstants.gapSize.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(UIConstants.borderRadius),
              child: Image.file(
                File(selectedImagePath),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          SizedBox(height: UIConstants.gapSize.md),
          AppButton.normal(
            label: submitting ? "提交中..." : "提交死猪上报",
            filled: true,
            disabled: submitting,
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}
