import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/err.dart';
import 'package:pig_counter/models/routes/upload_route_param.dart';
import 'package:pig_counter/pages/upload/upload_actions.dart';
import 'package:pig_counter/pages/upload/upload_preview.dart';
import 'package:pig_counter/utils/toast.dart';

import '../../constants/ui.dart';
import '../../widgets/header/navigator_app_bar.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  UploadRouteParam? latestData;

  UploadRouteParam getRouteParam() {
    return ModalRoute.of(context)?.settings.arguments as UploadRouteParam? ??
        UploadRouteParam.empty();
  }

  Future fetchLatestData() async {
    try {
      final routeParam = getRouteParam();
      final response = await API.Task.detail(routeParam.task.id);

      final task = response.data;
      final building = task.buildings.firstWhere(
        (b) => b.id == routeParam.building.id,
      );
      final pen = building.pens.firstWhere((p) => p.id == routeParam.pen.id);

      latestData = UploadRouteParam(task: task, building: building, pen: pen);
    } on DioException {
      Toast.showToast(.error(ErrMsgConstants.networkError));
    } catch (err) {
      if (err == ErrConstants.responseFormatError) {
        Toast.showToast(.error(ErrMsgConstants.responseFormatError));
      } else {
        Toast.showToast(.error("数据错误"));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLatestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigatorAppbar(
        title:
            "${latestData?.building.name ?? "?"} - ${latestData?.pen.name ?? "?"}",
      ),
      body: Container(
        width: .infinity,
        height: .infinity,
        color: ColorConstants.backgroundColor,
        padding: const .symmetric(
          horizontal: UIConstants.contentPaddingFromSides,
        ),
        child: Column(children: [const UploadPreview(), const UploadActions()]),
      ),
    );
  }
}
