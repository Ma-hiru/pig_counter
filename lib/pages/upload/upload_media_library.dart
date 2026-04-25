import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/media.dart';
import 'package:pig_counter/widgets/tips/tips.dart';

class UploadMediaLibrary extends StatefulWidget {
  final int penId;
  final int refreshVersion;

  const UploadMediaLibrary({
    super.key,
    required this.penId,
    required this.refreshVersion,
  });

  @override
  State<UploadMediaLibrary> createState() => _UploadMediaLibraryState();
}

class _UploadMediaLibraryState extends State<UploadMediaLibrary> {
  bool _loading = false;
  String _errorText = "";
  List<InventoryMediaItem> _items = const [];

  String get _today => DateFormat("yyyy-MM-dd").format(DateTime.now());

  Future<void> _loadLibrary() async {
    if (widget.penId <= 0) return;
    if (mounted) {
      setState(() {
        _loading = true;
        _errorText = "";
      });
    }

    try {
      final response = await API.Media.library(
        penId: widget.penId,
        date: _today,
      );
      if (!mounted) return;
      if (!response.ok) {
        setState(() {
          _errorText = response.message.isNotEmpty
              ? response.message
              : "获取栏舍媒体库失败";
          _items = [];
        });
        return;
      }
      setState(() {
        _items = response.data;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorText = "获取栏舍媒体库失败";
        _items = [];
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  @override
  void didUpdateWidget(covariant UploadMediaLibrary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.penId != widget.penId ||
        oldWidget.refreshVersion != widget.refreshVersion) {
      _loadLibrary();
    }
  }

  Color _statusColor(InventoryMediaItem item) {
    if (item.status) return ColorConstants.successColor;
    final status = item.processingStatus.toUpperCase();
    if (status == "FAILED") return ColorConstants.errorColor;
    if (status == "PROCESSING" || status == "PENDING") {
      return const Color(0xFF1E88E5);
    }
    return ColorConstants.themeColor;
  }

  String _statusText(InventoryMediaItem item) {
    if (item.status) return "已确认";
    final status = item.processingStatus.toUpperCase();
    if (status == "FAILED") return "处理失败";
    if (status == "PROCESSING" || status == "PENDING") return "处理中";
    if (status.isNotEmpty) return status;
    return "待复核";
  }

  int _displayCount(InventoryMediaItem item) {
    if (item.manualCount > 0) return item.manualCount;
    return item.count;
  }

  String _previewUrl(InventoryMediaItem item) {
    if (item.thumbnailPath.isNotEmpty) return item.thumbnailPath;
    if (item.outputPicturePath.isNotEmpty) return item.outputPicturePath;
    return item.picturePath;
  }

  Widget _buildMediaItem(InventoryMediaItem item) {
    final statusColor = _statusColor(item);
    final previewUrl = _previewUrl(item);
    return Container(
      padding: EdgeInsets.all(UIConstants.gapSize.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(UIConstants.borderRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: previewUrl.isNotEmpty
                ? Image.network(
                    previewUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey.shade400,
                    ),
                  )
                : Icon(Icons.image_outlined, color: Colors.grey.shade400),
          ),
          SizedBox(width: UIConstants.gapSize.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "#${item.mediaId} · ${item.mediaType.toUpperCase()}",
                        style: TextStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontConstants.fontSize.sm,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.defaultTextColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: UIConstants.gapSize.sm,
                        vertical: UIConstants.gapSize.xs,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(
                          UIConstants.borderRadius,
                        ),
                      ),
                      child: Text(
                        _statusText(item),
                        style: TextStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontConstants.fontSize.xs,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: UIConstants.gapSize.xs),
                Text(
                  "数量：${_displayCount(item)} 头（AI ${item.count} / 人工 ${item.manualCount}）",
                  style: TextStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontConstants.fontSize.xs,
                    color: ColorConstants.secondaryTextColor,
                  ),
                ),
                SizedBox(height: UIConstants.gapSize.xs),
                Text(
                  "采集时间：${item.captureTime.isNotEmpty ? item.captureTime : (item.time.isNotEmpty ? item.time : "-")}",
                  style: TextStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontConstants.fontSize.xs,
                    color: ColorConstants.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorText.isNotEmpty) {
      return AppTips.icon(text: _errorText, type: .error);
    }
    if (_items.isEmpty) {
      return AppTips.icon(text: "今日暂无栏舍媒体记录", type: .blank);
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _items.length,
      separatorBuilder: (_, _) => SizedBox(height: UIConstants.gapSize.sm),
      itemBuilder: (_, index) => _buildMediaItem(_items[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                "栏舍媒体库（$_today）",
                style: TextStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontConstants.fontSize.sm,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.defaultTextColor,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _loading ? null : _loadLibrary,
                child: Text(_loading ? "刷新中..." : "刷新"),
              ),
            ],
          ),
          SizedBox(height: UIConstants.gapSize.sm),
          _buildContent(),
        ],
      ),
    );
  }
}
