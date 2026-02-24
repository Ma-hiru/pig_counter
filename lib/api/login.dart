import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pig_counter/constants/api.dart';
import 'package:pig_counter/models/api/response.dart';
import 'package:pig_counter/models/api/user.dart';
import 'package:pig_counter/utils/fetch.dart';

Future<ResponseData<UserProfile>> loginByAccount({
  required String username,
  required String password,
}) {
  return fetch.post(
    APIConstants.loginByAccount,
    UserProfile.fromJson,
    data: {"username": username, "password": password},
  );
}

Future<ResponseData<dynamic>> signupByAccount({
  required String username,
  required String password,
  required String name,
  required String company,
  required File avatar,
}) async {
  return fetch.post(
    APIConstants.signupByAccount,
    null,
    data: FormData.fromMap({
      "username": username,
      "password": password,
      "name": name,
      "company": company,
      "avatar": await MultipartFile.fromFile(
        avatar.path,
        filename: avatar.path.split('/').last,
      ),
    }),
    options: Options(contentType: "multipart/form-data"),
  );
}
