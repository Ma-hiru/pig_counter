import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/err.dart';
import 'package:pig_counter/models/routes/upload_route_param.dart';
import 'package:pig_counter/pages/upload/upload_actions.dart';
import 'package:pig_counter/pages/upload/upload_preview.dart';
import 'package:pig_counter/pages/upload/upload_result.dart';
import 'package:pig_counter/utils/cache.dart';
import 'package:pig_counter/utils/media_selector.dart';
import 'package:pig_counter/utils/toast.dart';

import '../../constants/ui.dart';
import '../../stores/settings.dart';
import '../../widgets/header/navigator_app_bar.dart';
import '../../widgets/tips/tips.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final SettingsController settingsController = Get.find<SettingsController>();
  UploadRouteParam? latestData;
  MediaSelector? uploadOptions;

  UploadRouteParam getRouteParam() {
    return ModalRoute.of(context)?.settings.arguments as UploadRouteParam? ??
        UploadRouteParam.empty();
  }

  Future fetchLatestData() async {
    if (kDebugMode) {
      latestData = getRouteParam();
      final cache = await TaskCache.checkOne(
        taskID: latestData!.task.id,
        buildingID: latestData!.building.id,
        penID: latestData!.pen.id,
      );
      if (cache != null) {
        latestData = latestData!.copyWith(
          pen: latestData!.pen.copyWith(
            localPath: cache.path,
            localType: cache.type,
          ),
        );
      }
      return setState(() {});
    }
    try {
      final routeParam = getRouteParam();
      final response = await API.Task.detail(routeParam.task.id);

      final task = response.data;
      final building = task.buildings.firstWhere(
        (b) => b.id == routeParam.building.id,
      );
      final pen = building.pens.firstWhere((p) => p.id == routeParam.pen.id);
      final cache = await TaskCache.checkOne(
        taskID: task.id,
        buildingID: building.id,
        penID: pen.id,
      );
      if (cache != null) {
        pen.localPath = cache.path;
        pen.localType = cache.type;
      }
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
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: UploadPreview(pen: latestData!.pen),
            ),
          ),
          SizedBox(height: UIConstants.gapSize.md),
          UploadResult(pen: latestData!.pen),
          SizedBox(height: UIConstants.gapSize.md),
          UploadActions(
            pen: latestData!.pen,
            taskID: latestData!.task.id,
            buildingID: latestData!.building.id,
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
    return AppTips.icon(text: "正在加载", type: .loading);
  }

  @override
  void initState() {
    super.initState();
    uploadOptions = MediaSelector(settingsController: settingsController);
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
