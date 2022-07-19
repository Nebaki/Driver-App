import 'dart:convert';

import 'package:driverapp/utils/session.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/dataprovider/auth/auth.dart';
import '../../screens/credit/telebirr_data.dart';
import '../header/header.dart';

class TeleBirrDataProvider {
  final _baseUrl = RequestHeader.baseURL + 'credits';
  final http.Client httpClient;

  TeleBirrDataProvider({required this.httpClient});

  Future<TelePack> initTelebirr(String user) async {
    print("init-telebirr");
    final response = await http.get(Uri.parse('$_baseUrl/initiate-telebirr'),
        headers: await RequestHeader().authorisedHeader());
    if (response.statusCode == 200) {
      //Session().logSession("telebirr", response.body);
      var data =
          TelePack.fromJson(jsonDecode(response.body), response.statusCode);
      //data.code = response.statusCode;
      data.message = "Success";
      Session().logSession("telebirr", data.toString());
      return data;
    } else {
      print("init-telebirr ${response.statusCode}");
      String data =
          "{\"code\":${response.statusCode},\"message\":\"Failed to initiate telebirr\"}";
      return TelePack.fromJson(jsonDecode(data), response.statusCode);
    }
  }

  var exec = 0;

  Future<Result> confirmTransaction(String otn) async {
    String wait = "Please Wait we are processing";
    Session().logSession("recharge", "otn $otn)");
    final response = await http
        .get(Uri.parse('$_baseUrl/confirm-telebirr/$otn'),
            headers: await RequestHeader().authorisedHeader())
        .timeout(const Duration(seconds: 60), onTimeout: () {
      return http.Response('Error', 408); // Request Timeout response status code
    });
    print("Statttttttttttttttt ${response.statusCode}");
    if (response.statusCode == 200) {
      String status = jsonDecode(response.body)["status"];
      if (status == "2") {
        Session().logSession("recharge", "success at $exec)");
        wait = "Your Credit Recharged successfully";
        return Result(response.statusCode.toString(), false, wait);
      } else{
        while(exec < 3){
          Session().logSession("recharge", "at $exec)");
          await Future.delayed(const Duration(seconds: 5));
          exec += 1;
          confirmTransaction(otn);
        }
        Session().logSession("recharge", "at run)");
        wait = "Unable to confirm your payment";
        return Result(response.statusCode.toString(), false, wait);
      }
    } else {
      Session().logSession("recharge", "failed ${response.statusCode}");
      if(response.statusCode == 408){
        while(exec < 3){
          Session().logSession("recharge", "at 408)");
          await Future.delayed(const Duration(seconds: 5));
          exec += 1;
          confirmTransaction(otn);
        }
      }
      return Result(response.statusCode.toString(), false, "Unable to confirm your payment");
    }
  }
}
