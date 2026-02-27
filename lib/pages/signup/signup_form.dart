import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/pages/signup/signup_avatar.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../constants/ui.dart';
import '../../utils/validator.dart';
import '../../widgets/button/button.dart';
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
  final TextEditingController companyController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool passwordObscure = true;
  bool passwordAgainObscure = true;

  Widget buildUsernameField() {
    return OutlineFormInput(
      hitText: "请输入用户名",
      validator: Validator.username,
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
      validator: Validator.password,
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
      validator: Validator.username,
      prefixIcon: Icon(
        LucideIcons.file_user,
        color: ColorConstants.themeColor,
        size: UIConstants.uiSize.md,
      ),
      controller: nameController,
    );
  }

  Widget companyItem(String text, Function() onTap) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontSize: FontConstants.fontSize.md,
          fontFamily: FontConstants.fontFamily,
          color: ColorConstants.defaultTextColor,
        ),
      ),
      onTap: onTap,
    );
  }

  void openCompanySelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UIConstants.borderRadius),
        ),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: .symmetric(
            horizontal: UIConstants.contentPaddingFromSides,
            vertical: UIConstants.gapSize.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "选择公司",
                style: TextStyle(
                  fontSize: FontConstants.fontSize.md,
                  fontFamily: FontConstants.fontFamily,
                  fontWeight: .w700,
                  color: ColorConstants.themeColor,
                ),
                textAlign: .center,
              ),
              SizedBox(height: UIConstants.gapSize.md),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: ListView(
                  children: List.generate(100, (index) {
                    return companyItem("公司$index", () {
                      companyController.text = "公司$index";
                      Navigator.pop(context);
                    });
                  }),
                ),
              ),
              SizedBox(height: UIConstants.gapSize.md),
              AppButton.text(label: "关闭"),
            ],
          ),
        );
      },
    );
  }

  Widget buildCompanyField() {
    return OutlineFormInput(
      hitText: "选择公司",
      validator: Validator.username,
      prefixIcon: Icon(
        LucideIcons.building_2,
        color: ColorConstants.themeColor,
        size: UIConstants.uiSize.md,
      ),
      controller: companyController,
      onFocus: openCompanySelection,
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
          SizedBox(height: UIConstants.gapSize.xl),
          buildCompanyField(),
        ],
      ),
    );
  }
}
