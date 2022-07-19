import 'dart:convert';
// import 'dart:io';
// import 'package:retry/retry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/helper/api_end_points.dart' as api;
import '../../models/models.dart';

class SettingsDataProvider {
  final secureStorage = const FlutterSecureStorage();
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  SettingsDataProvider({required this.httpClient});

  // Future<http.Response> refreshToken() async {
  //   print("refresh token method called");
  //   http.Response response = await httpClient
  //       .get(Uri.parse(api.AuthEndPoints.refreshTokenEndPoint()));
  //   print("refresh token response code: ${response.statusCode}");
  //   if (response.statusCode == 200) {
  //     final token = jsonDecode(response.body)['token'];
  //     secureStorage.write(key: "token", value: token);
  //   }
  //   return response;
  // }

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
