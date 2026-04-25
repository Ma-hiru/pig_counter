import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/dead_pig.dart';

class DeadPigReportItem extends StatelessWidget {
  final DeadPigReport report;

  const DeadPigReportItem({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final firstImage = report.mediaList.isNotEmpty
        ? report.mediaList.first.picturePath
        : "";
    return Container(
      padding: EdgeInsets.all(UIConstants.gapSize.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "上报单 #${report.reportId}",
                style: TextStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontConstants.fontSize.sm,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.defaultTextColor,
                ),
              ),
              const Spacer(),
              Text(
                "${report.quantity} 头",
                style: TextStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontConstants.fontSize.sm,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.errorColor,
                ),
              ),
            ],
          ),
          SizedBox(height: UIConstants.gapSize.xs),
          Text(
            "创建时间：${report.createdAt.isEmpty ? "-" : report.createdAt}",
            style: TextStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.fontSize.xs,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
          SizedBox(height: UIConstants.gapSize.xs),
          Text(
            "备注：${report.remark.isEmpty ? "-" : report.remark}",
            style: TextStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.fontSize.xs,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
          if (firstImage.isNotEmpty) ...[
            SizedBox(height: UIConstants.gapSize.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(UIConstants.borderRadius),
              child: Image.network(
                firstImage,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 120,
                  alignment: Alignment.center,
                  color: Colors.grey.shade100,
                  child: Text(
                    "图片加载失败",
                    style: TextStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorConstants.secondaryTextColor,
                      fontSize: FontConstants.fontSize.xs,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
