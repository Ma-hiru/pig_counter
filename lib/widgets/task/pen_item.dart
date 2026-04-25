import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../constants/ui.dart';
import '../../models/api/task.dart';

class PenItem extends StatelessWidget {
  final Pen pen;
  final bool isLast;
  final void Function(Pen pen)? onTap;
  final void Function(Pen pen)? onDeadPigTap;

  const PenItem({
    super.key,
    required this.pen,
    required this.isLast,
    this.onTap,
    this.onDeadPigTap,
  });

  Color get _statusColor => pen.status
      ? ColorConstants.successColor
      : pen.isFailed
      ? ColorConstants.errorColor
      : pen.isProcessing
      ? ColorConstants.themeColor
      : (pen.uploadPath.isNotEmpty || pen.outputPath.isNotEmpty)
      ? ColorConstants.themeColor
      : Colors.grey.shade400;

  IconData get _statusIcon {
    if (pen.status) return LucideIcons.circle_check;
    if (pen.isFailed) return LucideIcons.circle_alert;
    return LucideIcons.circle_dashed;
  }

  IconData get _typeIcon {
    switch (pen.type) {
      case UploadType.image:
        return LucideIcons.image;
      case UploadType.video:
        return LucideIcons.video;
      default:
        return LucideIcons.circle_minus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => onTap?.call(pen),
          child: Padding(
            padding: .symmetric(
              horizontal: UIConstants.gapSize.xl,
              vertical: UIConstants.gapSize.lg,
            ),
            child: Row(
              children: [
                // 状态图标
                Icon(_statusIcon, size: 15, color: _statusColor),
                SizedBox(width: UIConstants.gapSize.lg),
                // 栏位名称
                Expanded(
                  child: Text(
                    pen.name,
                    style: TextStyle(
                      fontSize: FontConstants.fontSize.sm,
                      fontFamily: FontConstants.fontFamily,
                      color: ColorConstants.defaultTextColor,
                    ),
                  ),
                ),
                // 完成数 / 状态
                Container(
                  padding: .symmetric(
                    horizontal: UIConstants.gapSize.lg,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withAlpha(25),
                    borderRadius: .circular(UIConstants.borderRadius),
                  ),
                  child: Text(
                    pen.status
                        ? "${pen.displayCount} 头"
                        : pen.isProcessing
                        ? "处理中"
                        : (pen.uploadPath.isNotEmpty ||
                              pen.outputPath.isNotEmpty)
                        ? "待复核"
                        : "未完成",
                    style: TextStyle(
                      color: _statusColor,
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontConstants.fontSize.xs,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: UIConstants.gapSize.lg),
                GestureDetector(
                  onTap: () => onDeadPigTap?.call(pen),
                  child: Container(
                    padding: .symmetric(
                      horizontal: UIConstants.gapSize.md,
                      vertical: UIConstants.gapSize.xs,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: .circular(UIConstants.borderRadius),
                      color: ColorConstants.errorColor.withAlpha(24),
                    ),
                    child: Text(
                      "死猪",
                      style: TextStyle(
                        color: ColorConstants.errorColor,
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontConstants.fontSize.xs,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: UIConstants.gapSize.lg),
                // 上传类型
                Icon(_typeIcon, size: 13, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(height: 1, indent: 44, color: Colors.grey.shade100),
      ],
    );
  }
}
