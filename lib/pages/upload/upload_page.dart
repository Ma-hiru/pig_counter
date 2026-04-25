import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/err.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/models/routes/upload_route_param.dart';
import 'package:pig_counter/pages/upload/upload_actions.dart';
import 'package:pig_counter/pages/upload/upload_media_library.dart';
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
  int _contentRefreshVersion = 0;
  bool _pageRefreshing = false;

  UploadRouteParam getRouteParam() {
    return ModalRoute.of(context)?.settings.arguments as UploadRouteParam? ??
        UploadRouteParam.empty();
  }

  Future<Pen> _hydratePenMedia(Pen pen) async {
    if (pen.mediaId > 0 && pen.hasRemoteMedia) return pen;

    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    try {
      final libraryResponse = await API.Media.library(
        penId: pen.id,
        date: today,
      );
      if (!libraryResponse.ok || libraryResponse.data.isEmpty) return pen;

      final media = libraryResponse.data.firstWhere(
        (item) => item.penId == pen.id,
        orElse: () => libraryResponse.data.first,
      );
      return pen.copyWith(
        mediaId: media.mediaId,
        aiCount: media.count,
        manualCount: media.manualCount,
        uploadPath: media.picturePath,
        outputPath: media.outputPicturePath,
        thumbnailPath: media.thumbnailPath,
        processingStatus: media.processingStatus,
        processingMessage: media.processingMessage,
        status: media.status,
        type: UploadTypeExt.fromRaw(media.mediaType),
      );
    } catch (_) {
      return pen;
    }
  }

  Future fetchLatestData() async {
    if (mounted) {
      setState(() {
        _pageRefreshing = true;
      });
    }
    try {
      final routeParam = getRouteParam();
      if (routeParam.task.id <= 0) {
        return setState(() {
          latestData = routeParam;
        });
      }

      final response = await API.Task.detail(routeParam.task.id);
      if (!response.ok) {
        Toast.showToast(
          .error(response.message.isNotEmpty ? response.message : "加载任务失败"),
        );
        return;
      }

      var task = response.data;
      if (task.taskStatusValue.isPending) {
        final receiveResponse = await API.Task.receive(task.id);
        if (receiveResponse.ok) {
          final refreshed = await API.Task.detail(task.id);
          if (refreshed.ok) {
            task = refreshed.data;
          }
        }
      }

      Building building = routeParam.building;
      for (final item in task.buildings) {
        if (item.id == routeParam.building.id) {
          building = item;
          break;
        }
      }
      if (building.id <= 0 && task.buildings.isNotEmpty) {
        building = task.buildings.first;
      }

      Pen pen = routeParam.pen;
      for (final item in building.pens) {
        if (item.id == routeParam.pen.id) {
          pen = item;
          break;
        }
      }
      if (pen.id <= 0 && building.pens.isNotEmpty) {
        pen = building.pens.first;
      }

      pen = await _hydratePenMedia(pen);
      final cache = await TaskCache.checkOne(
        taskID: task.id,
        buildingID: building.id,
        penID: pen.id,
      );
      if (cache != null) {
        pen = pen.copyWith(localPath: cache.path, localType: cache.type);
      }

      if (!mounted) return;
      setState(() {
        latestData = UploadRouteParam(task: task, building: building, pen: pen);
        _contentRefreshVersion++;
      });
    } catch (err) {
      if (err == ErrConstants.responseFormatError) {
        Toast.showToast(.error(ErrMsgConstants.responseFormatError));
      } else {
        Toast.showToast(.error(ErrMsgConstants.networkError));
      }
    } finally {
      if (mounted) {
        setState(() {
          _pageRefreshing = false;
        });
      }
    }
  }

  Widget buildRefreshNotice() {
    if (!_pageRefreshing || latestData == null) {
      return const SizedBox.shrink();
    }
    return Container(
      width: .infinity,
      padding: .all(UIConstants.gapSize.md),
      margin: .only(bottom: UIConstants.gapSize.md),
      decoration: BoxDecoration(
        color: const Color(0x141E88E5),
        borderRadius: .circular(UIConstants.borderRadius),
        border: .all(color: const Color(0x401E88E5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: const Color(0xFF1E88E5),
            ),
          ),
          SizedBox(width: UIConstants.gapSize.sm),
          Expanded(
            child: Text(
              "正在同步栏舍最新上传结果...",
              style: TextStyle(
                color: const Color(0xFF1E88E5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    if (latestData != null && uploadOptions != null) {
      return ListView(
        children: [
          buildRefreshNotice(),
          UploadPreview(pen: latestData!.pen),
          SizedBox(height: UIConstants.gapSize.md),
          UploadResult(pen: latestData!.pen),
          SizedBox(height: UIConstants.gapSize.md),
          UploadMediaLibrary(
            penId: latestData!.pen.id,
            refreshVersion: _contentRefreshVersion,
          ),
          SizedBox(height: UIConstants.gapSize.md),
          UploadActions(
            pen: latestData!.pen,
            taskID: latestData!.task.id,
            buildingID: latestData!.building.id,
            uploadOptions: uploadOptions!,
            onChange: (pen) {
              setState(() {
                latestData = latestData!.copyWith(pen: pen);
                _contentRefreshVersion++;
              });
            },
            onRefresh: fetchLatestData,
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
