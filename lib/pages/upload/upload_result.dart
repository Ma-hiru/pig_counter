import 'package:flutter/material.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';

class UploadResult extends StatelessWidget {
  final Pen pen;

  const UploadResult({super.key, required this.pen});

  Widget buildItem(String label, int count) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontConstants.fontSize.md,
            fontWeight: .w500,
          ),
        ),
        Text(
          count.toString(),
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontConstants.fontSize.md,
            fontWeight: .w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(
        vertical: UIConstants.gapSize.lg,
        horizontal: UIConstants.gapSize.md,
      ),
      child: Column(
        mainAxisAlignment: .end,
        spacing: UIConstants.gapSize.sm,
        children: [
          if (pen.aiCount > 0) buildItem("aiCount", pen.aiCount),
          if (pen.manualCount > 0) buildItem("manualCount", pen.manualCount),
        ],
      ),
    );
  }
}
