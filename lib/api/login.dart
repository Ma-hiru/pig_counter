import 'package:pig_counter/constants/http.dart';
import 'package:pig_counter/models/response.dart';
import 'package:pig_counter/models/user.dart';
import 'package:pig_counter/utils/fetch.dart';

Future<ResponseData<UserProfile>> loginByAccount() {
  return fetch.post(HTTPConstants.loginByAccount, UserProfile.fromJson);
}
