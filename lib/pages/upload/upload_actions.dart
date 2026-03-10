import 'package:flutter/material.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/pages/upload/upload_options.dart';
import 'package:pig_counter/utils/modal.dart';
import 'package:pig_counter/widgets/button/button.dart';

class UploadActions extends StatelessWidget {
  final Pen pen;
  final UploadOptions uploadOptions;
  final void Function(Pen) onChange;

  const UploadActions({
    super.key,
    required this.pen,
    required this.onChange,
    required this.uploadOptions,
  });

  void selectImage() async {
    final image = await uploadOptions.selectImage();
    if (image is String) {
      onChange(pen.copyWith(localPath: image, localType: .image));
    }
  }

  void selectVideo() async {
    final video = await uploadOptions.selectVideo();
    if (video is String) {
      onChange(pen.copyWith(localPath: video, localType: .video));
    }
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
            //todo use api
            onChange(
              pen.copyWith(
                manualCount: number,
                status: true,
                localPath: "",
                localType: .none,
              ),
            );
          }
        },
      ),
    );
  }

  Future confirmUpload() async {
    // todo use api
    
  }

  void cancelOption(BuildContext context) {
    // 已完成
    if (pen.status) return;
    // 已上传且已输出
    if (pen.outputPath.isNotEmpty) {
      // todo use api
      onChange(pen.copyWith(outputPath: "", uploadPath: "", type: .none));
    }
    // 已上传但未输出
    if (pen.uploadPath.isNotEmpty) {
      // todo use api
      onChange(pen.copyWith(uploadPath: "", type: .none));
    }
    // 未上传但已选择
    if (pen.localPath.isNotEmpty == true) {
      onChange(pen.copyWith(localPath: "", localType: .none));
    }
  }

  List<Widget> buildActions(BuildContext context) {
    // 已完成
    if (pen.status) return [];
    // 已上传且已输出
    if (pen.outputPath.isNotEmpty) {
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
    if (pen.uploadPath.isNotEmpty) {
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
        AppButton.normal(label: "取消", onPressed: () => cancelOption(context)),
      ];
    }
    // 未选择
    return [
      AppButton.normal(label: "图片", filled: true, onPressed: selectImage),
      AppButton.normal(label: "视频", filled: true, onPressed: selectVideo),
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
