import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/widgets/task/pen_item.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../constants/ui.dart';
import '../../models/api/task.dart';

class BuildingItem extends StatefulWidget {
  final Building building;
  final void Function(Pen pen)? onPenTap;

  const BuildingItem({super.key, required this.building, this.onPenTap});

  @override
  State<BuildingItem> createState() => _BuildingItemState();
}

class _BuildingItemState extends State<BuildingItem> {
  bool _expanded = false;

  Widget buildLinearProgress() {
    return LinearProgressIndicator(
      value: widget.building.progress,
      minHeight: 3,
      backgroundColor: Colors.grey.shade100,
      color: widget.building.completed
          ? ColorConstants.successColor
          : ColorConstants.themeColor,
    );
  }

  Widget buildTitleRow() {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: .symmetric(
          horizontal: UIConstants.gapSize.xl,
          vertical: UIConstants.gapSize.lg,
        ),
        child: Row(
          children: [
            // 圆形进度指示器
            SizedBox(
              width: 36,
              height: 36,
              child: Stack(
                alignment: .center,
                children: [
                  CircularProgressIndicator(
                    value: widget.building.progress,
                    strokeWidth: 3,
                    backgroundColor: Colors.grey.shade200,
                    color: widget.building.completed
                        ? ColorConstants.successColor
                        : ColorConstants.themeColor,
                  ),
                  Text(
                    "${widget.building.completedPenCount}/${widget.building.totalPens}",
                    style: TextStyle(
                      fontSize: FontConstants.fontSize.xs,
                      fontWeight: FontWeight.w600,
                      color: widget.building.completed
                          ? ColorConstants.successColor
                          : ColorConstants.themeColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: UIConstants.gapSize.lg),
            // 名称 + 副标题
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.building.name,
                    style: TextStyle(
                      fontSize: FontConstants.fontSize.sm,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.defaultTextColor,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "${widget.building.completedPenCount} / ${widget.building.totalPens} 栏已完成",
                    style: TextStyle(
                      fontSize: FontConstants.fontSize.xs,
                      color: ColorConstants.defaultTextColor.withAlpha(100),
                    ),
                  ),
                ],
              ),
            ),

            // 展开箭头
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                LucideIcons.chevron_down,
                size: UIConstants.uiSize.sm + 4,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPenList() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _expanded
          ? Column(
              children: [
                Divider(height: 1, color: Colors.grey.shade100),
                ...widget.building.pens.map(
                  (pen) => PenItem(
                    pen: pen,
                    isLast: pen == widget.building.pens.last,
                    onTap: widget.onPenTap,
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(bottom: UIConstants.gapSize.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(UIConstants.borderRadius),
        border: .all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        child: Column(
          children: [
            // 顶部进度条装饰
            buildLinearProgress(),
            // Building 标题行
            buildTitleRow(),
            // Pen 列表
            buildPenList(),
          ],
        ),
      ),
    );
  }
}
