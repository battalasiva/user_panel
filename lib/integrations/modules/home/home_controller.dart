import 'package:get/get.dart';
import 'package:user_panel/integrations/data/models/UserDataModel.dart';

import '../../data/services/api_service.dart';

class HomeController extends GetxController {
  var usersList = <Data>[].obs;
  var isLoading = true.obs;

  final ApiProvider _apiProvider = ApiProvider();

  @override
  void onInit() {
    super.onInit();
    fetchUsersList();
  }

  void fetchUsersList() async {
    try {
      isLoading(true);
      final response = await _apiProvider.fetchUsers();
      usersList.value = response.data ?? [];
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users');
    } finally {
      isLoading(false);
    }
  }
}
