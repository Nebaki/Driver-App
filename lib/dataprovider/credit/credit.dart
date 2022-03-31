import 'dart:convert';
import 'dart:math';

// import 'package:dio/dio.dart';
import 'package:driverapp/dataprovider/header/header.dart';
import 'package:driverapp/screens/credit/credit_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/dataprovider/auth/auth.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/repository/auth.dart';

import '../../screens/credit/telebirr_data.dart';

class CreditDataProvider {
  final _baseUrl = RequestHeader.baseURL+'credit';
  final http.Client httpClient;
  CreditDataProvider({required this.httpClient});

  Future<User> rechargeCredit(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-credit'),
      headers: await RequestHeader().authorisedHeader(),
      body: json.encode({
        'name': user.firstName,
        'email': user.email,
        'gender': user.gender,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to recharge credit.');
    }
  }
  Future<Result> transferCredit(String receiverPhone,String amount) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/transfer-credit'),
      headers: await RequestHeader().authorisedHeader(),
      body: json.encode({
        'senderPhone': "0922877115",
        'receiverPhone': receiverPhone,
        'amount': amount,
        'senderName': "winux",
      }),
    );

    if (response.statusCode == 200) {
      return Result(response.statusCode.toString(),true, response.body);
    } else {
      return RequestResult().requestResult(response.statusCode.toString(), response.body);
    }
  }


  Future<Result> loadBalance(String id) async {
    final http.Response response = await httpClient.get(
        Uri.parse('$_baseUrl/$id/load-credit-balance'),
        headers: await RequestHeader().authorisedHeader());
    if(response.statusCode == 200){
      return Result(response.statusCode.toString(),true, response.body);
    }
    else{
      return RequestResult().requestResult(response.statusCode.toString(), response.body);
    }
  }

  Future<CreditStore> loadCreditHistory(String user) async {
    final http.Response response = await http.post(
      Uri.parse('$_baseUrl/load-credit-history'),
      headers: await RequestHeader().authorisedHeader()
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

}

