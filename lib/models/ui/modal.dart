import 'package:flutter/material.dart';

class ModalData {
  final String title;
  final String? description;
  final String initialValue;
  final String hintText;
  final String confirmText;
  final String cancelText;
  final TextInputType keyboardType;
  final Color? confirmColor;
  final Color? cancelColor;
  final bool? hideInput;
  final bool? showIndicator;
  final String? Function(String?)? validator;
  final Function(String value)? onConfirm;
  final VoidCallback? onCancel;

  const ModalData({
    required this.title,
    this.description,
    this.initialValue = "",
    this.hintText = "",
    this.confirmText = "确定",
    this.cancelText = "取消",
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onConfirm,
    this.hideInput,
    this.showIndicator,
    this.cancelColor,
    this.confirmColor,
    this.onCancel,
  });

  factory ModalData.input({
    required String title,
    String? description,
    String initialValue = "",
    String hintText = "",
    String confirmText = "确定",
    String cancelText = "取消",
    TextInputType keyboardType = TextInputType.text,
    bool showIndicator = true,
    bool centerTitle = false,
    Color? confirmColor,
    Color? cancelColor,
    String? Function(String?)? validator,
    void Function(String value)? onConfirm,
  }) {
    return ModalData(
      title: title,
      description: description,
      initialValue: initialValue,
      hintText: hintText,
      confirmText: confirmText,
      cancelText: cancelText,
      keyboardType: keyboardType,
      validator: validator,
      onConfirm: onConfirm,
      hideInput: false,
      showIndicator: showIndicator,
      confirmColor: confirmColor,
      cancelColor: cancelColor,
    );
  }

  factory ModalData.normal({
    required String title,
    String? description,
    String confirmText = "确定",
    String cancelText = "取消",
    bool showIndicator = false,
    bool centerTitle = false,
    Color? confirmColor,
    Color? cancelColor,
    VoidCallback? onConfirm,
  }) {
    return ModalData(
      title: title,
      description: description,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: (_) => onConfirm?.call(),
      hideInput: true,
      showIndicator: showIndicator,
      confirmColor: confirmColor,
      cancelColor: cancelColor,
    );
  }

  factory ModalData.select({
    required String title,
    required String leftText,
    required String rightText,
    bool showIndicator = false,
    bool centerTitle = false,
    String? description,
    Color? rightColor,
    Color? leftColor,
    VoidCallback? onSelectRight,
    VoidCallback? onSelectLeft,
  }) {
    return ModalData(
      title: title,
      description: description,
      cancelText: leftText,
      confirmText: rightText,
      onCancel: () => onSelectLeft?.call(),
      onConfirm: (_) => onSelectRight?.call(),
      hideInput: true,
      showIndicator: showIndicator,
      confirmColor: rightColor,
      cancelColor: leftColor,
    );
  }
}
