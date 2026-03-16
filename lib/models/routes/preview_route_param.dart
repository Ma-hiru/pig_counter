import 'package:pig_counter/models/api/task.dart';

class PreviewRouteParam {
  final UploadType type;
  final String url;
  final bool isLocal;

  const PreviewRouteParam({
    required this.type,
    required this.url,
    required this.isLocal,
  });
}
