import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';

class UploadResult extends StatelessWidget {
  final Pen pen;

  const UploadResult({super.key, required this.pen});

  int get totalCount => pen.displayCount;

  bool get canConfirm =>
      pen.outputPath.isNotEmpty ||
      (pen.uploadPath.isNotEmpty &&
          pen.processingStatus.toUpperCase() == "SUCCESS");

  String get statusText {
    if (pen.status) return "已确认";
    if (canConfirm) return "待确认";
    if (pen.isProcessing) return "处理中";
    if (pen.isFailed) return "处理失败";
    if (pen.localPath.isNotEmpty) return "待上传";
    return "未上传";
  }

  Color get statusColor {
    if (pen.status) return ColorConstants.successColor;
    if (canConfirm) return ColorConstants.themeColor;
    if (pen.isProcessing) return const Color(0xFF2196F3);
    if (pen.isFailed) return ColorConstants.errorColor;
    if (pen.localPath.isNotEmpty) return const Color(0xFFFF9800);
    return ColorConstants.secondaryTextColor;
  }

  Widget buildStatusTag() {
    return Container(
      padding: .symmetric(
        horizontal: UIConstants.gapSize.md,
        vertical: UIConstants.gapSize.xs,
      ),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(24),
        borderRadius: .circular(UIConstants.borderRadius * 2),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontConstants.fontSize.xs,
          fontWeight: .w600,
          color: statusColor,
        ),
      ),
    );
  }

  Widget buildStatCard({
    required IconData icon,
    required Color color,
    required String label,
    required int value,
  }) {
    return Container(
      padding: .all(UIConstants.gapSize.md),
      decoration: BoxDecoration(
        color: color.withAlpha(12),
        borderRadius: .circular(UIConstants.borderRadius),
        border: .all(color: color.withAlpha(32)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          Icon(icon, size: UIConstants.uiSize.md, color: color),
          SizedBox(height: UIConstants.gapSize.sm),
          Text(
            value.toString(),
            maxLines: 1,
            overflow: .ellipsis,
            style: TextStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.fontSize.lg,
              fontWeight: .w700,
              color: color,
            ),
          ),
          SizedBox(height: UIConstants.gapSize.xs),
          Text(
            label,
            maxLines: 1,
            overflow: .ellipsis,
            style: TextStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.fontSize.xs,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSummary() {
    return Row(
      crossAxisAlignment: .center,
      children: [
        Icon(
          LucideIcons.circle_check_big,
          size: UIConstants.uiSize.md,
          color: statusColor,
        ),
        SizedBox(width: UIConstants.gapSize.sm),
        Text(
          "当前统计合计",
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontConstants.fontSize.sm,
            fontWeight: .w500,
            color: ColorConstants.secondaryTextColor,
          ),
        ),
        const Spacer(),
        Text(
          "$totalCount 头",
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontConstants.fontSize.sm,
            fontWeight: .w700,
            color: statusColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .all(UIConstants.gapSize.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(UIConstants.borderRadius),
        border: .all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.chart_no_axes_column,
                size: UIConstants.uiSize.md,
                color: ColorConstants.themeColor,
              ),
              SizedBox(width: UIConstants.gapSize.sm),
              Text(
                "上传结果",
                style: TextStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontConstants.fontSize.sm,
                  fontWeight: .w700,
                  color: ColorConstants.defaultTextColor,
                ),
              ),
              const Spacer(),
              buildStatusTag(),
            ],
          ),
          SizedBox(height: UIConstants.gapSize.lg),
          Row(
            children: [
              Expanded(
                child: buildStatCard(
                  icon: LucideIcons.cpu,
                  color: const Color(0xFF2196F3),
                  label: "AI识别",
                  value: pen.aiCount,
                ),
              ),
              SizedBox(width: UIConstants.gapSize.md),
              Expanded(
                child: buildStatCard(
                  icon: LucideIcons.user_round_check,
                  color: const Color(0xFFFF7043),
                  label: "人工确认",
                  value: pen.manualCount,
                ),
              ),
              SizedBox(width: UIConstants.gapSize.md),
              Expanded(
                child: buildStatCard(
                  icon: LucideIcons.circle_equal,
                  color: ColorConstants.themeColor,
                  label: "总计",
                  value: totalCount,
                ),
              ),
            ],
          ),
          SizedBox(height: UIConstants.gapSize.lg),
          buildSummary(),
        ],
      ),
    );
  }
}
