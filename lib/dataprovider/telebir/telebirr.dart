import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:driverapp/dataprovider/auth/auth.dart';
import '../../screens/credit/telebirr_data.dart';
import '../header/header.dart';

class TeleBirrDataProvider {
  final _baseUrl = RequestHeader.baseURL+'credits';
  final http.Client httpClient;
  TeleBirrDataProvider({required this.httpClient});

  Future<TelePack> initTelebirr(String user) async {
    print("init-telebirr");
    final response = await http.get(
      Uri.parse('$_baseUrl/initiate-telebirr'),
      //Uri.parse('https://app.hellotena.com/api/telebirr/confirmPayment/01245890-9dd9-4abd-a5d3-9fe1e9d39b2b/covid/covid'),
      headers: await RequestHeader().authorisedHeader()
    );
    if (response.statusCode == 200) {
      var data = TelePack.fromJson(jsonDecode(response.body));
      data.code = response.statusCode;
      data.message = "Success";
      return data;
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
        headers: await RequestHeader().authorisedHeader()
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
