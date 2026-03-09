import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/err.dart';
import 'package:pig_counter/models/routes/upload_route_param.dart';
import 'package:pig_counter/pages/upload/upload_actions.dart';
import 'package:pig_counter/pages/upload/upload_options.dart';
import 'package:pig_counter/pages/upload/upload_preview.dart';
import 'package:pig_counter/utils/toast.dart';
import 'package:pig_counter/widgets/loading/loading.dart';

import '../../constants/ui.dart';
import '../../stores/settings.dart';
import '../../widgets/header/navigator_app_bar.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final SettingsController settingsController = Get.find<SettingsController>();
  UploadRouteParam? latestData;
  UploadOptions? uploadOptions;

  UploadRouteParam getRouteParam() {
    return ModalRoute.of(context)?.settings.arguments as UploadRouteParam? ??
        UploadRouteParam.empty();
  }

  Future fetchLatestData() async {
    if (kDebugMode) return setState(() => latestData = getRouteParam());
    try {
      final routeParam = getRouteParam();
      final response = await API.Task.detail(routeParam.task.id);

      final task = response.data;
      final building = task.buildings.firstWhere(
        (b) => b.id == routeParam.building.id,
      );
      final pen = building.pens.firstWhere((p) => p.id == routeParam.pen.id);
      setState(() {
        latestData = UploadRouteParam(task: task, building: building, pen: pen);
      });
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

  Widget buildContent() {
    if (latestData != null && uploadOptions != null) {
      return Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          UploadPreview(pen: latestData!.pen),
          UploadActions(
            pen: latestData!.pen,
            uploadOptions: uploadOptions!,
            onChange: (pen) {
              setState(() {
                latestData = latestData!.copyWith(pen: pen);
              });
            },
          ),
        ],
      );
    }
    return AppTips.icon("正在加载", type: .loading);
  }

  @override
  void initState() {
    super.initState();
    uploadOptions = UploadOptions(settingsController: settingsController);
    Future.microtask(fetchLatestData);
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
        padding: .symmetric(
          horizontal: UIConstants.contentPaddingFromSides,
          vertical: UIConstants.gapSize.md,
        ),
        child: buildContent(),
      ),
    );
  }
}
