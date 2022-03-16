import 'dart:convert';

// import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/dataprovider/auth/auth.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/repository/auth.dart';

class TeleBirrDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/drivers';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  TeleBirrDataProvider({required this.httpClient});

  Future<User> initTelebirr(User user) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/init-telebirr'),
      headers: <String, String>{'Content-Type': 'application/json',
        'x-access-token': '${await authDataProvider.getToken()}'}
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future confirmTransaction(XFile file) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/init-telebirr'),
        headers: <String, String>{'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'}
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }
}
