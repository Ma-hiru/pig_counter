import 'package:dio/dio.dart';
import 'package:pig_counter/constants/api.dart';
import 'package:pig_counter/models/api/dead_pig.dart';
import 'package:pig_counter/models/api/response.dart';
import 'package:pig_counter/utils/fetch.dart';

String _fileNameFromPath(String path) {
  final parts = path.split(RegExp(r'[\\/]'));
  return parts.isEmpty ? path : parts.last;
}

class DeadPigAPI {
  Future<ResponseData<DeadPigReport>> create({
    required int penId,
    required String reportDate,
    required int quantity,
    String? captureTime,
    String? remark,
    required List<String> filePaths,
  }) async {
    final files = await Future.wait(
      filePaths.map(
        (path) => MultipartFile.fromFile(path, filename: _fileNameFromPath(path)),
      ),
    );
    return fetch.post(
      APIConstants.deadPig.create,
      DeadPigReport.fromJSON,
      data: FormData.fromMap({
        "penId": penId,
        "reportDate": reportDate,
        "quantity": quantity,
        if (captureTime != null && captureTime.isNotEmpty)
          "captureTime": captureTime,
        if (remark != null && remark.isNotEmpty) "remark": remark,
        "files": files,
      }),
      options: Options(contentType: "multipart/form-data"),
    );
  }

  Future<ResponseData<List<DeadPigReport>>> daily({
    required int penId,
    required String date,
  }) {
    return fetch.get(
      APIConstants.deadPig.daily,
      (data) =>
          ((data ?? []) as List<dynamic>).map(DeadPigReport.fromJSON).toList(),
      queryParameters: {"penId": penId, "date": date},
    );
  }
}
