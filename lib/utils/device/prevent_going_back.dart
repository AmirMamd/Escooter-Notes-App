import 'package:flutter/material.dart';

class MyWillPopScope extends StatelessWidget {
  const MyWillPopScope(
      {required this.child, this.onWillPop = false, super.key});

  final Widget child;
  final bool onWillPop;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            if (onWillPop) {
              Navigator.of(context).pop();
            }
          }
        },
        child: PopScope(
          onPopInvokedWithResult: (result, popped) async => false,
          child: child,
        ));
  }
}
