import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/widgets/button/button.dart';

import '../models/ui/modal.dart';

class AppModal {
  static Widget _buildIndicator() {
    return Center(
      child: Container(
        width: UIConstants.uiSize.xxl,
        height: UIConstants.uiSize.xs,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: .circular(UIConstants.uiSize.xs / 2),
        ),
      ),
    );
  }

  static Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: FontConstants.fontSize.md,
        fontFamily: FontConstants.fontFamily,
        fontWeight: FontWeight.w600,
        color: ColorConstants.defaultTextColor,
      ),
      overflow: .ellipsis,
    );
  }

  static Widget _buildDescription(String desc) {
    return Text(
      desc,
      style: TextStyle(
        fontSize: FontConstants.fontSize.xs,
        fontFamily: FontConstants.fontFamily,
        color: ColorConstants.secondaryTextColor,
      ),
    );
  }

  static Widget _buildInput({
    required ModalData data,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: data.keyboardType,
      validator: data.validator,
      autofocus: true,
      style: TextStyle(
        fontSize: FontConstants.fontSize.md,
        fontFamily: FontConstants.fontFamily,
        color: ColorConstants.defaultTextColor,
      ),
      decoration: InputDecoration(
        hintText: data.hintText,
        hintStyle: TextStyle(
          fontSize: FontConstants.fontSize.sm,
          fontFamily: FontConstants.fontFamily,
          color: ColorConstants.secondaryTextColor.withAlpha(
            (255 * 0.5).toInt(),
          ),
        ),
        contentPadding: .symmetric(
          horizontal: UIConstants.gapSize.lg,
          vertical: UIConstants.gapSize.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: .circular(UIConstants.borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: .circular(UIConstants.borderRadius),
          borderSide: BorderSide(
            color: ColorConstants.themeColor,
            width: UIConstants.gapSize.xs,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: .circular(UIConstants.borderRadius),
          borderSide: const BorderSide(color: ColorConstants.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: .circular(UIConstants.borderRadius),
          borderSide: BorderSide(
            color: ColorConstants.errorColor,
            width: UIConstants.gapSize.xs,
          ),
        ),
      ),
    );
  }

  static List<Widget> _buildButton({
    required BuildContext ctx,
    required ModalData data,
    required TextEditingController controller,
    required GlobalKey<FormState> formKey,
  }) {
    final height = UIConstants.uiSize.xxl;
    final cancel = SizedBox(
      height: height,
      child: AppButton.normal(
        label: data.cancelText,
        color: data.cancelColor,
        onPressed: () {
          Navigator.pop(ctx);
          data.onCancel?.call();
        },
      ),
    );
    final confirm = SizedBox(
      height: height,
      child: AppButton.normal(
        label: data.confirmText,
        color: data.confirmColor,
        filled: true,
        onPressed: () {
          if (data.hideInput == true ||
              (formKey.currentState?.validate() ?? false)) {
            Navigator.pop(ctx);
            data.onConfirm?.call(controller.text);
          }
        },
      ),
    );
    return [Expanded(child: cancel), Expanded(child: confirm)];
  }

  static void show(BuildContext context, ModalData data) {
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(UIConstants.borderRadius)),
      ),
      builder: (ctx) => _ModalSheet(data: data, formKey: formKey),
    );
  }
}

class _ModalSheet extends StatefulWidget {
  final ModalData data;
  final GlobalKey<FormState> formKey;

  const _ModalSheet({required this.data, required this.formKey});

  @override
  State<_ModalSheet> createState() => _ModalSheetState();
}

class _ModalSheetState extends State<_ModalSheet> with WidgetsBindingObserver {
  static const _keyboardSettleDuration = Duration(milliseconds: 120);
  static const _sheetLiftDuration = Duration(milliseconds: 180);

  Timer? _keyboardSettleTimer;
  late final TextEditingController _controller;
  double _stableKeyboardInset = 0;

  bool get _hasInput => widget.data.hideInput != true;

  double _readLogicalKeyboardInset() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return 0;
    final view = views.first;
    if (view.devicePixelRatio <= 0) return 0;
    final logical = view.viewInsets.bottom / view.devicePixelRatio;
    if (!logical.isFinite || logical < 0) return 0;
    return logical;
  }

  void _commitInset(double value) {
    if (!mounted || _stableKeyboardInset == value) return;
    setState(() {
      _stableKeyboardInset = value;
    });
  }

  void _scheduleInsetCommit() {
    _keyboardSettleTimer?.cancel();
    _keyboardSettleTimer = Timer(_keyboardSettleDuration, () {
      if (!mounted) return;
      _commitInset(_readLogicalKeyboardInset());
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.data.initialValue);
    if (_hasInput) {
      WidgetsBinding.instance.addObserver(this);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _commitInset(_readLogicalKeyboardInset());
      });
    }
  }

  @override
  void didChangeMetrics() {
    if (!_hasInput) return;
    _scheduleInsetCommit();
  }

  @override
  void dispose() {
    _keyboardSettleTimer?.cancel();
    if (_hasInput) {
      WidgetsBinding.instance.removeObserver(this);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final safeBottom = media.padding.bottom;
    final maxInset = media.size.height * 0.85;
    final effectiveInset = _stableKeyboardInset.clamp(0.0, maxInset);

    return AnimatedPadding(
      duration: _sheetLiftDuration,
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(
        left: UIConstants.contentPaddingFromSides,
        right: UIConstants.contentPaddingFromSides,
        top: UIConstants.gapSize.md,
        bottom: effectiveInset + safeBottom + UIConstants.gapSize.md,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              if (widget.data.showIndicator == true) AppModal._buildIndicator(),
              SizedBox(height: UIConstants.gapSize.xl),
              AppModal._buildTitle(widget.data.title),
              if (widget.data.description != null) ...[
                SizedBox(height: UIConstants.gapSize.sm),
                AppModal._buildDescription(widget.data.description!),
              ],
              if (_hasInput) ...[
                SizedBox(height: UIConstants.gapSize.xl),
                AppModal._buildInput(
                  data: widget.data,
                  controller: _controller,
                ),
              ],
              SizedBox(height: UIConstants.gapSize.xl),
              Row(
                spacing: UIConstants.gapSize.lg,
                children: AppModal._buildButton(
                  ctx: context,
                  data: widget.data,
                  controller: _controller,
                  formKey: widget.formKey,
                ),
              ),
              SizedBox(height: UIConstants.gapSize.md),
            ],
          ),
        ),
      ),
    );
  }
}
