import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pig_counter/constants/ui.dart';

class ImagePreview extends StatefulWidget {
  final String url;
  final bool isLocal;

  const ImagePreview({super.key, required this.url, required this.isLocal});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  bool _isFullscreen = false;
  bool _showControls = true;
  int _rotationQuarterTurns = 0;
  OverlayEntry? _fullscreenOverlay;

  void _updatePage() {
    setState(() => _fullscreenOverlay?.markNeedsBuild());
  }

  void _rotate() {
    _rotationQuarterTurns = (_rotationQuarterTurns + 1) % 4;
    _updatePage();
  }

  void _toggleControls() {
    _showControls = !_showControls;
    _updatePage();
  }

  void _enterFullscreen() {
    _isFullscreen = true;
    _showControls = true;
    _fullscreenOverlay = OverlayEntry(builder: (_) => _buildFullscreenUI());
    SystemChrome.setEnabledSystemUIMode(.immersiveSticky);
    Overlay.of(context).insert(_fullscreenOverlay!);
    _updatePage();
  }

  void _exitFullscreen() {
    if (!_isFullscreen) return;
    _isFullscreen = false;
    _showControls = true;
    _fullscreenOverlay?.remove();
    _fullscreenOverlay = null;
    SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
    _updatePage();
  }

  Widget _buildFullscreenUI() {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exitFullscreen();
      },
      child: Material(
        color: Colors.black,
        child: GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            children: [
              Center(
                child: RotatedBox(
                  quarterTurns: _rotationQuarterTurns,
                  child: PhotoView(
                    imageProvider: widget.isLocal
                        ? FileImage(File(widget.url))
                        : NetworkImage(widget.url),
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
                    onTap: _exitFullscreen,
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
                          onTap: _exitFullscreen,
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

  @override
  void dispose() {
    _exitFullscreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _enterFullscreen,
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: widget.isLocal
            ? Image.file(File(widget.url), fit: .cover)
            : Image.network(widget.url, fit: .cover),
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
