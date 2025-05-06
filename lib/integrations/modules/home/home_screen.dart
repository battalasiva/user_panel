// home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_panel/core/constants/colors.dart';
import 'package:user_panel/widgets/AppLoaderWidget.dart';
import 'package:user_panel/widgets/UserCard.dart';
import 'package:user_panel/widgets/location_display.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor1,
        title: Text("Users List", style: TextStyle(color: AppColor.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: AppColor.primaryColor3,
            child: const LocationDisplay(),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: AppLoader());
              }

              if (controller.usersList.isEmpty) {
                return  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning, color: AppColor.greyText2, size: 50),
                      SizedBox(height: 8),
                      Text(
                        "User data not found",
                        style: TextStyle(color: AppColor.greyText2, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.usersList.length,
                itemBuilder: (context, index) {
                  final user = controller.usersList[index];
                  return UserCard(user: user, index: index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}