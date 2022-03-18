import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:driverapp/dataprovider/auth/auth.dart';
import '../../screens/credit/credit_form.dart';

class TeleBirrDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/drivers';
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  TeleBirrDataProvider({required this.httpClient});

  Future<TelePack> initTelebirr(String user) async {
    final response = await http.get(
      //Uri.parse('$_baseUrl/init-telebirr'),
      Uri.parse('https://app.hellotena.com/api/telebirr/confirmPayment/01245890-9dd9-4abd-a5d3-9fe1e9d39b2b/covid/covid'),
      /*headers: <String, String>{'Content-Type': 'application/json',
        'x-access-token': '${await authDataProvider.getToken()}'}*/
    );

    if (response.statusCode == 200) {
      return TelePack.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load telebirr data. ${response.statusCode}');
    }
  }

  Future<Result> confirmTransaction(String otn) async {
    String wait = "Please Wait we are processing";
    final response = await http.get(
        Uri.parse('$_baseUrl/confirm-telebirr/user-id/out-trade-number'),
        headers: <String, String>{'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'}
    );
    if (response.statusCode == 200) {
      Result result = Result("code", wait);
      return result;
    } else {
      Result result = Result("code", "Unable To Confirm Payment: code: ${response.statusCode}");
      return result;
    }
  }
}
