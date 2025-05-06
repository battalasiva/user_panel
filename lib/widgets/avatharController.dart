import 'dart:io';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AvatarController extends GetxController {
  final Box box = Hive.box('avatarBox');

  void saveUserAvatar(String userId, File imageFile) {
    box.put(userId, imageFile.path); 
  }

  File? getUserAvatar(String userId) {
    final path = box.get(userId);
    return path != null ? File(path) : null;
  }
}

