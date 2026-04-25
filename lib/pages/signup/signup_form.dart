import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/pages/signup/signup_avatar.dart';

import '../../constants/color.dart';
import '../../constants/ui.dart';
import '../../utils/validator.dart';
import '../../widgets/form/outline_input.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  File? avatar;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, String> fieldErrors = const {};

  bool passwordObscure = true;
  bool passwordAgainObscure = true;

  void setFieldErrors(Map<String, String> errors) {
    setState(() => fieldErrors = errors);
    formKey.currentState?.validate();
  }

  void clearFieldError(String field) {
    if (!fieldErrors.containsKey(field)) return;
    setState(() {
      final next = Map<String, String>.from(fieldErrors);
      next.remove(field);
      fieldErrors = next;
    });
  }

  Widget buildUsernameField() {
    return OutlineFormInput(
      hitText: "请输入用户名",
      validator: (value) =>
          fieldErrors["username"] ?? Validator.username(value),
      onChanged: (_) => clearFieldError("username"),
      prefixIcon: Icon(
        LucideIcons.user_round,
        color: ColorConstants.themeColor,
        size: UIConstants.uiSize.md,
      ),
      controller: usernameController,
    );
  }

  Widget buildPasswordField({
    required bool obscure,
    required Function()? onObscureChanged,
  }) {
    return OutlineFormInput(
      hitText: "请输入密码",
      validator: (value) =>
          fieldErrors["password"] ?? Validator.password(value),
      onChanged: (_) => clearFieldError("password"),
      prefixIcon: Icon(
        LucideIcons.lock,
        color: ColorConstants.themeColor,
        size: UIConstants.uiSize.md,
      ),
      showObscureToggle: true,
      controller: passwordController,
    );
  }

  Widget buildConfirmPasswordField({
    required bool obscure,
    required Function()? onObscureChanged,
  }) {
    return OutlineFormInput(
      hitText: "请再次输入密码",
      validator: (value) {
        if (value == null || value.isEmpty) return "请再次输入密码";
        if (value != passwordController.text) return "两次输入的密码不一致";
        return null;
      },
      prefixIcon: Icon(
        LucideIcons.lock,
        color: ColorConstants.themeColor,
        size: UIConstants.uiSize.md,
      ),
      showObscureToggle: true,
      controller: passwordAgainController,
    );
  }

  Widget buildNameField() {
    return OutlineFormInput(
      hitText: "请输入姓名",
      validator: (value) => fieldErrors["name"] ?? Validator.username(value),
      onChanged: (_) => clearFieldError("name"),
      prefixIcon: Icon(
        LucideIcons.file_user,
        color: ColorConstants.themeColor,
        size: UIConstants.uiSize.md,
      ),
      controller: nameController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SignupAvatar(
            onChange: (file) {
              setState(() => avatar = file);
            },
          ),
          buildUsernameField(),
          SizedBox(height: UIConstants.gapSize.xl),
          buildPasswordField(
            obscure: passwordObscure,
            onObscureChanged: () {
              setState(() => passwordObscure = !passwordObscure);
            },
          ),
          SizedBox(height: UIConstants.gapSize.xl),
          buildConfirmPasswordField(
            obscure: passwordAgainObscure,
            onObscureChanged: () {
              setState(() => passwordAgainObscure = !passwordAgainObscure);
            },
          ),
          SizedBox(height: UIConstants.gapSize.xl),
          buildNameField(),
        ],
      ),
    );
  }
}
