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
