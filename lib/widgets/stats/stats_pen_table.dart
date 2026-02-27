import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/widgets/stats/stats_section_title.dart';

class StatsPenTable extends StatelessWidget {
  final Task taskData;

  const StatsPenTable({super.key, required this.taskData});

  @override
  Widget build(BuildContext context) {
    final allPens = <(Building, Pen)>[
      for (final b in taskData.buildings)
        for (final p in b.pens) (b, p),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatsSectionTitle(title: "栏位明细", icon: LucideIcons.table),
        SizedBox(height: UIConstants.gapSize.lg),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(UIConstants.borderRadius),
            border: Border.all(color: Colors.grey.shade200),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _HeaderRow(),
              const Divider(height: 1, thickness: 1),
              ...allPens.indexed.map(
                (entry) => _DataRow(
                  building: entry.$2.$1,
                  pen: entry.$2.$2,
                  odd: entry.$1.isOdd,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 公共 cell 构建函数
Widget _cell(Widget child, {bool center = true}) => Expanded(
  child: Padding(
    padding: EdgeInsets.symmetric(vertical: UIConstants.gapSize.md),
    child: center ? Center(child: child) : child,
  ),
);

const _headerStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w700,
  color: ColorConstants.secondaryTextColor,
);

const _cellStyle = TextStyle(
  fontSize: 11,
  color: ColorConstants.defaultTextColor,
);

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: UIConstants.gapSize.lg),
      color: ColorConstants.themeColor.withAlpha(15),
      child: Row(
        children: [
          _cell(const Text("栋舍", style: _headerStyle), center: false),
          _cell(const Text("栏位", style: _headerStyle), center: false),
          _cell(const Text("AI 数", style: _headerStyle)),
          _cell(const Text("人工数", style: _headerStyle)),
          _cell(const Text("类型", style: _headerStyle)),
          _cell(const Text("状态", style: _headerStyle)),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final Building building;
  final Pen pen;
  final bool odd;

  const _DataRow({
    required this.building,
    required this.pen,
    required this.odd,
  });

  @override
  Widget build(BuildContext context) {
    String typeLabel;
    Color typeColor;
    switch (pen.type) {
      case UploadType.image:
        typeLabel = "图片";
        typeColor = const Color(0xFF2196F3);
      case UploadType.video:
        typeLabel = "视频";
        typeColor = const Color(0xFF9C27B0);
      default:
        typeLabel = "—";
        typeColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: UIConstants.gapSize.lg),
      color: odd ? Colors.grey.shade50 : Colors.white,
      child: Row(
        children: [
          _cell(
            Text(
              building.name,
              style: _cellStyle,
              overflow: TextOverflow.ellipsis,
            ),
            center: false,
          ),
          _cell(
            Text(pen.name, style: _cellStyle, overflow: TextOverflow.ellipsis),
            center: false,
          ),
          _cell(
            Text(
              pen.aiCount > 0 ? pen.aiCount.toString() : "—",
              style: _cellStyle.copyWith(
                color: const Color(0xFF2196F3),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _cell(
            Text(
              pen.manualCount > 0 ? pen.manualCount.toString() : "—",
              style: _cellStyle.copyWith(
                color: const Color(0xFFFF7043),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _cell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: typeColor.withAlpha(25),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                typeLabel,
                style: TextStyle(
                  fontSize: 10,
                  color: typeColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          _cell(
            Icon(
              pen.status ? LucideIcons.circle_check : LucideIcons.circle_dashed,
              size: 14,
              color: pen.status
                  ? ColorConstants.successColor
                  : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
