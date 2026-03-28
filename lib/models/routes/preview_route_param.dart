import 'package:pig_counter/models/api/task.dart';

class PreviewRouteParam {
  final UploadType type;
  final String url;
  final bool isLocal;
  final Duration startPosition;
  final bool autoPlay;
  final int rotationQuarterTurns;

  const PreviewRouteParam({
    required this.type,
    required this.url,
    required this.isLocal,
    this.startPosition = Duration.zero,
    this.autoPlay = true,
    this.rotationQuarterTurns = 0,
  });
}
