import 'dart:convert';
import 'package:driverapp/dataprovider/auth/auth.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/helper/api_end_points.dart';

class BalanceDataProvider {
  final http.Client httpClient;
  BalanceDataProvider({required this.httpClient});
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());
  Future<double> getMyBalance() async {
    final http.Response response = await http.get(
        Uri.parse(CreditEndPoints.getMyBalanceEndpoint()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'
        });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return double.parse((jsonResponse['balance']).toString());
    } else {
      throw Exception('Unable To Load Balance');
    }
  }
}
