import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/utils/cache.dart';
import 'package:pig_counter/utils/media_selector.dart';
import 'package:pig_counter/utils/modal.dart';
import 'package:pig_counter/utils/toast.dart';
import 'package:pig_counter/widgets/button/button.dart';

class UploadActions extends StatefulWidget {
  final Pen pen;
  final int taskID;
  final int buildingID;
  final MediaSelector uploadOptions;
  final void Function(Pen) onChange;
  final Future<void> Function()? onRefresh;

  const UploadActions({
    super.key,
    required this.pen,
    required this.taskID,
    required this.buildingID,
    required this.onChange,
    required this.uploadOptions,
    this.onRefresh,
  });

  @override
  State<UploadActions> createState() => _UploadActionsState();
}

class _UploadActionsState extends State<UploadActions> {
  bool _uploading = false;
  bool _saving = false;
  String _statusText = "";
  Color _statusColor = ColorConstants.themeColor;

  bool get _busy => _uploading || _saving;

  void _showStatus(String text, Color color) {
    if (!mounted) return;
    setState(() {
      _statusText = text;
      _statusColor = color;
    });
  }

  void _selectImage(BuildContext context) {
    if (_busy) return;
    AppModal.show(
      context,
      .select(
        title: "选择图片",
        leftText: "图库",
        rightText: "拍摄",
        onSelectLeft: () async {
          final image = await widget.uploadOptions.selectImage();
          if (image is String) {
            widget.onChange(
              widget.pen.copyWith(localPath: image, localType: .image),
            );
            _showStatus("图片已选中，点击“上传到当前栏”开始上传。", ColorConstants.themeColor);
          }
        },
        onSelectRight: () async {
          final image = await widget.uploadOptions.takeImage();
          if (image is String) {
            widget.onChange(
              widget.pen.copyWith(localPath: image, localType: .image),
            );
            _showStatus("图片已拍摄，点击“上传到当前栏”开始上传。", ColorConstants.themeColor);
          }
        },
      ),
    );
  }

  void _selectVideo(BuildContext context) {
    if (_busy) return;
    AppModal.show(
      context,
      .select(
        title: "选择视频",
        leftText: "图库",
        rightText: "拍摄",
        onSelectLeft: () async {
          final video = await widget.uploadOptions.selectVideo();
          if (video is String) {
            widget.onChange(
              widget.pen.copyWith(localPath: video, localType: .video),
            );
            _showStatus("视频已选中，点击“上传到当前栏”开始上传。", ColorConstants.themeColor);
          }
        },
        onSelectRight: () async {
          final video = await widget.uploadOptions.takeVideo();
          if (video is String) {
            widget.onChange(
              widget.pen.copyWith(localPath: video, localType: .video),
            );
            _showStatus("视频已拍摄，点击“上传到当前栏”开始上传。", ColorConstants.themeColor);
          }
        },
      ),
    );
  }

  Future<void> _refreshLatestStatus({
    String? successStatusText,
    Color? successStatusColor,
  }) async {
    await widget.onRefresh?.call();
    if (successStatusText?.isNotEmpty == true) {
      _showStatus(
        successStatusText!,
        successStatusColor ?? ColorConstants.successColor,
      );
    }
  }

  Future<void> _confirmUpload() async {
    if (_busy) return;
    if (widget.pen.localPath.isEmpty) {
      Toast.showToast(.error("请先选择媒体文件"));
      return;
    }

    var shouldRefresh = false;
    var finalStatusText = "";
    var finalStatusColor = ColorConstants.successColor;

    setState(() {
      _uploading = true;
      _statusText = "正在上传媒体并写入任务，请稍候...";
      _statusColor = const Color(0xFF1E88E5);
    });

    try {
      final uploadResult = await API.Media.uploadBound(
        taskId: widget.taskID,
        penId: widget.pen.id,
        filePaths: [widget.pen.localPath],
        captureTime: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      );
      if (!uploadResult.ok) {
        final message = uploadResult.message.isNotEmpty
            ? uploadResult.message
            : "上传失败";
        _showStatus(message, ColorConstants.errorColor);
        Toast.showToast(.error(message));
        return;
      }

      if (uploadResult.data.createdItems.isNotEmpty) {
        final media = uploadResult.data.createdItems.first;
        widget.onChange(
          widget.pen.copyWith(
            mediaId: media.mediaId,
            aiCount: media.count,
            uploadPath: media.picturePath,
            outputPath: media.outputPicturePath,
            thumbnailPath: media.thumbnailPath,
            processingStatus: media.processingStatus,
            processingMessage: media.processingMessage,
            captureTime: media.captureTime,
            type: UploadTypeExt.fromRaw(media.mediaType),
            localPath: "",
            localType: .none,
          ),
        );
        shouldRefresh = true;

        final processingStatus = media.processingStatus.toUpperCase();
        final waitingForAi =
            processingStatus == "PENDING" || processingStatus == "PROCESSING";

        finalStatusText = waitingForAi
            ? "媒体已入库，AI 正在处理中，正在同步最新结果..."
            : "媒体已上传完成，正在同步最新结果...";
        Toast.showToast(.success(waitingForAi ? "媒体已上传，等待AI处理" : "上传成功"));
      } else if (uploadResult.data.duplicateItems.isNotEmpty) {
        final duplicate = uploadResult.data.duplicateItems.first;
        final message = duplicate.message.isNotEmpty
            ? duplicate.message
            : "媒体重复，上传被拒绝";
        _showStatus(message, ColorConstants.errorColor);
        Toast.showToast(.error(message));
      } else {
        finalStatusText = "媒体已提交，但后端未返回详情，正在尝试同步最新状态...";
        shouldRefresh = true;
      }
    } catch (_) {
      _showStatus("上传失败，请检查网络后重试。", ColorConstants.errorColor);
      Toast.showToast(.error("上传失败，请检查网络后重试，必要时先暂存到本机"));
    } finally {
      await TaskCache.remove(
        taskID: widget.taskID,
        buildingID: widget.buildingID,
        penID: widget.pen.id,
      ).catchError((_) {});

      if (shouldRefresh) {
        await _refreshLatestStatus(
          successStatusText: finalStatusText.isNotEmpty
              ? finalStatusText
              : "最新状态已同步",
          successStatusColor: finalStatusColor,
        );
      }

      if (mounted) {
        setState(() {
          _uploading = false;
          if (!shouldRefresh && _statusText.isEmpty) {
            _statusText = "上传流程已结束。";
            _statusColor = ColorConstants.secondaryTextColor;
          }
        });
      }
    }
  }

