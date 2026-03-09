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

  void _updatePage() {
    _showPauseIcon = !controller.value.isPlaying;
    if (mounted) setState(() {});
  }

  void _autoHideControls() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _showControls = false;
        _updatePage();
      }
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
    final wasPlaying = controller.value.isPlaying;
    final pos = controller.value.position;
    // Remove the inline VideoPlayer first
    setState(() => _isFullscreen = true);
    // Wait one frame for the inline VideoPlayer to be fully unmounted,
    // then push the fullscreen route with a new VideoPlayer widget.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context)
          .push(
            PageRouteBuilder(
              opaque: true,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (_, _, _) => _FullscreenVideoPage(
                controller: controller,
                wasPlaying: wasPlaying,
                savedPosition: pos,
                rotationQuarterTurns: _rotationQuarterTurns,
                onRotationChanged: (v) => _rotationQuarterTurns = v,
              ),
            ),
          )
          .then((_) {
            // Wait one frame for the fullscreen VideoPlayer to be unmounted,
            // then restore the inline VideoPlayer.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() => _isFullscreen = false);
                // Force frame refresh for the new texture
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && controller.value.isInitialized) {
                    controller.seekTo(controller.value.position);
                  }
                });
              }
            });
          });
    });
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
                _ControlButton(
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
      child: _isFullscreen
          ? const ColoredBox(color: Colors.black)
          : Stack(
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

class _FullscreenVideoPage extends StatefulWidget {
  final int rotationQuarterTurns;
  final VideoPlayerController controller;
  final ValueChanged<int> onRotationChanged;
  final bool wasPlaying;
  final Duration savedPosition;

  const _FullscreenVideoPage({
    required this.controller,
    required this.rotationQuarterTurns,
    required this.onRotationChanged,
    required this.wasPlaying,
    required this.savedPosition,
  });

  @override
  State<_FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<_FullscreenVideoPage> {
  bool _showControls = true;
  bool _showPauseIcon = false;
  late int _rotationQuarterTurns;

  VideoPlayerController get _ctl => widget.controller;

  void _onUpdate() {
    if (mounted) {
      _showPauseIcon = !_ctl.value.isPlaying;
      setState(() {});
    }
  }

  void _exit() {
    // Pause before exiting so the inline player can resume from correct state
    if (_ctl.value.isPlaying) _ctl.pause();
    Navigator.of(context).pop();
  }

  void _autoHideControls() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  void _handleVideoTap() {
    if (!_showControls) _showControls = true;
    _autoHideControls();
    _ctl.value.isPlaying ? _ctl.pause() : _ctl.play();
  }

  void _rotate() {
    setState(() {
      _rotationQuarterTurns = (_rotationQuarterTurns + 1) % 4;
      widget.onRotationChanged(_rotationQuarterTurns);
    });
  }

  void _seekTo(double progress) {
    final duration = _ctl.value.duration;
    _ctl.seekTo(
      Duration(milliseconds: (progress * duration.inMilliseconds).toInt()),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  void initState() {
    super.initState();
    _rotationQuarterTurns = widget.rotationQuarterTurns;
    _showPauseIcon = !widget.wasPlaying;
    SystemChrome.setEnabledSystemUIMode(.immersiveSticky);
    _ctl.addListener(_onUpdate);
    // After the fullscreen VideoPlayer creates a new texture,
    // seek to the saved position to force frame display,
    // then resume playback if it was playing.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _ctl.seekTo(widget.savedPosition).then((_) {
        if (mounted && widget.wasPlaying) _ctl.play();
      });
    });
  }

  @override
  void dispose() {
    _ctl.removeListener(_onUpdate);
    SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final position = _ctl.value.position;
    final duration = _ctl.value.duration;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exit();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: .center,
          children: [
            Center(
              child: RotatedBox(
                quarterTurns: _rotationQuarterTurns,
                child: AspectRatio(
                  aspectRatio: _ctl.value.isInitialized
                      ? _ctl.value.aspectRatio
                      : 16 / 9,
                  child: GestureDetector(
                    onTap: _handleVideoTap,
                    child: _ctl.value.isInitialized
                        ? VideoPlayer(_ctl)
                        : Center(child: AppTips.icon(type: .loading)),
                  ),
                ),
              ),
            ),
            if (_showControls || _showPauseIcon)
              GestureDetector(
                onTap: _handleVideoTap,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    shape: .circle,
                  ),
                  padding: .all(UIConstants.gapSize.md),
                  child: Icon(
                    _ctl.value.isPlaying ? LucideIcons.pause : LucideIcons.play,
                    color: Colors.white,
                    size: UIConstants.uiSize.xl,
                  ),
                ),
              ),
            if (_showControls)
              Positioned(
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
                          overlayColor: ColorConstants.themeColor.withValues(
                            alpha: 0.3,
                          ),
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
                          _ControlButton(
                            icon: LucideIcons.rotate_cw,
                            onTap: _rotate,
                          ),
                          SizedBox(width: UIConstants.gapSize.md),
                          _ControlButton(
                            icon: LucideIcons.minimize,
                            onTap: _exit,
                          ),
                        ],
                      ),
                    ],
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
      child: Icon(icon, color: Colors.white, size: UIConstants.uiSize.md),
    );
  }
}
