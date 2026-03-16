import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/widgets/stats/stats_section_title.dart';

import '../../constants/font.dart';

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
            borderRadius: .circular(UIConstants.borderRadius),
            border: .all(color: Colors.grey.shade200),
          ),
          clipBehavior: .antiAlias,
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

Widget _cell(
  Widget child, {
  bool center = true,
  int flex = 1,
  FlexFit fit = .loose,
}) => Flexible(
  fit: fit,
  flex: flex,
  child: Padding(
    padding: .symmetric(vertical: UIConstants.gapSize.md),
    child: center ? Center(child: child) : child,
  ),
);

final _headerStyle = TextStyle(
  fontWeight: .w700,
  fontSize: FontConstants.fontSize.xs,
  fontFamily: FontConstants.fontFamily,
  color: ColorConstants.secondaryTextColor,
);

final _cellStyle = TextStyle(
  fontSize: FontConstants.fontSize.xs,
  fontFamily: FontConstants.fontFamily,
  color: ColorConstants.defaultTextColor,
  fontWeight: .w400,
);

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: UIConstants.gapSize.lg),
      color: ColorConstants.themeColor.withAlpha(15),
      child: Row(
        children: [
          _cell(Text("栋舍", style: _headerStyle), flex: 2),
          _cell(Text("栏位", style: _headerStyle), flex: 2),
          _cell(Text("AI/人工", style: _headerStyle), flex: 1),
          _cell(Text("状态", style: _headerStyle), flex: 1),
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

  String getCountText() {
    final aiCount = pen.aiCount > 0 ? pen.aiCount.toString() : "—";
    final manualCount = pen.manualCount > 0 ? pen.manualCount.toString() : "—";
    if (aiCount == "—" && manualCount == "—") return "—";
    return "$aiCount / $manualCount";
  }

  IconData getStatusIcon() {
    if (!pen.status) return LucideIcons.circle_dashed;
    if (pen.type == .image) {
      return LucideIcons.image;
    } else if (pen.type == .video) {
      return LucideIcons.film;
    } else {
      return LucideIcons.circle_check;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: UIConstants.gapSize.lg),
      color: odd ? Colors.grey.shade50 : Colors.white,
      child: Row(
        children: [
          _cell(
            Text(building.name, style: _cellStyle, overflow: .ellipsis),
            flex: 2,
          ),
          _cell(
            Text(pen.name, style: _cellStyle, overflow: .ellipsis),
            flex: 2,
          ),
          _cell(
            Text(
              getCountText(),
              style: _cellStyle.copyWith(
                color: ColorConstants.themeColor,
                fontWeight: .w700,
              ),
            ),
            flex: 1,
          ),
          _cell(
            Icon(
              getStatusIcon(),
              size: UIConstants.uiSize.md,
              color: pen.status
                  ? ColorConstants.successColor
                  : Colors.grey.shade400,
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