  Future<void> _saveTemp() async {
    if (_busy) return;
    if (widget.pen.localPath.isEmpty) {
      Toast.showToast(.error("当前没有可暂存的本地文件"));
      return;
    }

    setState(() {
      _saving = true;
      _statusText = "正在暂存本地文件...";
      _statusColor = ColorConstants.themeColor;
    });

    try {
      await TaskCache.save(
        taskID: widget.taskID,
        buildingID: widget.buildingID,
        penID: widget.pen.id,
        uri: widget.pen.localPath,
        type: widget.pen.localType,
      );
      _showStatus("已暂存到本机，后续可继续上传。", ColorConstants.successColor);
      Toast.showToast(.success("保存成功"));
    } catch (err) {
      if (kDebugMode) print("Failed to save temp file: $err");
      _showStatus("暂存失败，请稍后重试。", ColorConstants.errorColor);
      Toast.showToast(.error("保存失败"));
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _cancelLocalSelection() async {
    if (_busy) return;
    try {
      if (widget.pen.localPath.isNotEmpty) {
        await TaskCache.remove(
          taskID: widget.taskID,
          buildingID: widget.buildingID,
          penID: widget.pen.id,
        );
        widget.onChange(widget.pen.copyWith(localPath: "", localType: .none));
        _showStatus("已取消本地选择。", ColorConstants.secondaryTextColor);
      }
    } catch (_) {
      Toast.showToast(.error("操作失败，请稍后重试"));
    }
  }

  Widget _buildStatusCard() {
    if (_statusText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(UIConstants.gapSize.md),
      decoration: BoxDecoration(
        color: _statusColor.withAlpha(14),
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        border: Border.all(color: _statusColor.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: _busy
                ? CircularProgressIndicator(strokeWidth: 2, color: _statusColor)
                : Icon(Icons.info_outline, size: 18, color: _statusColor),
          ),
          SizedBox(width: UIConstants.gapSize.sm),
          Expanded(
            child: Text(
              _statusText,
              style: TextStyle(
                color: _statusColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];

    if (widget.pen.localPath.isNotEmpty) {
      actions.add(
        AppButton.normal(
          label: _uploading ? "上传中..." : "上传到当前栏",
          filled: true,
          loading: _uploading,
          disabled: _busy,
          onPressed: _confirmUpload,
        ),
      );
      actions.add(
        AppButton.normal(
          label: _saving ? "暂存中..." : "暂存",
          filled: true,
          loading: _saving,
          disabled: _busy,
          onPressed: _saveTemp,
        ),
      );
      actions.add(
        AppButton.normal(
          label: "取消选择",
          disabled: _busy,
          onPressed: _cancelLocalSelection,
        ),
      );
    } else {
      actions.add(
        AppButton.normal(
          label: "当前栏上传图片",
          filled: true,
          disabled: _busy,
          onPressed: () => _selectImage(context),
        ),
      );
      actions.add(
        AppButton.normal(
          label: "当前栏上传视频",
          filled: true,
          disabled: _busy,
          onPressed: () => _selectVideo(context),
        ),
      );
    }

    actions.add(
      AppButton.normal(
        label: "刷新栏舍媒体状态",
        disabled: _busy,
        onPressed: () async => await widget.onRefresh?.call(),
      ),
    );
    actions.add(
      AppButton.normal(
        label: "返回",
        disabled: _busy,
        onPressed: () => Navigator.pop(context),
      ),
    );

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: UIConstants.gapSize.md,
      children: [_buildStatusCard(), ..._buildActions(context)],
    );
  }
}
