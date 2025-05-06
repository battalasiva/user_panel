import 'package:dio/dio.dart';
import 'package:user_panel/integrations/data/models/UserDataModel.dart';

class ApiProvider {
  final Dio _dio = Dio();

  Future<UsersListModel> fetchUsers() async {
    final response = await _dio.get("https://reqres.in/api/users?page=2");
    return UsersListModel.fromJson(response.data);
  }
}
