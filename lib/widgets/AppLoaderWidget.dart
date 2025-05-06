import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:user_panel/core/constants/colors.dart';

class AppLoader extends StatelessWidget {
  final double? size;
  final Color? color;

  const AppLoader({
    super.key,
    this.size = 45.0, 
    this.color, 
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(
        color: color ?? AppColor.primaryColor1, 
        size: size!,
      ),
    );
  }
}
