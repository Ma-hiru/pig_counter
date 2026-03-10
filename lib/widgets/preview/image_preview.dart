import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/widgets/tips/tips.dart';

class ImagePreview extends StatelessWidget {
  final String url;
  final bool isLocal;
  final VoidCallback? onError;

  const ImagePreview({
    super.key,
    required this.url,
    required this.isLocal,
    this.onError,
  });

  void _enterFullscreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (_, _, _) =>
            _FullscreenImagePage(url: url, isLocal: isLocal),
      ),
    );
  }

  Widget buildError() {
    if (onError != null) Future.microtask(onError!);
    return AppTips.icon(text: "加载失败", type: .error);
  }

  Widget buildContent() {
    if (isLocal) {
      return Image.file(
        File(url),
        fit: .cover,
        errorBuilder: (_, _, _) => buildError(),
      );
    }
    return Image.network(
      url,
      fit: .cover,
      errorBuilder: (_, _, _) => buildError(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _enterFullscreen(context),
      child: AspectRatio(aspectRatio: 3 / 2, child: buildContent()),
    );
  }
}

class _FullscreenImagePage extends StatefulWidget {
  final String url;
  final bool isLocal;

  const _FullscreenImagePage({required this.url, required this.isLocal});

  @override
  State<_FullscreenImagePage> createState() => _FullscreenImagePageState();
}

class _FullscreenImagePageState extends State<_FullscreenImagePage> {
  bool _showControls = true;
  int _rotationQuarterTurns = 0;

  ImageProvider get _imageProvider =>
      widget.isLocal ? FileImage(File(widget.url)) : NetworkImage(widget.url);

  void _exit() => Navigator.of(context).pop();

  void _toggleControls() => setState(() => _showControls = !_showControls);

  void _rotate() =>
      setState(() => _rotationQuarterTurns = (_rotationQuarterTurns + 1) % 4);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exit();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            children: [
              Center(
                child: RotatedBox(
                  quarterTurns: _rotationQuarterTurns,
                  child: PhotoView(
                    imageProvider: _imageProvider,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 3,
                  ),
                ),
              ),
              if (_showControls)
                Positioned(
                  top: UIConstants.gapSize.xl,
                  left: UIConstants.gapSize.xl,
                  child: _ControlButton(
                    icon: LucideIcons.arrow_left,
                    onTap: _exit,
                  ),
                ),
              if (_showControls)
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: .bottomCenter,
                        end: .topCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                    padding: .symmetric(
                      horizontal: UIConstants.gapSize.md,
                      vertical: UIConstants.gapSize.md,
                    ),
                    child: Row(
                      mainAxisAlignment: .end,
                      spacing: UIConstants.gapSize.md,
                      children: [
                        _ControlButton(
                          icon: LucideIcons.rotate_cw,
                          onTap: _rotate,
                        ),
                        _ControlButton(
                          icon: LucideIcons.minimize,
                          onTap: _exit,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
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
