import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/utils/cache.dart';
import 'package:pig_counter/utils/media_selector.dart';
import 'package:pig_counter/utils/modal.dart';
import 'package:pig_counter/utils/toast.dart';
import 'package:pig_counter/widgets/button/button.dart';

class UploadActions extends StatelessWidget {
  final Pen pen;
  final int taskID;
  final int buildingID;
  final MediaSelector uploadOptions;
  final void Function(Pen) onChange;

  const UploadActions({
    super.key,
    required this.pen,
    required this.taskID,
    required this.buildingID,
    required this.onChange,
    required this.uploadOptions,
  });

  void selectImage(BuildContext context) {
    AppModal.show(
      context,
      .select(
        title: "选择图片",
        leftText: "图库",
        rightText: "拍摄",
        onSelectLeft: () async {
          cancelOption(context);
          final image = await uploadOptions.selectImage();
          if (image is String) {
            onChange(pen.copyWith(localPath: image, localType: .image));
          }
        },
        onSelectRight: () async {
          cancelOption(context);
          final image = await uploadOptions.takeImage();
          if (image is String) {
            onChange(pen.copyWith(localPath: image, localType: .image));
          }
        },
      ),
    );
  }

  void selectVideo(BuildContext context) {
    AppModal.show(
      context,
      .select(
        title: "选择视频",
        leftText: "图库",
        rightText: "拍摄",
        onSelectLeft: () async {
          cancelOption(context);
          final video = await uploadOptions.selectVideo();
          if (video is String) {
            onChange(pen.copyWith(localPath: video, localType: .video));
          }
        },
        onSelectRight: () async {
          cancelOption(context);
          final video = await uploadOptions.takeVideo();
          if (video is String) {
            onChange(pen.copyWith(localPath: video, localType: .video));
          }
        },
      ),
    );
  }

  Future confirmResult(BuildContext context) async {
    AppModal.show(
      context,
      .input(
        title: "核对数目",
        keyboardType: .numberWithOptions(signed: false, decimal: true),
        onConfirm: (input) {
          final number = int.tryParse(input);
          if (number is int && number >= 0) {
            Future<void>(() async {
              if (pen.mediaId <= 0) {
                Toast.showToast(.error("未找到媒体ID，请刷新后重试"));
                return;
              }

              final manualResult = await API.Media.manualCount(
                mediaId: pen.mediaId,
                manualCount: number,
              );
              if (!manualResult.ok) {
                Toast.showToast(
                  .error(
                    manualResult.message.isNotEmpty
                        ? manualResult.message
                        : "更新人工数量失败",
                  ),
                );
                return;
              }

              final confirmResult = await API.Media.confirm([pen.mediaId]);
              if (!confirmResult.ok) {
                Toast.showToast(
                  .error(
                    confirmResult.message.isNotEmpty
                        ? confirmResult.message
                        : "确认媒体失败",
                  ),
                );
                return;
              }

              onChange(
                pen.copyWith(
                  manualCount: number,
                  status: true,
                  localPath: "",
                  localType: .none,
                ),
              );
              Toast.showToast(.success("确认成功"));
            }).catchError((_) {
              Toast.showToast(.error("确认失败，请检查网络后重试"));
            });
          }
        },
      ),
    );
  }

  Future confirmUpload() async {
    if (pen.localPath.isEmpty) {
      Toast.showToast(.error("请先选择媒体文件"));
      return;
    }

    try {
      final uploadResult = await API.Media.uploadBound(
        taskId: taskID,
        penId: pen.id,
        filePaths: [pen.localPath],
        captureTime: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      );
      if (!uploadResult.ok) {
        Toast.showToast(
          .error(
            uploadResult.message.isNotEmpty ? uploadResult.message : "上传失败",
          ),
        );
        return;
      }

      if (uploadResult.data.createdItems.isNotEmpty) {
        final media = uploadResult.data.createdItems.first;
        onChange(
          pen.copyWith(
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
            status: false,
          ),
        );
        Toast.showToast(.success("上传成功"));
      } else if (uploadResult.data.duplicateItems.isNotEmpty) {
        final duplicate = uploadResult.data.duplicateItems.first;
        Toast.showToast(
          .error(
            duplicate.message.isNotEmpty ? duplicate.message : "媒体重复，上传被拒绝",
          ),
        );
      } else {
        Toast.showToast(.error("上传结果为空，请稍后刷新查看"));
      }
    } catch (_) {
      Toast.showToast(.error("上传失败，请检查网络后重试"));
    }

    // finally remove temp cache
    TaskCache.remove(
      taskID: taskID,
      buildingID: buildingID,
      penID: pen.id,
    ).catchError((_) {});
  }

