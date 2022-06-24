import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';
import 'package:driverapp/helper/api_end_points.dart' as api;

class AuthDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/auth';
  final _imageBaseUrl = 'https://safeway-api.herokuapp.com/';

  final http.Client httpClient;
  final secureStorage = const FlutterSecureStorage();
  AuthDataProvider({required this.httpClient});

  Future<http.Response> refreshToken() async {
    http.Response response = await httpClient.get(
        Uri.parse(api.AuthEndPoints.refreshTokenEndPoint()),
        headers: <String, String>{
          'Cookie': '${await secureStorage.read(key: "refresh_token")}'
        });
    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      secureStorage.write(key: "token", value: token);
    } else {}
    return response;
  }

  void updateCookie(http.Response response) async {
    final rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      await secureStorage.write(
          key: "refresh_token",
          value: (index == -1) ? rawCookie : rawCookie.substring(0, index));
    }
  }

  Future<void> loginUser(Auth user) async {
    final fcmId = await FirebaseMessaging.instance.getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/driver-login'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'phone_number': user.phoneNumber,
        'password': user.password,
        'fcm_id': fcmId
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      updateCookie(response);
      await secureStorage.write(key: 'id', value: output['driver']['id']);
      await secureStorage.write(
          key: 'phone_number', value: output['driver']['phone_number']);
      await secureStorage.write(
          key: 'name', value: output['driver']['first_name']);
      await secureStorage.write(
          key: 'last_name', value: output['driver']['last_name']);
      await secureStorage.write(key: 'token', value: output['token']);
      await secureStorage.write(
          key: "email", value: output['driver']['email'] ?? "");
      await secureStorage.write(
          key: "emergency_contact",
          value: output['driver']['emergency_contact'] ?? "");

      await secureStorage.write(
          key: 'profile_image',
          value: _imageBaseUrl + output['driver']['profile_image']);

      await secureStorage.write(
          key: "driver_gender",
          value: output["driver"]['preference']['gender'] ?? "");
      await secureStorage.write(
          key: "min_rate",
          value: output["driver"]['preference']['min_rate'].toString());
      await secureStorage.write(
          key: "car_type",
          value: output["driver"]['preference']['car_type'] ?? "");

      await secureStorage.write(
          key: "vehicle_category",
          value: output["driver"]['vehicle']['category']['name'] ?? "");
      await secureStorage.write(
          key: "per_minute_cost",
          value: output["driver"]['vehicle']['category']['per_minute_cost']
              .toString());
      await secureStorage.write(
          key: "per_killo_meter_cost",
          value: output["driver"]['vehicle']['category']['per_kilometer_cost']
              .toString());
      await secureStorage.write(
          key: "initial_fare",
          value: output["driver"]['vehicle']['category']['initial_fare']
              .toString());

      await secureStorage.write(
          key: "vehicle_type",
          value: output["driver"]['vehicle']['type'] ?? "");

      await secureStorage.write(
          key: "avg_rate",
          value: output['driver']['avg_rate']['score'].toString());

      await secureStorage.write(
          key: "balance",
          value: output['driver']['credit']['balance'].toString());
    } else {
      throw Exception('Failed to login.');
    }
  }

  Future<Auth> getUserData() async {
    final token = await secureStorage.readAll();
    return Auth.fromStorage(token);
  }

  Future updateUserData(User user) async {
    await secureStorage.write(key: 'phone_number', value: user.phoneNumber);

    await secureStorage.write(key: "email", value: user.email ?? "");
    await secureStorage.write(
        key: "emergency_contact", value: user.emergencyContact ?? "");
  }

  Future updateProfile(String url) async {
    await secureStorage.write(key: 'profile_image', value: _imageBaseUrl + url);
  }

  Future updatePreference(String gender, String rate, String carType) async {
    await secureStorage.write(key: "driver_gender", value: gender);
    await secureStorage.write(key: "min_rate", value: rate);
    await secureStorage.write(key: "car_type", value: carType);
  }

  Future logOut() async {
    await FirebaseMessaging.instance.deleteToken();
    await secureStorage.deleteAll();
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: "token");
  }

  Future<String?> getImageUrl() async {
    return await secureStorage.read(key: "profile_image");
  }
}
