import 'dart:convert';
import 'dart:math';

// import 'package:dio/dio.dart';
import 'package:driverapp/dataprovider/header/header.dart';
import 'package:driverapp/utils/session.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';

import '../../screens/credit/telebirr_data.dart';
import '../auth/auth.dart';

class CreditDataProvider {
  final _baseUrl = RequestHeader.baseURL + 'credits';
  final http.Client httpClient;

  AuthDataProvider authDataProvider =
  AuthDataProvider(httpClient: http.Client());
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

  Future<Result> transferCredit(String receiverPhone, String amount) async {
    var phone = "+251" + receiverPhone.trim().replaceAll(' ', '');
    Session().logSession("phone", phone);
    final response = await http.post(
      Uri.parse('$_baseUrl/transfer-credit'),
      headers: await RequestHeader().authorisedHeader(),
      body: json.encode({
        'receiver_phone': phone,
        'amount': int.parse(amount),
      }),
    );

    if (response.statusCode == 200) {
      //var data = jsonDecode(response.body)["message"];
      var balance = jsonDecode(response.body)["balance"];
      var message =
          "You Transferred $amount to $phone successfully, your remaining balance is $balance";
      return Result(response.statusCode.toString(), true, message);
    } else {
      var message = jsonDecode(response.body)["message"];
      return RequestResult()
          .requestResult(response.statusCode.toString(), message);
    }
  }

  Future<Result> loadBalance() async {
    final http.Response response = await httpClient.get(
        Uri.parse('$_baseUrl/get-my-credit'),
        headers: await RequestHeader().authorisedHeader());
    if (response.statusCode == 200) {
      var balance = jsonDecode(response.body);
      Session().logSession("balance", balance["balance"].toString());
      return Result(
          response.statusCode.toString(), true, balance["balance"].toString());
    } else {
      return RequestResult()
          .requestResult(response.statusCode.toString(), response.body);
    }
  }


  Future<CreditStore> loadCreditHistory(page, limit) async {
    String user = await authDataProvider.getUserId() ?? "null";
    final http.Response response = await http.get(
      Uri.parse('$_baseUrl/get-driver-credit-transactions?'
          'driver_id=$user&orderBy[0].[field]=createdAt&'
          'orderBy[0].[direction]=desc&top=$limit&skip=$page'),
      headers: await RequestHeader().authorisedHeader(),
    );
    Session().logSession("history", "user: $user -> ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      Session().logSession("history", "success");
      Credit credit;

      final List maps = jsonDecode(response.body)['items'];
      final int size = jsonDecode(response.body)['total'];
      List<Credit> credits = maps.map((job) => Credit.fromJson(job)).toList();

      Session().logSession("trans", response.body);
      return CreditStore(trips: credits,total: size);
      //return CreditStore.fromJson(jsonDecode(response.body));
    } else {
      Session().logSession("history", "failure");
      Credit credit;
      List<Credit> credits = [];
      int i = 0;
      while (i < 10) {
        var rng = Random();
        int money = rng.nextInt(100) * i + 237;
        var type = i % 2 == 0 ? 'Gift' : 'Message';
        if (i == 4 || i == 8) {
          type = "Message";
        }
        credit = Credit(
            id: "$i vic",
            title: "Money Received $i",
            message: "Hello! you received nothing, Thanks",
            type: type,
            amount: "$money.ETB",
            date: "Today");
        //credits.add(credit);
        i++;
      }
      if(response.statusCode == 401){
        _refreshToken(loadCreditHistory);
      }
      return CreditStore(trips: credits,total: 10);
    }
  }
  _refreshToken(Function function) async {
    final res =
    await AuthDataProvider(httpClient: http.Client()).refreshToken();
    if (res.statusCode == 200) {
      return function();
    }
  }
  Future<Result> requestCredit(String amount) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/request-credit'),
      headers: await RequestHeader().authorisedHeader(),
      body: json.encode({
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      return Result(response.statusCode.toString(), true, "done");
    } else {
      var message = jsonDecode(response.body)["message"];
      return RequestResult()
          .requestResult(response.statusCode.toString(), message);
    }
  }
}
