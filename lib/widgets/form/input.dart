import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../constants/ui.dart';

class FormInput extends StatefulWidget {
  final String hitText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String value)? onChanged;
  final void Function()? onSuffixTap;
  final void Function()? onFocus;
  final Widget? suffix;
  final Icon? prefixIcon;

  const FormInput({
    super.key,
    required this.hitText,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onFocus,
    this.onSuffixTap,
    this.suffix,
    this.prefixIcon,
  });

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  final FocusNode _focusNode = FocusNode();
  bool _showClearIcon = false;
  DateTime _lastBlurTime = DateTime.now();

  void updateClearIconVisibility() {
    _showClearIcon = _focusNode.hasFocus && widget.controller.text.isNotEmpty;
    if (!_focusNode.hasFocus) _lastBlurTime = DateTime.now();
    if (widget.onFocus != null && _focusNode.hasFocus) {
      _focusNode.unfocus();
      widget.onFocus!();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(updateClearIconVisibility);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconConstraints = BoxConstraints(
      minWidth: FontConstants.fontSize.md,
      minHeight: FontConstants.fontSize.md,
    );
    return Stack(
      children: [
        SizedBox(
          height: UIConstants.uiSize.xxxl,
          child: TextFormField(
            validator: widget.validator,
            focusNode: _focusNode,
            controller: widget.controller,
            onChanged: (value) {
              updateClearIconVisibility();
              widget.onChanged?.call(value);
            },
            cursorColor: ColorConstants.themeColor,
            cursorErrorColor: ColorConstants.errorColor,
            style: TextStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.fontSize.md,
              color: ColorConstants.defaultTextColor,
            ),
            textAlign: .left,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              isDense: false,
              filled: false,
              prefixIcon: widget.prefixIcon,
              prefixIconConstraints: widget.prefixIcon != null
                  ? iconConstraints
                  : null,
              hintText: widget.hitText,
              contentPadding: .only(
                top: UIConstants.gapSize.md,
                bottom: UIConstants.gapSize.md,
                left: UIConstants.gapSize.md,
                right: FontConstants.fontSize.md + UIConstants.gapSize.md,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.themeColor),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: (UIConstants.uiSize.xxxl - FontConstants.fontSize.md) / 2,
          child: GestureDetector(
            onTap: () {
              if (_showClearIcon ||
                  DateTime.now().difference(_lastBlurTime).inSeconds < 1) {
                setState(() {
                  widget.controller.clear();
                  _showClearIcon = false;
                });
              } else {
                widget.onSuffixTap?.call();
              }
            },
            child: SizedBox(
              width: FontConstants.fontSize.md,
              height: FontConstants.fontSize.md,
              child: _showClearIcon
                  ? Icon(LucideIcons.circle_x, size: FontConstants.fontSize.md)
                  : widget.suffix,
            ),
          ),
        ),
      ],
    );
  }
}
