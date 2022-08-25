import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/dataProvider/data_providers.dart';
import 'package:driverapp/helper/api_end_points.dart' as api;
import '../../models/models.dart';

class SettingsDataProvider {
  final secureStorage = const FlutterSecureStorage();
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  SettingsDataProvider({required this.httpClient});
  Future<Settings> getSettings() async {
    http.Response response = await httpClient.get(
        Uri.parse(api.SettingsEndPoint.getSettingsEndPoint()),
        headers: <String, String>{
          'x-access-token': "${await authDataProvider.getToken()}"
        }).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Settings.fromJson(data);
    } 
    else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return getSettings();
      } else {
        throw Exception(response.statusCode);
      }
    } 
    else {
      throw Exception(response.statusCode);
    }
  }

 

  Map<String, String> headers = {};
}
