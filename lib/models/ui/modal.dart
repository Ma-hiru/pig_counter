import 'package:flutter/material.dart';

class ModalData {
  final String title;
  final String? description;
  final String initialValue;
  final String hintText;
  final String confirmText;
  final String cancelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String value)? onConfirm;

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
  });
}
