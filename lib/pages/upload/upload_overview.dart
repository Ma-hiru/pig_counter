import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/pen_overview.dart';

class UploadOverview extends StatefulWidget {
  final int penId;
  final int refreshVersion;

  const UploadOverview({
    super.key,
    required this.penId,
    required this.refreshVersion,
  });

  @override
  State<UploadOverview> createState() => _UploadOverviewState();
}

class _UploadOverviewState extends State<UploadOverview> {
  bool _loading = false;
  PenInventoryOverview _overview = PenInventoryOverview.empty();

  Future<void> _loadOverview() async {
    if (widget.penId <= 0) return;
    if (mounted) setState(() => _loading = true);
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final startDate = DateFormat(
      "yyyy-MM-dd",
    ).format(DateTime.now().subtract(const Duration(days: 6)));
    try {
      final result = await API.Pen.overview(
        penId: widget.penId,
        date: today,
        startDate: startDate,
        endDate: today,
        recentMediaLimit: 5,
      );
      if (!mounted) return;
      if (result.ok) {
        setState(() {
          _overview = result.data;
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildStat({required String label, required int value, Color? color}) {
    final statColor = color ?? ColorConstants.themeColor;
    return Container(
      padding: EdgeInsets.all(UIConstants.gapSize.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        color: statColor.withAlpha(14),
        border: Border.all(color: statColor.withAlpha(48)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.fontSize.xs,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
          SizedBox(height: UIConstants.gapSize.xs),
          Text(
            value.toString(),
            style: TextStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.fontSize.md,
              fontWeight: FontWeight.w700,
              color: statColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadOverview();
  }

  @override
  void didUpdateWidget(covariant UploadOverview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.penId != widget.penId ||
        oldWidget.refreshVersion != widget.refreshVersion) {
      _loadOverview();
    }
  }

  @override
  Widget build(BuildContext context) {
    final liveFinalCount = _overview.todayLiveStat.finalCount;
    final confirmedFinalCount = _overview.todayConfirmedStat.finalCount;
    final deadPigQuantity = _overview.todayConfirmedStat.deadPigQuantity;
    final totalMediaCount = _overview.todayMediaSummary.totalMediaCount;
    final confirmedMediaCount = _overview.todayMediaSummary.confirmedMediaCount;
    final processingMediaCount =
        _overview.todayMediaSummary.processingMediaCount;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(UIConstants.gapSize.lg),
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
                "栏舍看板",
                style: TextStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontConstants.fontSize.sm,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.defaultTextColor,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _loading ? null : _loadOverview,
                child: Text(_loading ? "刷新中..." : "刷新"),
              ),
            ],
          ),
          SizedBox(height: UIConstants.gapSize.sm),
          Row(
            children: [
              Expanded(
                child: _buildStat(
                  label: "实时建议数量",
                  value: liveFinalCount,
                  color: const Color(0xFF1976D2),
                ),
              ),
              SizedBox(width: UIConstants.gapSize.md),
              Expanded(
                child: _buildStat(
                  label: "正式确认数量",
                  value: confirmedFinalCount,
                  color: ColorConstants.themeColor,
                ),
              ),
              SizedBox(width: UIConstants.gapSize.md),
              Expanded(
                child: _buildStat(
                  label: "死猪数",
                  value: deadPigQuantity,
                  color: ColorConstants.errorColor,
                ),
              ),
            ],
          ),
          SizedBox(height: UIConstants.gapSize.md),
          Row(
            children: [
              Expanded(
                child: _buildStat(label: "媒体总数", value: totalMediaCount),
              ),
              SizedBox(width: UIConstants.gapSize.md),
              Expanded(
                child: _buildStat(
                  label: "已确认媒体",
                  value: confirmedMediaCount,
                  color: ColorConstants.successColor,
                ),
              ),
              SizedBox(width: UIConstants.gapSize.md),
              Expanded(
                child: _buildStat(
                  label: "处理中媒体",
                  value: processingMediaCount,
                  color: const Color(0xFFFF9800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
