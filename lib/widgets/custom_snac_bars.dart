import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_panel/core/constants/colors.dart';

class CustomSnacBars {
  void showSuccessSnack({title, message}) {
    Get.snackbar(title.toString(), message.toString(),
        snackPosition: SnackPosition.TOP, backgroundColor: Colors.greenAccent);
  }

  void showErrorSnack({title, message}) {
    Get.snackbar(
      title.toString(),
      message.toString(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColor.primaryColor1,
      colorText: Colors.white,
    );
  }

  void showInfoSnack({title, message}) {
    Get.snackbar(
      title.toString(),
      message.toString(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.grey[300],
      colorText: Colors.white,
    );
  }
}
