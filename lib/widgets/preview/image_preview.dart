import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  final String url;
  final bool isLocal;

  const ImagePreview({super.key, required this.url, required this.isLocal});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: widget.isLocal
          ? Image.file(File(widget.url), fit: .cover)
          : Image.network(widget.url, fit: .cover),
    );
  }
}
