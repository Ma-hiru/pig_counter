import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../constants/ui.dart';

class OutlineFormInput extends StatefulWidget {
  final String hitText;
  final bool obscureText;

  /// 为 true 时组件内部管理密码显示/隐藏，无需外部传 suffix
  final bool showObscureToggle;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String value)? onChanged;
  final void Function()? onSuffixTap;
  final void Function()? onFocus;
  final Widget? suffix;
  final Icon? prefixIcon;

  const OutlineFormInput({
    super.key,
    required this.hitText,
    required this.controller,
    this.obscureText = false,
    this.showObscureToggle = false,
    this.validator,
    this.onChanged,
    this.onFocus,
    this.onSuffixTap,
    this.suffix,
    this.prefixIcon,
  });

  @override
  State<OutlineFormInput> createState() => _OutlineFormInputState();
}

class _OutlineFormInputState extends State<OutlineFormInput> {
  final FocusNode _focusNode = FocusNode();
  bool _showClearIcon = false;
  late bool _internalObscure;

  @override
  void initState() {
    super.initState();
    _internalObscure = widget.obscureText || widget.showObscureToggle;
    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    _showClearIcon = _focusNode.hasFocus && widget.controller.text.isNotEmpty;
    if (widget.onFocus != null && _focusNode.hasFocus) {
      _focusNode.unfocus();
      widget.onFocus!();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  Widget? _buildSuffixIcon() {
    if (_showClearIcon) {
      return GestureDetector(
        onTap: () => setState(() {
          widget.controller.clear();
          _showClearIcon = false;
        }),
        child: Icon(
          LucideIcons.circle_x,
          size: FontConstants.fontSize.lg,
          color: Colors.grey.shade400,
        ),
      );
    }
    if (widget.showObscureToggle) {
      return GestureDetector(
        onTap: () => setState(() => _internalObscure = !_internalObscure),
        child: Icon(
          _internalObscure ? LucideIcons.eye_off : LucideIcons.eye,
          size: FontConstants.fontSize.lg,
          color: Colors.grey.shade400,
        ),
      );
    }
    if (widget.suffix != null) {
      return GestureDetector(onTap: widget.onSuffixTap, child: widget.suffix);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isObscure = widget.showObscureToggle
        ? _internalObscure
        : widget.obscureText;
    final borderRadius = BorderRadius.circular(UIConstants.borderRadius);

    return TextFormField(
      validator: widget.validator,
      focusNode: _focusNode,
      controller: widget.controller,
      onChanged: (value) {
        setState(() {
          _showClearIcon =
              _focusNode.hasFocus && widget.controller.text.isNotEmpty;
        });
        widget.onChanged?.call(value);
      },
      cursorColor: ColorConstants.themeColor,
      cursorErrorColor: ColorConstants.errorColor,
      style: TextStyle(
        fontFamily: FontConstants.fontFamily,
        fontSize: FontConstants.fontSize.md,
        color: ColorConstants.defaultTextColor,
      ),
      obscureText: isObscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: widget.prefixIcon,
        suffixIcon: _buildSuffixIcon(),
        hintText: widget.hitText,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: FontConstants.fontSize.md,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: UIConstants.gapSize.lg,
          vertical: UIConstants.gapSize.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(
            color: ColorConstants.themeColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: ColorConstants.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(
            color: ColorConstants.errorColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
