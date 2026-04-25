import 'package:pig_counter/constants/api.dart';
import 'package:pig_counter/models/api/pen_overview.dart';
import 'package:pig_counter/models/api/response.dart';
import 'package:pig_counter/utils/fetch.dart';

class PenAPI {
  Future<ResponseData<PenInventoryOverview>> overview({
    required int penId,
    String? date,
    String? startDate,
    String? endDate,
    int? recentMediaLimit,
  }) {
    return fetch.get(
      APIConstants.pen.overview,
      PenInventoryOverview.fromJSON,
      queryParameters: {
        "penId": penId,
        "date": date?.isNotEmpty == true ? date : null,
        "startDate": startDate?.isNotEmpty == true ? startDate : null,
        "endDate": endDate?.isNotEmpty == true ? endDate : null,
        "recentMediaLimit": recentMediaLimit,
      },
    );
  }
}