  void saveTemp() {
    TaskCache.save(
          taskID: taskID,
          buildingID: buildingID,
          penID: pen.id,
          uri: pen.localPath,
          type: pen.localType,
        )
        .then((_) {
          Toast.showToast(.success("保存成功"));
        })
        .catchError((err) {
          if (kDebugMode) print("Failed to save temp file: $err");
          Toast.showToast(.error("保存失败"));
        });
  }

  void cancelOption(BuildContext context) {
    Future<void>(() async {
      if (pen.status) {
        if (pen.mediaId <= 0) {
          Toast.showToast(.error("未找到媒体ID，无法解锁"));
          return;
        }
        final unlockResult = await API.Media.unlock([pen.mediaId]);
        if (!unlockResult.ok) {
          Toast.showToast(
            .error(
              unlockResult.message.isNotEmpty ? unlockResult.message : "解锁失败",
            ),
          );
          return;
        }
        onChange(pen.copyWith(status: false));
        Toast.showToast(.success("已解锁"));
        return;
      }

      if (pen.uploadPath.isNotEmpty || pen.outputPath.isNotEmpty) {
        if (pen.mediaId <= 0) {
          Toast.showToast(.error("未找到媒体ID，无法删除"));
          return;
        }
        final deleteResult = await API.Media.delete(pen.mediaId);
        if (!deleteResult.ok) {
          Toast.showToast(
            .error(
              deleteResult.message.isNotEmpty ? deleteResult.message : "删除媒体失败",
            ),
          );
          return;
        }
        onChange(
          pen.copyWith(
            mediaId: 0,
            aiCount: 0,
            manualCount: 0,
            uploadPath: "",
            outputPath: "",
            thumbnailPath: "",
            processingStatus: "",
            processingMessage: "",
            captureTime: "",
            status: false,
            type: .none,
          ),
        );
        Toast.showToast(.success("已删除媒体"));
        return;
      }

      if (pen.localPath.isNotEmpty) {
        await TaskCache.remove(
          taskID: taskID,
          buildingID: buildingID,
          penID: pen.id,
        );
        onChange(pen.copyWith(localPath: "", localType: .none));
      }
    }).catchError((_) {
      Toast.showToast(.error("操作失败，请稍后重试"));
    });
  }

  List<Widget> buildActions(BuildContext context) {
    final canConfirm =
        pen.outputPath.isNotEmpty ||
        (pen.uploadPath.isNotEmpty &&
            pen.processingStatus.toUpperCase() == "SUCCESS");

    // 已完成
    if (pen.status) {
      return [
        AppButton.normal(label: "解锁", onPressed: () => cancelOption(context)),
      ];
    }
    // 已上传且已输出
    if (canConfirm) {
      return [
        AppButton.normal(
          label: "确认",
          filled: true,
          onPressed: () => confirmResult(context),
        ),
        AppButton.normal(label: "取消", onPressed: () => cancelOption(context)),
      ];
    }
    // 已上传但未输出
    if (pen.isProcessing) {
      return [
        AppButton.normal(label: "处理中", disabled: true, filled: true),
        AppButton.normal(label: "取消", onPressed: () => cancelOption(context)),
      ];
    }
    // 未上传但已选择
    if (pen.localPath.isNotEmpty == true) {
      return [
        AppButton.normal(
          label: "上传",
          filled: true,
          onPressed: () => confirmUpload(),
        ),
        AppButton.normal(label: "暂存", filled: true, onPressed: saveTemp),
        AppButton.normal(label: "取消", onPressed: () => cancelOption(context)),
      ];
    }
    // 未选择
    return [
      AppButton.normal(
        label: "图片",
        filled: true,
        onPressed: () => selectImage(context),
      ),
      AppButton.normal(
        label: "视频",
        filled: true,
        onPressed: () => selectVideo(context),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: UIConstants.gapSize.md,
      children: [
        ...buildActions(context),
        AppButton.normal(label: "返回", onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}
