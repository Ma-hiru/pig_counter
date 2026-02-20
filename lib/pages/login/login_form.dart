import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:pig_counter/api/login.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/err.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/stores/user.dart';
import 'package:pig_counter/utils/toast.dart';

import '../../utils/validator.dart';
import '../../widgets/button/button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.find();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _rememberPassword = false;
  bool _showUsernameClearIcon = false;
  bool _showPasswordClearIcon = false;
  bool _obscurePassword = true;

  void listenFocusChange() {
    _usernameFocusNode.addListener(() {
      setState(() {
        _showUsernameClearIcon =
            _usernameFocusNode.hasFocus && _usernameController.text.isNotEmpty;
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        _showPasswordClearIcon =
            _passwordFocusNode.hasFocus && _passwordController.text.isNotEmpty;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listenFocusChange();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  Widget buildInputField({
    required String hitText,
    required bool obscureText,
    required TextEditingController controller,
    required FocusNode focusNode,
    String? Function(String?)? validator,
    void Function(String value)? onChanged,
    void Function()? onSuffixIconTap,
    Widget? suffixIcon,
    Icon? prefixIcon,
  }) {
    final iconConstraints = BoxConstraints(
      minWidth: FontConstants.fontSize.md,
      minHeight: FontConstants.fontSize.md,
    );
    return Stack(
      children: [
        SizedBox(
          height: UIConstants.uiSize.xxxl,
          child: TextFormField(
            validator: validator,
            focusNode: focusNode,
            controller: controller,
            onChanged: onChanged,
            style: TextStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.fontSize.md,
              color: ColorConstants.defaultTextColor,
            ),
            textAlign: .left,
            obscureText: obscureText,
            decoration: InputDecoration(
              isDense: false,
              filled: false,
              prefixIcon: prefixIcon,
              prefixIconConstraints: prefixIcon != null
                  ? iconConstraints
                  : null,
              hintText: hitText,
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
          child: suffixIcon != null
              ? GestureDetector(
                  onTap: onSuffixIconTap,
                  child: SizedBox(
                    width: FontConstants.fontSize.md,
                    height: FontConstants.fontSize.md,
                    child: suffixIcon,
                  ),
                )
              : Container(),
        ),
      ],
    );
  }

  Widget buildUsernameField() {
    return buildInputField(
      hitText: "请输入用户名",
      validator: Validator.usernameValidator,
      focusNode: _usernameFocusNode,
      prefixIcon: Icon(LucideIcons.user_round),
      suffixIcon: _showUsernameClearIcon
          ? Icon(LucideIcons.circle_x, size: FontConstants.fontSize.md)
          : null,
      obscureText: false,
      controller: _usernameController,
      onChanged: (value) => setState(() {
        _showUsernameClearIcon =
            _usernameFocusNode.hasFocus && value.isNotEmpty;
      }),
      onSuffixIconTap: () {
        _usernameController.clear();
        setState(() {
          _showUsernameClearIcon = false;
        });
      },
    );
  }

  Widget buildPasswordField({
    required bool obscure,
    required Function(bool) onObscureChanged,
  }) {
    return buildInputField(
      hitText: "请输入密码",
      validator: Validator.passwordValidator,
      focusNode: _passwordFocusNode,
      prefixIcon: Icon(LucideIcons.lock),
      obscureText: obscure,
      controller: _passwordController,
      onChanged: (value) => setState(() {
        _showPasswordClearIcon =
            _passwordFocusNode.hasFocus && _passwordController.text.isNotEmpty;
      }),
      onSuffixIconTap: () => setState(() {
        if (_showPasswordClearIcon) {
          _passwordController.clear();
          _showPasswordClearIcon = false;
        } else {
          onObscureChanged(!obscure);
        }
      }),
      suffixIcon: _showPasswordClearIcon
          ? Icon(LucideIcons.circle_x, size: FontConstants.fontSize.md)
          : obscure
          ? Transform.scale(
              scale: 1.12,
              child: Icon(LucideIcons.eye_off, size: FontConstants.fontSize.md),
            )
          : Transform.scale(
              scale: 1.12,
              child: Icon(LucideIcons.eye, size: FontConstants.fontSize.md),
            ),
    );
  }

  Widget buildCheckBox() {
    return Row(
      mainAxisAlignment: .end,
      spacing: UIConstants.gapSize.sm,
      children: [
        SizedBox(
          width: FontConstants.fontSize.sm,
          height: FontConstants.fontSize.sm,
          child: Transform.scale(
            scale: 0.8,
            child: Checkbox(
              value: _rememberPassword,
              shape: RoundedRectangleBorder(borderRadius: .circular(10)),
              onChanged: (value) => setState(() {
                _rememberPassword = value ?? false;
              }),
            ),
          ),
        ),
        Text(
          "记住密码",
          style: TextStyle(
            fontSize: FontConstants.fontSize.sm,
            fontFamily: FontConstants.fontFamily,
            color: ColorConstants.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  bool isLoading = false;

  void submit() async {
    if (isLoading) return;
    if (_formKey.currentState?.validate() != true) return;
    setState(() => isLoading = true);
    try {
      final userProfile = await loginByAccount(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!userProfile.ok) {
        return Toast.showToast(.error(userProfile.message));
      }

      _userController.updateUserProfile(userProfile.data);
      if (mounted) {
        Navigator.pushNamed(context, "/home");
        Toast.showToast(.success("登录成功"));
      }
    } catch (err) {
      if (err == ErrConstants.responseFormatError) {
        Toast.showToast(.error(ErrMsgConstants.responseFormatError));
      } else {
        Toast.showToast(.error(ErrMsgConstants.networkError));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const .symmetric(
          horizontal: UIConstants.contentPaddingFromSides,
        ),
        child: Column(
          children: [
            buildUsernameField(),
            SizedBox(height: UIConstants.gapSize.xl),
            buildPasswordField(
              obscure: _obscurePassword,
              onObscureChanged: (obscure) =>
                  setState(() => _obscurePassword = obscure),
            ),
            SizedBox(height: UIConstants.gapSize.xl),
            buildCheckBox(),
            SizedBox(height: UIConstants.gapSize.xxxl * 2),
            AppButton.blockButton(
              label: isLoading ? "登录中" : "登录",
              filled: true,
              onPressed: submit,
              disabled: isLoading,
            ),
            SizedBox(height: UIConstants.gapSize.sm),
            AppButton.blockButton(
              label: "注册",
              onPressed: () => Navigator.pushNamed(context, "/signup"),
            ),
          ],
        ),
      ),
    );
  }
}
