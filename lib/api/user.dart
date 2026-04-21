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
      APIConstants.user.loginByAccount,
      UserProfile.fromJSON,
      data: {"username": username, "password": password},
    );
  }

  Future<ResponseData<dynamic>> signup({
    required String username,
    required String password,
    required String name,
    required String company,
    required File avatar,
  }) async {
    return fetch.post(
      APIConstants.user.signupByAccount,
      null,
      data: FormData.fromMap({
        "name": name,
        "username": username,
        "password": password,
        "company": company,
        "avatar": await MultipartFile.fromFile(
          avatar.path,
          filename: avatar.path.split('/').last,
        ),
      }),
      options: Options(contentType: "multipart/form-data"),
    );
  }

  Future<ResponseData<Null>> logout() {
    return fetch.post(APIConstants.user.logout, null);
  }

  Future<ResponseData<UserProfile>> detail(int id) {
    return fetch.get(APIConstants.user.loginByAccount, UserProfile.fromJSON);
  }
}
