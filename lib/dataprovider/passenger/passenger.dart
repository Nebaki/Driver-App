import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:driverapp/dataprovider/auth/auth.dart';
import 'package:driverapp/models/models.dart';

class PassengerDataprovider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/passengers';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  PassengerDataprovider({required this.httpClient});

  Future getAvailablePassengers() async {
    final response = await http.get(
        Uri.parse('$_baseUrl/get-available-passengers'),
        headers: <String, String>{
          'Content-Type': "application/json",
          'x-access-token': '${await authDataProvider.getToken()}',
        });


    if (response.statusCode == 200) {
      final responseData = json.decode(response.body)['items'] as List;
      if (responseData.isNotEmpty) {
        return responseData.map((e) => Passenger.fromJson(e)).toList();
      }
    } else {
      throw Exception('Failed to get driver.');
    }
  }
}
