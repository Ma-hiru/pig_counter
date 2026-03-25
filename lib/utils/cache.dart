import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pig_counter/models/api/task.dart';

class TaskCache {
  static Future<Directory> _dir() async {
    final base = await getTemporaryDirectory();
    final dir = Directory(join(base.path, "media_cache"));
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  static String _buildFilename({
    required int taskID,
    required int penID,
    required UploadType type,
  }) {
    return "${taskID}_${penID}_${type.name}";
  }

  static TaskCacheFilenameParseResult? _parseFilename(String filePath) {
    final filename = basename(filePath);
    final parts = filename.split("_");
    if (parts.length != 3) return null;

    final taskID = int.tryParse(parts[0]);
    final penID = int.tryParse(parts[1]);
    final type = parts[2];

    if (taskID == null || penID == null) return null;

    return TaskCacheFilenameParseResult(
      taskID: taskID,
      penID: penID,
      type: UploadTypeExt.fromName(type),
    );
  }

  static Future<List<String>> _buildCheckPaths({
    required int taskID,
    required int penID,
  }) async {
    final dir = (await _dir()).path;
    return UploadType.values
        .map(
          (type) => join(
            dir,
            _buildFilename(taskID: taskID, penID: penID, type: type),
          ),
        )
        .toList();
  }

  static Future<String> save({
    required int taskID,
    required int penID,
    required String path,
    required UploadType type,
  }) async {
    final newPath = join(
      (await _dir()).path,
      _buildFilename(taskID: taskID, penID: penID, type: type),
    );
    await File(path).copy(newPath);
    if (kDebugMode) {
      print("Saved cache file: $newPath");
    }
    return newPath;
  }

  static Future<List<TaskCacheCheckResult>> check({
    required int taskID,
    required int penID,
  }) async {
    final checkList = await _buildCheckPaths(taskID: taskID, penID: penID);
    final List<TaskCacheCheckResult> result = [];

    for (final file in checkList.map(File.new)) {
      if (file.existsSync()) {
        result.add(
          TaskCacheCheckResult(file.path, _parseFilename(file.path)!.type),
        );
      }
    }

    return result;
  }

  static Future<TaskCacheCheckResult?> checkOne({
    required int taskID,
    required int penID,
  }) async {
    final checkResultList = await check(taskID: taskID, penID: penID);
    if (checkResultList.isEmpty) return null;
    return checkResultList.first;
  }

  static Future remove({required int taskID, required int penID}) async {
    final checkList = await _buildCheckPaths(taskID: taskID, penID: penID);
    for (final file in checkList.map(File.new)) {
      if (file.existsSync()) {
        if (kDebugMode) {
          print("Removing cache file: ${file.path}");
        }
        file.deleteSync();
      }
    }
  }

  static Future<int> totalSize() async {
    int total = 0;
    for (final file in (await _dir()).listSync()) {
      try {
        if (file is File) total += file.lengthSync();
      } catch (err) {
        if (kDebugMode) print("Failed to get file size for ${file.path}: $err");
      }
    }
    return total;
  }

  static Future<int> clear() async {
    int count = 0;
    for (final file in (await _dir()).listSync()) {
      if (file is File) {
        file.deleteSync();
        count++;
      }
    }
    return count;
  }

  static Future<int> limitSize(int limit) async {
    final currentSize = await totalSize();
    final removeSize = currentSize - limit;
    if (removeSize <= 0) return 0;

    final entries = (await _dir()).listSync();
    final sortFiles = entries.whereType<File>().toList()
      ..sort((a, b) {
        final aAccessed = a.statSync().accessed;
        final bAccessed = b.statSync().accessed;
        return aAccessed.compareTo(bAccessed);
      });

    var removedSize = 0;
    for (final file in sortFiles) {
      final fileSize = file.lengthSync();
      file.deleteSync();
      removedSize += fileSize;
      if (removedSize >= removeSize) break;
    }

    return removedSize;
  }
}

class TaskCacheCheckResult {
  final String path;
  final UploadType type;

  const TaskCacheCheckResult(this.path, this.type);
}

class TaskCacheFilenameParseResult {
  final int taskID;
  final int penID;
  final UploadType type;

  const TaskCacheFilenameParseResult({
    required this.taskID,
    required this.penID,
    required this.type,
  });
}
