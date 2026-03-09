import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/widgets/loading/loading.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/upload/video_perview.dart';

class UploadPreview extends StatelessWidget {
  final Pen pen;
  final VoidCallback? onTap;

  String? get displayURL {
    if (pen.outputPath.isNotEmpty == true) {
      return pen.outputPath;
    } else if (pen.uploadPath.isNotEmpty == true) {
      return pen.uploadPath;
    }
    return pen.localPath;
  }

  bool get isLocal {
    return pen.outputPath.isEmpty == true &&
        pen.uploadPath.isEmpty == true &&
        pen.localPath?.isNotEmpty == true;
  }

  UploadType get displayType {
    if (pen.uploadPath.isNotEmpty || pen.outputPath.isNotEmpty) {
      return pen.type;
    }
    return pen.localType ?? UploadType.none;
  }

  Widget get displayChild {
    switch (displayType) {
      case .none:
        return buildBlank();
      case .image:
        return buildImagePreview();
      case .video:
        return buildVideoPreview();
    }
  }

  const UploadPreview({super.key, required this.pen, this.onTap});

  Widget buildBlank() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        alignment: .center,
        width: double.infinity,
        child: AppTips.icon("未选择文件", type: .blank),
      ),
    );
  }

  Widget buildImagePreview() {
    if (displayURL == null) return buildBlank();
    if (isLocal) return Image.file(File(displayURL!));
    return Image.network(displayURL!);
  }

  Widget buildVideoPreview() {
    if (displayURL == null) return buildBlank();
    return Stack(
      alignment: .center,
      children: [
        VideoPreview(url: displayURL!, isLocal: isLocal),
        Icon(
          Icons.play_circle,
          size: UIConstants.uiSize.xxxl,
          color: Colors.white,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        clipBehavior: .antiAlias,
        padding: .all(UIConstants.gapSize.md),
        decoration: BoxDecoration(
          color: Colors.white,
          border: .all(width: 2, color: Colors.grey.shade200),
          borderRadius: .all(.circular(UIConstants.borderRadius)),
        ),
        child: displayChild,
      ),
    );
  }
}
