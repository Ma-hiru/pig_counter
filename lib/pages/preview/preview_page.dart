import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/models/routes/preview_route_param.dart';
import 'package:video_player/video_player.dart';

import '../../constants/ui.dart';
import '../../widgets/tips/tips.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  PreviewRouteParam? _routeParam;
  VideoPlayerController? _controller;
  bool _routeLoaded = false;
  bool _showControls = true;
  bool _showPauseIcon = false;
  int _rotationQuarterTurns = 0;
  Timer? _controlsTimer;

  PreviewRouteParam? getRouteParam() =>
      ModalRoute.of(context)?.settings.arguments as PreviewRouteParam?;

  VideoPlayerController? get _ctl => _controller;

  bool get _hasValidVideo =>
      _routeParam?.type == .video && (_routeParam?.url.isNotEmpty == true);

  void _updatePage() {
    final ctl = _ctl;
    if (ctl == null || !mounted) return;
    _showPauseIcon = !ctl.value.isPlaying;
    setState(() {});
  }

  void _autoHideControls() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      _showControls = false;
      _updatePage();
    });
  }

  void _handleVideoTap() {
    final ctl = _ctl;
    if (ctl == null || !ctl.value.isInitialized) return;
    if (!_showControls) {
      _showControls = true;
    }
    _autoHideControls();
    ctl.value.isPlaying ? ctl.pause() : ctl.play();
    _updatePage();
  }

  void _rotate() {
    _rotationQuarterTurns = (_rotationQuarterTurns + 1) % 4;
    _updatePage();
  }

  void _seekTo(double progress) {
    final ctl = _ctl;
    if (ctl == null || !ctl.value.isInitialized) return;
    final duration = ctl.value.duration;
    ctl.seekTo(
      Duration(milliseconds: (progress * duration.inMilliseconds).toInt()),
    );
  }

  void _exit() {
    final ctl = _ctl;
    if (ctl?.value.isPlaying == true) ctl!.pause();
    Navigator.of(context).pop();
  }

  Future<void> _initVideoController() async {
    final param = _routeParam;
    if (param == null || !_hasValidVideo) return;
    final ctl = param.isLocal
        ? VideoPlayerController.file(File(param.url))
        : VideoPlayerController.networkUrl(Uri.parse(param.url));
    _controller = ctl;
    _rotationQuarterTurns = param.rotationQuarterTurns % 4;
    ctl
      ..setLooping(true)
      ..setVolume(0)
      ..addListener(_updatePage);

    try {
      await ctl.initialize();
      if (!mounted) return;
      if (param.startPosition > Duration.zero) {
        await ctl.seekTo(param.startPosition);
      }
      if (param.autoPlay) {
        await ctl.play();
      }
      _updatePage();
    } catch (_) {
      if (mounted) setState(() {});
    }
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  Widget _buildBottomControls(VideoPlayerController ctl) {
    final position = ctl.value.position;
    final duration = ctl.value.duration;
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
                _ControlButton(icon: LucideIcons.minimize, onTap: _exit),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(.immersiveSticky);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_routeLoaded) return;
    _routeLoaded = true;
    _routeParam = getRouteParam();
    _initVideoController();
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _controller?.removeListener(_updatePage);
    _controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctl = _ctl;

    if (!_hasValidVideo) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: AppTips.icon(text: "预览参数错误", type: .error),
            ),
            Positioned(
              top: UIConstants.gapSize.xl,
              left: UIConstants.gapSize.xl,
              child: _ControlButton(icon: LucideIcons.arrow_left, onTap: _exit),
            ),
          ],
        ),
      );
    }

    final isReady = ctl != null && ctl.value.isInitialized;
    return Scaffold(
      backgroundColor: Colors.black,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _exit();
        },
        child: Stack(
          alignment: .center,
          children: [
            Center(
              child: isReady
                  ? RotatedBox(
                      quarterTurns: _rotationQuarterTurns,
                      child: AspectRatio(
                        aspectRatio: ctl.value.aspectRatio,
                        child: GestureDetector(
                          onTap: _handleVideoTap,
                          child: VideoPlayer(ctl),
                        ),
                      ),
                    )
                  : AppTips.icon(type: .loading),
            ),
            if (isReady && (_showControls || _showPauseIcon))
              GestureDetector(
                onTap: _handleVideoTap,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    shape: .circle,
                  ),
                  padding: .all(UIConstants.gapSize.md),
                  child: Icon(
                    ctl.value.isPlaying ? LucideIcons.pause : LucideIcons.play,
                    color: Colors.white,
                    size: UIConstants.uiSize.xl,
                  ),
                ),
              ),
            if (isReady && _showControls) _buildBottomControls(ctl),
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
      child: Container(
        padding: .all(UIConstants.gapSize.sm),
        decoration: const BoxDecoration(color: Colors.black38, shape: .circle),
        child: Icon(icon, color: Colors.white, size: UIConstants.uiSize.md),
      ),
    );
  }
}
