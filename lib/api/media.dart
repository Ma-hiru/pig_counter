import 'package:dio/dio.dart';
import 'package:pig_counter/constants/api.dart';
import 'package:pig_counter/models/api/media.dart';
import 'package:pig_counter/models/api/response.dart';
import 'package:pig_counter/utils/fetch.dart';

class MediaAPI {
  Future<ResponseData<InventoryMediaUploadResult>> uploadBound({
    required int taskId,
    required int penId,
    required List<String> filePaths,
    String? captureTime,
  }) async {
    final files = await Future.wait(
      filePaths.map(
        (path) => MultipartFile.fromFile(path, filename: path.split('/').last),
      ),
    );

    return fetch.post(
      APIConstants.media.upload,
      InventoryMediaUploadResult.fromJSON,
      data: FormData.fromMap({
        "taskId": taskId,
        "penId": penId,
        if (captureTime != null && captureTime.isNotEmpty)
          "captureTime": captureTime,
        "files": files,
      }),
      options: Options(contentType: "multipart/form-data"),
    );
  }

  Future<ResponseData<InventoryMediaUploadResult>> uploadUnbound({
    required int taskId,
    required List<String> filePaths,
    String? captureTime,
  }) async {
    final files = await Future.wait(
      filePaths.map(
        (path) => MultipartFile.fromFile(path, filename: path.split('/').last),
      ),
    );

    return fetch.post(
      APIConstants.media.uploadUnbound,
      InventoryMediaUploadResult.fromJSON,
      data: FormData.fromMap({
        "taskId": taskId,
        if (captureTime != null && captureTime.isNotEmpty)
          "captureTime": captureTime,
        "files": files,
      }),
      options: Options(contentType: "multipart/form-data"),
    );
  }

  Future<ResponseData<List<InventoryMediaItem>>> library({
    required int penId,
    required String date,
  }) {
    return fetch.get(
      APIConstants.media.library,
      (data) => ((data ?? []) as List<dynamic>)
          .map(InventoryMediaItem.fromJSON)
          .toList(),
      queryParameters: {"penId": penId, "date": date},
    );
  }

  Future<ResponseData<Null>> confirm(List<int> mediaIds, {bool status = true}) {
    return fetch.post(
      APIConstants.media.confirm,
      null,
      data: {"mediaIds": mediaIds, "status": status},
    );
  }

  Future<ResponseData<Null>> unlock(List<int> mediaIds, {bool status = true}) {
    return fetch.post(
      APIConstants.media.unlock,
      null,
      data: {"mediaIds": mediaIds, "status": status},
    );
  }

  Future<ResponseData<Null>> manualCount({
    required int mediaId,
    required int manualCount,
  }) {
    return fetch.post(
      APIConstants.media.manualCount,
      null,
      data: {"mediaId": mediaId, "manualCount": manualCount},
    );
  }

  Future<ResponseData<Null>> delete(int mediaId) {
    return fetch.delete(APIConstants.media.delete(mediaId), null);
  }
}
