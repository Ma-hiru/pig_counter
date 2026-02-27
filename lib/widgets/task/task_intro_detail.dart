import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';

import 'building_item.dart';

class TaskIntroDetail extends StatefulWidget {
  final Task taskData;
  final void Function(Pen pen)? onTap;

  const TaskIntroDetail({super.key, required this.taskData, this.onTap});

  @override
  State<StatefulWidget> createState() => _TaskIntroDetailState();
}

class _TaskIntroDetailState extends State<TaskIntroDetail> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 展开 / 收起 按钮
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Icon(
                  LucideIcons.chevron_down,
                  size: UIConstants.uiSize.md,
                  color: ColorConstants.defaultTextColor.withAlpha(150),
                ),
              ),
              SizedBox(width: UIConstants.gapSize.md),
              Text(
                _expanded ? "收起详情" : "查看详情",
                style: TextStyle(
                  fontSize: FontConstants.fontSize.sm,
                  color: ColorConstants.defaultTextColor.withAlpha(150),
                ),
              ),
            ],
          ),
        ),
        // 动画展开区域
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _expanded
              ? Padding(
                  padding: .only(top: UIConstants.gapSize.lg),
                  child: Column(
                    children: widget.taskData.buildings
                        .map(
                          (b) =>
                              BuildingItem(building: b, onPenTap: widget.onTap),
                        )
                        .toList(),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
