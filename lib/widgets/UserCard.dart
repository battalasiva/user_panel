import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_panel/core/constants/colors.dart';
import 'package:user_panel/integrations/data/models/UserDataModel.dart';
import 'package:user_panel/widgets/avatharController.dart';

class UserCard extends StatelessWidget {
  final Data user;
  final int index;

  const UserCard({super.key, required this.user, required this.index});

  @override
  Widget build(BuildContext context) {
    final AvatarController avatarController = Get.put(AvatarController());
    final Rx<File?> uploadedImage =
        avatarController.getUserAvatar(user.id!.toString()).obs;

    Future<void> _pickImage(ImageSource source) async {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        avatarController.saveUserAvatar(user.id.toString(), file);
        uploadedImage.value = file;
      }
    }

    void _showImageSourceActionSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: AppColor.primaryColor3,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: ListTile(
        leading: Stack(
          children: [
            Obx(() => CircleAvatar(
                  radius: 30,
                  backgroundImage: uploadedImage.value != null
                      ? FileImage(uploadedImage.value!)
                      : NetworkImage(user.avatar ?? '') as ImageProvider,
                )),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showImageSourceActionSheet(context),
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.edit, size: 14, color: AppColor.primaryColor1),
                ),
              ),
            ),
          ],
        ),
        title: Text('${user.firstName ?? ''} ${user.lastName ?? ''}'),
        subtitle: Text(user.email ?? ''),
      ),
    );
  }
}
