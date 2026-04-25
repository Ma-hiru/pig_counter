import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pig_counter/constants/api.dart';
import 'package:pig_counter/models/api/response.dart';
import 'package:pig_counter/models/api/user.dart';
import 'package:pig_counter/utils/fetch.dart';

String _fileNameFromPath(String path) {
  final parts = path.split(RegExp(r'[\\/]'));
  return parts.isEmpty ? path : parts.last;
}

class UserAPI {
  Future<ResponseData<UserProfile>> login({
    required String username,
    required String password,
  }) {
    return fetch.post(
      APIConstants.user.login,
      UserProfile.fromJSON,
      data: {"username": username, "password": password},
    );
  }

  Future<ResponseData<UserAuthSession>> refresh({
    required String refreshToken,
  }) {
    return fetch.post(
      APIConstants.user.refresh,
      UserAuthSession.fromJSON,
      data: {"refreshToken": refreshToken},
    );
  }

  Future<ResponseData<Null>> register({
    required String username,
    required String password,
    required String name,
    String sex = "未知",
    String phone = "",
    bool admin = false,
    File? picture,
  }) async {
    final payload = <String, dynamic>{
      "name": name,
      "username": username,
      "password": password,
      "sex": sex,
      "phone": phone,
      "admin": admin,
    };
    if (picture != null) {
      payload["picture"] = await MultipartFile.fromFile(
        picture.path,
        filename: _fileNameFromPath(picture.path),
      );
    }

    return fetch.post(
      APIConstants.user.register,
      null,
      data: FormData.fromMap(payload),
      options: Options(contentType: "multipart/form-data"),
    );
  }

  Future<ResponseData<Null>> logout() {
    return fetch.post(APIConstants.user.logout, null, data: {});
  }

  Future<ResponseData<UserProfile>> detail(int id) {
    return fetch.get(APIConstants.user.detail(id), UserProfile.fromJSON);
  }
}
