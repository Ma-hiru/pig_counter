import 'package:flutter/material.dart';
import 'package:pig_counter/widgets/task/pen_item.dart';

import '../../constants/color.dart';
import '../../constants/ui.dart';
import '../../models/api/task.dart';
import 'building_item_title_row.dart';

class BuildingItem extends StatefulWidget {
  final Building building;
  final void Function(Building building, Pen pen)? onPenTap;

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
                    onTap: (pen) => widget.onPenTap?.call(widget.building, pen),
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
        borderRadius: .circular(UIConstants.borderRadius),
        child: Column(
          children: [
            // 顶部进度条装饰
            buildLinearProgress(),
            // Building 标题行
            BuildingItemTitleRow(
              building: widget.building,
              expanded: _expanded,
              onTap: () => setState(() => _expanded = !_expanded),
            ),
            // Pen 列表
            buildPenList(),
          ],
        ),
      ),
    );
  }
}
