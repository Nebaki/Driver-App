import 'dart:convert';
import 'dart:math';

// import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/dataprovider/auth/auth.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/repository/auth.dart';

class CreditDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/drivers';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  CreditDataProvider({required this.httpClient});

  Future<User> rechargeCredit(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-credit'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'name': user.firstName,
        'email': user.email,
        'gender': user.gender,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<void> loadBalance(String id) async {
    final http.Response response = await httpClient.get(
        Uri.parse('$_baseUrl/$id/load-credit-balance'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': '${await authDataProvider.getToken()}'
        });

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user.');
    }
  }

  Future<CreditStore> loadCreditHistory(String user) async {
    final http.Response response = await http.post(
      Uri.parse('$_baseUrl/load-credit-history'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-access-token': '${await authDataProvider.getToken()}'
      }
    );

    if (response.statusCode == 200) {
      return CreditStore.fromJson(jsonDecode(response.body));
    } else {
        Credit credit;
        List<Credit> credits = [];
        int i = 0;
        while (i < 10) {
          var rng = Random();
          int money = rng.nextInt(100) * i + 237;
          var type = i %2 == 0?'Gift':'Message';
          if(i == 4 || i== 8){
            type = "Message";
          }
          credit = Credit(
              id:"$i vic",
              title: "Money Received $i",
              message: "Hello! you received nothing, Thanks",
              type: type,
              amount: "$money.ETB",
              date: "Today");
          credits.add(credit);
          i++;
        }
        return CreditStore(trips: credits);
    }
  }

  Future updatePreference(User user) async {
    print(user.preference);
    final http.Response response = await http.post(
      Uri.parse('$_baseUrl/update-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-access-token': '${await authDataProvider.getToken()}'
      },
      body: jsonEncode(<String, dynamic>{'preference': user.preference}),
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['driver']['preference']['car_type']);
      authDataProvider.updatePreference(
          data['driver']['preference']['gender'],
          data['driver']['preference']['min_rate'].toString(),
          data['driver']['preference']['car_type']);
    } else if (response.statusCode != 204) {
      throw Exception('204 Failed to update user.');
    } else {
      throw Exception('Failed to update user.');
    }
  }
}

