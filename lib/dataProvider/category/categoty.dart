import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:driverapp/dataProvider/auth/auth.dart';
import 'package:driverapp/helper/api_end_points.dart' as api;
import 'package:driverapp/models/models.dart';

class CategoryDataProvider {
  final http.Client httpClient;

  CategoryDataProvider({required this.httpClient});
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  Future<Category> getCategoryById(String id) async {
    final http.Response response = await httpClient.get(
        Uri.parse(api.CategoryEndPoints.getCategoriesEndPoint(id)),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'
        });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Category.fromJson(jsonResponse);
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();
      if (res.statusCode == 200) {
        return getCategoryById(id);
      } else {
        throw Exception(response.statusCode);
      }
    }else {
      throw Exception(response.statusCode);
    }
  }
}
