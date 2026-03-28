import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/routes.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/routes/preview_route_param.dart';
import 'package:video_player/video_player.dart';

import '../tips/tips.dart';

class VideoPreview extends StatefulWidget {
  final String url;
  final bool isLocal;

  const VideoPreview({super.key, required this.url, required this.isLocal});

  @override
  State<VideoPreview> createState() => VideoPreviewState();
}

class VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController controller;

  Future<void> _enterPreviewPage() async {
    final pos = controller.value.position;

    if (controller.value.isPlaying) {
      await controller.pause();
    }

    if (!mounted) return;
    await Navigator.pushNamed(
      context,
      RoutesPathConstants.preview,
      arguments: PreviewRouteParam(
        type: .video,
        url: widget.url,
        isLocal: widget.isLocal,
        startPosition: pos,
        autoPlay: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = widget.isLocal
        ? VideoPlayerController.file(File(widget.url))
        : VideoPlayerController.networkUrl(Uri.parse(widget.url));
    controller.initialize().then((_) {
      if (!mounted) return;
      controller.pause();
      setState(() {});
    });
    controller.setVolume(0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: AppTips.icon(type: .loading)),
      );
    }

    return GestureDetector(
      onTap: _enterPreviewPage,
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          alignment: .center,
          children: [
            VideoPlayer(controller),
            Positioned.fill(child: ColoredBox(color: Colors.black26)),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black38,
                shape: .circle,
              ),
              padding: .all(UIConstants.gapSize.md),
              child: Icon(
                LucideIcons.play,
                color: Colors.white,
                size: UIConstants.uiSize.lg,
              ),
            ),
            Positioned(
              right: UIConstants.gapSize.md,
              bottom: UIConstants.gapSize.md,
              child: _ControlButton(
                icon: LucideIcons.maximize,
                onTap: _enterPreviewPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: .all(UIConstants.gapSize.sm),
        decoration: const BoxDecoration(color: Colors.black38, shape: .circle),
        child: Icon(icon, color: Colors.white, size: UIConstants.uiSize.md),
      ),
    );
  }
}
