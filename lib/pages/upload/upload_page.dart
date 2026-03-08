import 'package:flutter/material.dart';
import 'package:pig_counter/models/routes/upload_route_param.dart';

import '../../widgets/header/navigator_app_bar.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late UploadRouteParam _routeParam;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _routeParam =
        ModalRoute.of(context)?.settings.arguments as UploadRouteParam? ??
        UploadRouteParam.empty();
    return Scaffold(
      appBar: NavigatorAppbar(title: "上传 - ${_routeParam.pen.name}"),
    );
  }
}
