import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';

class StatsTaskSelector extends StatelessWidget {
  final List<Task> taskList;
  final int selectedIndex;
  final void Function(int index) onSelect;

  const StatsTaskSelector({
    super.key,
    required this.taskList,
    required this.selectedIndex,
    required this.onSelect,
  });

  Color _accentColor(Task task) {
    if (task.outdate && !task.completed) return ColorConstants.errorColor;
    if (task.completed) return ColorConstants.successColor;
    return ColorConstants.themeColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: UIConstants.contentPaddingFromSides,
        ),
        itemCount: taskList.length,
        separatorBuilder: (_, __) => SizedBox(width: UIConstants.gapSize.lg),
        itemBuilder: (ctx, i) {
          final task = taskList[i];
          final selected = i == selectedIndex;
          final accent = _accentColor(task);
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: UIConstants.gapSize.xl,
                vertical: UIConstants.gapSize.md,
              ),
              decoration: BoxDecoration(
                color: selected ? accent : Colors.white,
                borderRadius: BorderRadius.circular(
                  UIConstants.borderRadius * 3,
                ),
                border: Border.all(
                  color: selected ? accent : Colors.grey.shade300,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: accent.withAlpha(60),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                task.name,
                style: TextStyle(
                  fontSize: FontConstants.fontSize.sm,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected
                      ? Colors.white
                      : ColorConstants.secondaryTextColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
