import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class LoadingIcon extends StatefulWidget {
  final Duration duration;
  final double? size;

  const LoadingIcon({
    super.key,
    this.size,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<LoadingIcon> createState() => _LoadingIconState();
}

class _LoadingIconState extends State<LoadingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(angle: controller.value * 2 * pi, child: child);
      },
      child: Icon(LucideIcons.loader_circle, size: widget.size),
    );
  }
}
