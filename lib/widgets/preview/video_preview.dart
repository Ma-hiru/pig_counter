import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/widgets/loading/loading.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  final String url;
  final bool isLocal;

  const VideoPreview({super.key, required this.url, required this.isLocal});

  @override
  State<VideoPreview> createState() => VideoPreviewState();
}

class VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController controller;
  bool _showControls = false;
  bool _showPauseIcon = false;
  bool _isFullscreen = false;
  int _rotationQuarterTurns = 0;
  OverlayEntry? _fullscreenOverlay;

  void _updatePage() {
    _showPauseIcon = !controller.value.isPlaying;
    setState(() => _fullscreenOverlay?.markNeedsBuild());
  }

  void _autoHideControls() {
    Future.delayed(const Duration(seconds: 5), () {
      _showControls = false;
      _updatePage();
    });
  }

  void _togglePlay() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void _handleVideoTap() {
    if (!_showControls) {
      _showControls = true;
    }
    _autoHideControls();
    _togglePlay();
    _updatePage();
  }

  void _rotate() {
    _rotationQuarterTurns = (_rotationQuarterTurns + 1) % 4;
    _updatePage();
  }

  void _seekTo(double progress) {
    final duration = controller.value.duration;
    controller.seekTo(
      Duration(milliseconds: (progress * duration.inMilliseconds).toInt()),
    );
  }

  void _enterFullscreen() {
    _isFullscreen = true;
    _fullscreenOverlay = OverlayEntry(builder: (_) => _buildFullscreenUI());
    SystemChrome.setEnabledSystemUIMode(.immersiveSticky);
    Overlay.of(context).insert(_fullscreenOverlay!);
    _updatePage();
  }

  void _exitFullscreen() {
    if (!_isFullscreen) return;
    _isFullscreen = false;
    _fullscreenOverlay?.remove();
    _fullscreenOverlay = null;
    SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
    _updatePage();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: _handleVideoTap,
      child: Container(
        decoration: const BoxDecoration(color: Colors.black38, shape: .circle),
        padding: .all(UIConstants.gapSize.md),
        child: Icon(
          controller.value.isPlaying ? LucideIcons.pause : LucideIcons.play,
          color: Colors.white,
          size: UIConstants.uiSize.md,
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    final position = controller.value.position;
    final duration = controller.value.duration;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return Positioned(
      left: 0,
      right: 0,
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
          vertical: UIConstants.gapSize.md,
          horizontal: UIConstants.gapSize.md,
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            SliderTheme(
              data: SliderThemeData(
                padding: .symmetric(
                  horizontal: 0,
                  vertical: UIConstants.gapSize.sm,
                ),
                trackHeight: UIConstants.uiSize.xs,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: UIConstants.uiSize.xs,
                ),
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: UIConstants.uiSize.xs,
                ),
                activeTrackColor: ColorConstants.themeColor,
                inactiveTrackColor: Colors.white38,
                thumbColor: ColorConstants.themeColor,
                overlayColor: ColorConstants.themeColor.withValues(alpha: 0.3),
              ),
              child: Slider(
                value: progress.clamp(0.0, 1.0),
                onChanged: _seekTo,
              ),
            ),
            Row(
              children: [
                Text(
                  '${_formatDuration(position)} / ${_formatDuration(duration)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: FontConstants.fontSize.xs,
                    fontFamily: FontConstants.fontFamily,
                    fontWeight: .w500,
                  ),
                ),
                const Spacer(),
                _ControlButton(icon: LucideIcons.rotate_cw, onTap: _rotate),
                SizedBox(width: UIConstants.gapSize.md),
                _isFullscreen
                    ? _ControlButton(
                        icon: LucideIcons.minimize,
                        onTap: _exitFullscreen,
                      )
                    : _ControlButton(
                        icon: LucideIcons.maximize,
                        onTap: _enterFullscreen,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullscreenUI() {
    if (!controller.value.isInitialized) {
      return Material(
        color: Colors.black,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(child: AppTips.icon(type: .loading)),
        ),
      );
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exitFullscreen();
      },
      child: Material(
        color: Colors.black,
        child: Stack(
          alignment: .center,
          children: [
            Center(
              child: RotatedBox(
                quarterTurns: _rotationQuarterTurns,
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: GestureDetector(
                    onTap: _handleVideoTap,
                    child: VideoPlayer(controller),
                  ),
                ),
              ),
            ),
            if (_showControls || _showPauseIcon) _buildPlayPauseButton(),
            if (_showControls) _buildBottomControls(),
            if (_showControls)
              Positioned(
                top: UIConstants.gapSize.xl,
                left: UIConstants.gapSize.xl,
                child: _ControlButton(
                  icon: LucideIcons.arrow_left,
                  onTap: _exitFullscreen,
                ),
              ),
          ],
        ),
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
      if (mounted) setState(() {});
    });
    controller.setLooping(true);
    controller.addListener(_updatePage);
  }

  @override
  void dispose() {
    _exitFullscreen();
    controller.removeListener(_updatePage);
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

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        alignment: .center,
        children: [
          RotatedBox(
            quarterTurns: _rotationQuarterTurns,
            child: GestureDetector(
              onTap: _handleVideoTap,
              child: VideoPlayer(controller),
            ),
          ),
          if (_showControls || _showPauseIcon) _buildPlayPauseButton(),
          if (_showControls) _buildBottomControls(),
        ],
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
      child: Icon(icon, color: Colors.white, size: UIConstants.uiSize.md),
    );
  }
}
