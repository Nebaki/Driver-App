import 'dart:convert';

import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/dataprovider/auth/auth.dart';
import '../../screens/credit/credit_form.dart';

class TeleBirrDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/credits/';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  TeleBirrDataProvider({required this.httpClient});

  Future<TelePack> initTelebirr(String user) async {
    print("init-telebirr");
    final response = await http.get(
      Uri.parse('$_baseUrl/initiate-telebirr'),
      //Uri.parse('https://app.hellotena.com/api/telebirr/confirmPayment/01245890-9dd9-4abd-a5d3-9fe1e9d39b2b/covid/covid'),
      headers: <String, String>{'Content-Type': 'application/json',
        'x-access-token': '${await authDataProvider.getToken()}'}
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return TelePack.fromJson(jsonDecode(response.body));
    } else {
      print("init-telebirr ${response.statusCode}");
      String data = "{\"code\":${response.statusCode},\"message\":\"Failed to initiate telebirr\"}";
      return TelePack.fromJson(jsonDecode(data));
    }
  }

  var exec = 0;
  Future<Result> confirmTransaction(String otn) async {
    String wait = "Please Wait we are processing";
    final response = await http.get(
        Uri.parse('$_baseUrl/confirm-telebirr/user-id/out-trade-number'),
        headers: <String, String>{'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'}
    ).timeout(
      const Duration(seconds: 1),
      onTimeout: () {
        return http.Response('Error', 408); // Request Timeout response status code
      });
    if (response.statusCode == 200) {
      Result result = Result("code", wait);
      return result;
    }
    else if(response.statusCode == 408){
      Result result = Result("code", "Unable To Confirm Payment: Timeout");
      return result;
    }
    else {
      Result result = Result("code", "Unable To Confirm Payment: code: ${response.statusCode}");
      return result;
    }
  }
}
