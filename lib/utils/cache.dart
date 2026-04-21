import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as provider;
import 'package:pig_counter/models/api/task.dart';

class TaskCache {
  static Directory? _directory;

  static Future<Directory> _dir() async {
    if (_directory != null) return _directory!;

    final base = await provider.getTemporaryDirectory();
    final dir = Directory(path.join(base.path, "media_cache"));
    final exists = await dir.exists();
    if (!exists) await dir.create(recursive: true);

    return _directory = dir;
  }

  static String _buildFilename({
    required int taskID,
    required int buildingID,
    required int penID,
    required UploadType type,
  }) {
    return "${taskID}_${buildingID}_${penID}_${type.name}";
  }

  static TaskCacheFilenameParseResult? _parseFilename(String filePath) {
    final filename = path.basename(filePath);
    final parts = filename.split("_");
    if (parts.length != 4) return null;

    final taskID = int.tryParse(parts[0]);
    final buildingID = int.tryParse(parts[1]);
    final penID = int.tryParse(parts[2]);
    final type = parts[3];

    if (taskID == null || buildingID == null || penID == null) return null;

    return TaskCacheFilenameParseResult(
      taskID: taskID,
      buildingID: buildingID,
      penID: penID,
      type: UploadTypeExt.fromName(type),
    );
  }

  static Future<List<String>> _buildFastCheckList({
    required int taskID,
    required int buildingID,
    required int penID,
  }) async {
    final dir = (await _dir()).path;
    return UploadType.values
        .map(
          (type) => path.join(
            dir,
            _buildFilename(
              taskID: taskID,
              buildingID: buildingID,
              penID: penID,
              type: type,
            ),
          ),
        )
        .toList();
  }

  static Future<String> save({
    required int taskID,
    required int buildingID,
    required int penID,
    required String uri,
    required UploadType type,
  }) async {
    final newPath = path.join(
      (await _dir()).path,
      _buildFilename(
        taskID: taskID,
        buildingID: buildingID,
        penID: penID,
        type: type,
      ),
    );
    await File(uri).copy(newPath);
    if (kDebugMode) {
      print("Saved cache file: $newPath");
    }
    return newPath;
  }

  static Future<List<TaskCacheCheckResult>> check({
    required int taskID,
    required int buildingID,
    required int penID,
  }) async {
    final checkList = await _buildFastCheckList(
      taskID: taskID,
      buildingID: buildingID,
      penID: penID,
    );
    final List<TaskCacheCheckResult> result = [];

    for (final file in checkList.map(File.new)) {
      if (await file.exists()) {
        result.add(
          TaskCacheCheckResult(file.path, _parseFilename(file.path)!.type),
        );
      }
    }

    return result;
  }

  static Future<TaskCacheCheckResult?> checkOne({
    required int taskID,
    required int buildingID,
    required int penID,
  }) async {
    final checkResultList = await check(
      taskID: taskID,
      buildingID: buildingID,
      penID: penID,
    );
    if (checkResultList.isEmpty) return null;
    return checkResultList.first;
  }

  static Future remove({
    required int taskID,
    required int buildingID,
    required int penID,
  }) async {
    final checkList = await _buildFastCheckList(
      taskID: taskID,
      buildingID: buildingID,
      penID: penID,
    );
    for (final file in checkList.map(File.new)) {
      if (await file.exists()) {
        if (kDebugMode) {
          print("Removing cache file: ${file.path}");
        }
        await file.delete();
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
  final int buildingID;
  final UploadType type;

  const TaskCacheFilenameParseResult({
    required this.taskID,
    required this.buildingID,
    required this.penID,
    required this.type,
  });
}
