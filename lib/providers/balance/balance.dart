import 'dart:convert';
import '../../utils/session.dart';
import '../auth/auth.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/helper/api_end_points.dart';

import '../header/header.dart';

class BalanceDataProvider {
  final _baseUrl = RequestHeader.baseURL + 'credits';
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
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return getMyBalance();
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception('Unable To Load Balance');
    }
  }
  Future<String> getBalanceCredit() async {
    final http.Response response = await http.get(
        Uri.parse('$_baseUrl/get-my-credit'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'
        });

    Session().logSession("balance", response.body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      var balance = jsonDecode(response.body)["balance"];
      var credit = jsonDecode(response.body)["credit"]['amount'];
      //Session().logSession("balance", balance["balance"].toString());
      //Session().logSession("credit", credit.toString());
      //String data = '$balance|$credit';
      return "$balance|$credit";
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();
      if (res.statusCode == 200) {
        return getBalanceCredit();
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      Session().logSession("history", response.statusCode.toString());
      throw Exception('Unable To Load Balance');
    }
  }


  Future<String> getTransaction() async {
    final http.Response response = await http.get(
        Uri.parse('$_baseUrl/get-my-credit'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': '${await authDataProvider.getToken()}'
        });

    Session().logSession("balance", response.body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      var balance = jsonDecode(response.body)["balance"];
      var credit = jsonDecode(response.body)["credit"]['amount'];
      //Session().logSession("balance", balance["balance"].toString());
      //Session().logSession("credit", credit.toString());
      //String data = '$balance|$credit';
      return "$balance|$credit";
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();
      if (res.statusCode == 200) {
        return getBalanceCredit();
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      Session().logSession("history", response.statusCode.toString());
      throw Exception('Unable To Load Balance');
    }
  }

}
