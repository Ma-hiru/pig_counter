import 'package:flutter/material.dart';
import 'package:pig_counter/models/routes/preview_route_param.dart';

import '../../constants/color.dart';
import '../../constants/ui.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  PreviewRouteParam? getRouteParam() =>
      ModalRoute.of(context)?.settings.arguments as PreviewRouteParam?;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: .infinity,
        height: .infinity,
        color: ColorConstants.backgroundColor,
        child: SingleChildScrollView(
          padding: const .symmetric(
            horizontal: UIConstants.contentPaddingFromSides,
            vertical: UIConstants.contentPaddingFromSides,
          ),
          child: Container(),
        ),
      ),
    );
  }
}
