import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pig_counter/constants/api.dart';
import 'package:pig_counter/models/api/response.dart';
import 'package:pig_counter/models/api/user.dart';
import 'package:pig_counter/utils/fetch.dart';

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

  Future<ResponseData<Null>> register({
    required String username,
    required String password,
    required String name,
    required String organization,
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
      "organization": organization,
      "admin": admin,
    };
    if (picture != null) {
      payload["picture"] = await MultipartFile.fromFile(
        picture.path,
        filename: picture.path.split('/').last,
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
