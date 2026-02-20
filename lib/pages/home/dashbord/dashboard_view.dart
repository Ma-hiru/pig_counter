import 'package:flutter/material.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/utils/toast.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: .center,
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          const Text("Dashboard"),
          SizedBox(height: UIConstants.uiSize.md),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/login");
            },
            child: const Text("Go to Login"),
          ),
          SizedBox(height: UIConstants.uiSize.xs),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/signup");
            },
            child: const Text("Go to Signup"),
          ),
          SizedBox(height: UIConstants.uiSize.xs),
          ElevatedButton(
            onPressed: () {
              Toast.showToast(.normal("This is a normal toast"));
              Future.delayed(Duration(seconds: 1), () {
                Toast.showToast(.success("This is a normal toast"));
              });
              Future.delayed(Duration(seconds: 2), () {
                Toast.showToast(.error("This is a normal toast"));
              });
            },
            child: const Text("Show Toast"),
          ),
        ],
      ),
    );
  }
}
