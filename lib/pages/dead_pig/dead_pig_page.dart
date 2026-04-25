import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/dead_pig.dart';
import 'package:pig_counter/models/routes/upload_route_param.dart';
import 'package:pig_counter/stores/settings.dart';
import 'package:pig_counter/utils/media_selector.dart';
import 'package:pig_counter/utils/modal.dart';
import 'package:pig_counter/utils/toast.dart';
import 'package:pig_counter/widgets/button/button.dart';
import 'package:pig_counter/widgets/dead_pig/dead_pig_input_card.dart';
import 'package:pig_counter/widgets/dead_pig/dead_pig_report_item.dart';
import 'package:pig_counter/widgets/header/navigator_app_bar.dart';
import 'package:pig_counter/widgets/tips/tips.dart';

class DeadPigPage extends StatefulWidget {
  const DeadPigPage({super.key});

  @override
  State<DeadPigPage> createState() => _DeadPigPageState();
}

class _DeadPigPageState extends State<DeadPigPage> {
  final SettingsController _settingsController = Get.find<SettingsController>();
  late final MediaSelector _selector = MediaSelector(
    settingsController: _settingsController,
  );

  final TextEditingController _quantityController = TextEditingController(
    text: "1",
  );
  final TextEditingController _remarkController = TextEditingController();

  UploadRouteParam _routeParam = UploadRouteParam.empty();
  bool _routeLoaded = false;
  bool _loadingReports = false;
  bool _submitting = false;
  String _selectedImagePath = "";
  List<DeadPigReport> _reports = [];

  bool get _hasValidPen => _routeParam.pen.id > 0;

  String get _today => DateFormat("yyyy-MM-dd").format(DateTime.now());

  String get _now => DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

  String get _titleText {
    final buildingName = _routeParam.building.name;
    final penName = _routeParam.pen.name;
    if (buildingName.isEmpty && penName.isEmpty) return "死猪上报";
    return "死猪上报 - $buildingName / $penName";
  }

  UploadRouteParam _getRouteParam() {
    return ModalRoute.of(context)?.settings.arguments as UploadRouteParam? ??
        UploadRouteParam.empty();
  }

  Future<void> _loadReports() async {
    if (!_hasValidPen) return;
    if (mounted) setState(() => _loadingReports = true);
    try {
      final result = await API.DeadPig.daily(
        penId: _routeParam.pen.id,
        date: _today,
      );
      if (!result.ok) {
        Toast.showToast(
          .error(result.message.isNotEmpty ? result.message : "获取记录失败"),
        );
        return;
      }
      if (!mounted) return;
      setState(() {
        _reports = result.data;
      });
    } catch (_) {
      Toast.showToast(.error("获取死猪上报记录失败"));
    } finally {
      if (mounted) setState(() => _loadingReports = false);
    }
  }

  void _selectImage() {
    AppModal.show(
      context,
      .select(
        title: "选择上报图片",
        leftText: "图库",
        rightText: "拍摄",
        onSelectLeft: () async {
          final image = await _selector.selectImage();
          if (image == null || image.isEmpty || !mounted) return;
          setState(() => _selectedImagePath = image);
        },
        onSelectRight: () async {
          final image = await _selector.takeImage();
          if (image == null || image.isEmpty || !mounted) return;
          setState(() => _selectedImagePath = image);
        },
      ),
    );
  }

  Future<void> _submitReport() async {
    if (_submitting) return;
    final quantity = int.tryParse(_quantityController.text.trim());
    if (quantity == null || quantity <= 0) {
      Toast.showToast(.error("请输入大于 0 的死猪数量"));
      return;
    }
    if (_selectedImagePath.isEmpty) {
      Toast.showToast(.error("请先选择上报图片"));
      return;
    }
    if (!_hasValidPen) {
      Toast.showToast(.error("栏舍信息缺失，无法提交"));
      return;
    }

    setState(() => _submitting = true);
    try {
      final result = await API.DeadPig.create(
        penId: _routeParam.pen.id,
        reportDate: _today,
        captureTime: _now,
        quantity: quantity,
        remark: _remarkController.text.trim(),
        filePaths: [_selectedImagePath],
      );
      if (!result.ok) {
        Toast.showToast(
          .error(result.message.isNotEmpty ? result.message : "死猪上报失败"),
        );
        return;
      }

      if (!mounted) return;
      setState(() {
        _selectedImagePath = "";
        _remarkController.clear();
      });
      Toast.showToast(.success("死猪上报成功"));
      await _loadReports();
    } catch (_) {
      Toast.showToast(.error("死猪上报失败，请稍后重试"));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _buildDailyList() {
    if (_loadingReports) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_reports.isEmpty) {
      return AppTips.icon(text: "今日暂无死猪上报记录", type: .refresh);
    }
    return ListView.separated(
      itemCount: _reports.length,
      separatorBuilder: (_, _) => SizedBox(height: UIConstants.gapSize.sm),
      itemBuilder: (_, index) => DeadPigReportItem(report: _reports[index]),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_routeLoaded) return;
    _routeLoaded = true;
    _routeParam = _getRouteParam();
    _loadReports();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigatorAppbar(title: _titleText),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: ColorConstants.backgroundColor,
        padding: EdgeInsets.all(UIConstants.contentPaddingFromSides),
        child: !_hasValidPen
            ? AppTips.icon(text: "栏舍参数异常，无法进行死猪上报", type: .error)
            : Column(
                children: [
                  DeadPigInputCard(
                    routeParam: _routeParam,
                    today: _today,
                    quantityController: _quantityController,
                    remarkController: _remarkController,
                    selectedImagePath: _selectedImagePath,
                    submitting: _submitting,
                    onSelectImage: _selectImage,
                    onSubmit: _submitReport,
                  ),
                  SizedBox(height: UIConstants.gapSize.md),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "今日上报记录（${_reports.length}）",
                          style: TextStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontConstants.fontSize.sm,
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.defaultTextColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: UIConstants.uiSize.lg,
                        child: AppButton.normal(
                          label: "刷新",
                          blocked: false,
                          onPressed: _loadReports,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: UIConstants.gapSize.sm),
                  Expanded(child: _buildDailyList()),
                ],
              ),
      ),
    );
  }
}
