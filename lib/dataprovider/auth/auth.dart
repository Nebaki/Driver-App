import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';

class AuthDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/auth';
  final _imageBaseUrl = 'https://safeway-api.herokuapp.com/';

  final http.Client httpClient;
  final secure_storage = new FlutterSecureStorage();
  AuthDataProvider({required this.httpClient});
  //iMkhQq
  Future<void> loginUser(Auth user) async {
    final fcm_id = await FirebaseMessaging.instance.getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/driver-login'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'phone_number': user.phoneNumber,
        'password': user.password,
        'fcm_id': fcm_id
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);


      await secure_storage.write(key: 'id', value: output['driver']['id']);
      await secure_storage.write(
          key: 'phone_number', value: output['driver']['phone_number']);
      await secure_storage.write(
          key: 'name', value: output['driver']['first_name']);
      await secure_storage.write(key: 'token', value: output['token']);
      await secure_storage.write(
          key: "email", value: output['driver']['email'] ?? "");
      await secure_storage.write(
          key: "emergency_contact",
          value: output['driver']['emergency_contact'] ?? "");

      await secure_storage.write(
          key: 'profile_image',
          value: _imageBaseUrl + output['driver']['profile_image']);

      await secure_storage.write(
          key: "driver_gender",
          value: output["driver"]['preference']['gender'] ?? "");
      await secure_storage.write(
          key: "min_rate",
          value: output["driver"]['preference']['min_rate'].toString());
      await secure_storage.write(
          key: "car_type",
          value: output["driver"]['preference']['car_type'] ?? "");

      await secure_storage.write(
          key: "vehicle_category",
          value: output["driver"]['vehicle']['type'] ?? "");

      
    } else {
      throw Exception('Failed to login.');
    }
  }

  Future<Auth> getUserData() async {
    final token = await secure_storage.readAll();
    return Auth.fromStorage(token);
  }

  Future updateUserData(User user) async {
    await secure_storage.write(key: 'phone_number', value: user.phoneNumber);

    await secure_storage.write(key: "email", value: user.email ?? "");
    await secure_storage.write(
        key: "emergency_contact", value: user.emergencyContact ?? "");
  }

  Future updateProfile(String url) async {
    await secure_storage.write(
        key: 'profile_image', value: _imageBaseUrl + url);
  }

  Future updatePreference(String gender, String rate, String carType) async {
    
    await secure_storage.write(key: "driver_gender", value: gender);
    await secure_storage.write(key: "min_rate", value: rate);
    await secure_storage.write(key: "car_type", value: carType);

  }

  Future logOut() async {
    await secure_storage.deleteAll();
  }

  Future<String?> getToken() async {
    return await secure_storage.read(key: "token");
  }

  Future<String?> getImageUrl() async {
    return await secure_storage.read(key: "profile_image");
  }
}
