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
import '../../widgets/form/input.dart';

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

  bool _rememberPassword = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _usernameController.text = _userController.getMemoUsername() ?? "";
    _passwordController.text = _userController.getMemoPassword() ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  Widget buildUsernameField() {
    return FormInput(
      hitText: "请输入用户名",
      validator: Validator.username,
      prefixIcon: Icon(
        LucideIcons.user_round,
        color: ColorConstants.themeColor,
        size: UIConstants.uiSize.md,
      ),
      controller: _usernameController,
    );
  }

  Widget buildPasswordField({
    required bool obscure,
    required Function()? onObscureChanged,
  }) {
    return FormInput(
      hitText: "请输入密码",
      validator: Validator.password,
      prefixIcon: Icon(
        LucideIcons.lock,
        size: UIConstants.uiSize.md,
        color: ColorConstants.themeColor,
      ),
      obscureText: obscure,
      controller: _passwordController,
      onSuffixTap: onObscureChanged,
      suffix: obscure
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
              checkColor: ColorConstants.textColorOnTheme,
              activeColor: ColorConstants.themeColor,
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

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    if (_rememberPassword) {
      _userController.memoUserAndPwd(username: username, password: password);
    } else {
      _userController.clearUserAndPwd();
    }

    try {
      final userProfile = await loginByAccount(
        username: username,
        password: password,
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
      key: _formKey,
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
              onObscureChanged: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            SizedBox(height: UIConstants.gapSize.xl),
            buildCheckBox(),
            SizedBox(height: UIConstants.gapSize.xxxl * 2),
            AppButton.normal(
              label: isLoading ? "登录中" : "登录",
              filled: true,
              onPressed: submit,
              disabled: isLoading,
            ),
            SizedBox(height: UIConstants.gapSize.md),
            AppButton.normal(
              label: "注册",
              onPressed: () => Navigator.pushNamed(context, "/signup"),
            ),
          ],
        ),
      ),
    );
  }
}
