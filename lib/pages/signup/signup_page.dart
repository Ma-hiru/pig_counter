import 'package:flutter/material.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/pages/signup/signup_form.dart';
import 'package:pig_counter/utils/toast.dart';

import '../../constants/err.dart';
import '../../constants/routes.dart';
import '../../constants/ui.dart';
import '../../widgets/button/button.dart';
import '../../widgets/header/navigator_app_bar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<SignupFormState> signupFormKey = GlobalKey<SignupFormState>();
  bool isLoading = false;

  void submit() async {
    if (isLoading) return;
    if (signupFormKey.currentState?.formKey.currentState?.validate() != true) {
      return;
    }

    final username = signupFormKey.currentState?.usernameController.text.trim();
    final password = signupFormKey.currentState?.passwordController.text.trim();
    final avatar = signupFormKey.currentState?.avatar;
    final company = signupFormKey.currentState?.companyController.text.trim();
    final name = signupFormKey.currentState?.nameController.text.trim();

    if (username == null ||
        password == null ||
        company == null ||
        name == null) {
      return;
    }

    if (avatar == null) {
      Toast.showToast(.normal("请选择头像"));
      return;
    }

    setState(() => isLoading = true);

    try {
      final signupResult = await API.User.register(
        username: username,
        password: password,
        picture: avatar,
        organization: company,
        name: name,
        admin: false,
      );

      if (!signupResult.ok) {
        Toast.showToast(.error(signupResult.message));
        return;
      }

      if (mounted) {
        Navigator.pushNamed(context, RoutesPathConstants.login);
        Toast.showToast(.success("注册成功，请登录"));
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

  Widget buildButton() {
    return Column(
      mainAxisAlignment: .end,
      children: [
        AppButton.normal(
          label: isLoading ? "提交中" : "提交",
          filled: true,
          onPressed: submit,
          disabled: isLoading,
        ),
        SizedBox(height: UIConstants.gapSize.md),
        AppButton.normal(label: "取消", onPressed: () => Navigator.pop(context)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigatorAppbar(title: "注册"),
      body: Container(
        width: .infinity,
        height: .infinity,
        color: ColorConstants.backgroundColor,
        padding: const .symmetric(
          horizontal: UIConstants.contentPaddingFromSides,
        ),
        child: Column(
          mainAxisAlignment: .start,
          children: [
            SignupForm(key: signupFormKey),
            Expanded(flex: 1, child: buildButton()),
            SizedBox(height: UIConstants.gapSize.xl),
          ],
        ),
      ),
    );
  }
}
