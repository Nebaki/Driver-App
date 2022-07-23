import 'dart:convert';
import 'dart:math';

// import 'package:dio/dio.dart';
import 'package:driverapp/dataprovider/header/header.dart';
import 'package:driverapp/utils/session.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';

import '../auth/auth.dart';

class LotteryDataProvider {
  final _baseUrl = RequestHeader.baseURL + 'lottery-numbers';
  final _baseUrlA = RequestHeader.baseURL + 'awards';
  final http.Client httpClient;

  AuthDataProvider authDataProvider =
  AuthDataProvider(httpClient: http.Client());
  LotteryDataProvider({required this.httpClient});

  Future<LotteryStore> loadLotteryTickets(page, limit) async {
    String user = await authDataProvider.getUserId() ?? "null";
    final http.Response response = await http.get(
      Uri.parse('$_baseUrl/get-my-lottery-numbers?'
          'driver_id=$user&orderBy[0].[field]=createdAt&'
          'orderBy[0].[direction]=desc&top=$limit&skip=$page'),
      headers: await RequestHeader().authorisedHeader(),
    );
    Session().logSession("lottery", "user: $user -> ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      Session().logSession("ticket", "success");
      Credit credit;

      final List maps = jsonDecode(response.body)['items'];
      final int size = jsonDecode(response.body)['total'];
      List<Ticket> lotteries = maps.map((job) => Ticket.fromJson(job)).toList();

      Session().logSession("ticket", response.body);
      return LotteryStore(lotteries: lotteries,total: size);
      //return CreditStore.fromJson(jsonDecode(response.body));
    } else {
      Session().logSession("ticket", "failure");
      Credit credit;
      List<Ticket> lotteries = [];
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
        _refreshToken(loadLotteryTickets);
      }
      return LotteryStore(lotteries: lotteries,total: 10);
    }
  }
  _refreshToken(Function function) async {
    final res =
    await AuthDataProvider(httpClient: http.Client()).refreshToken();
    if (res.statusCode == 200) {
      return function();
    }
  }



  Future<AwardStore> loadLotteryAwards(page, limit) async {
    String id = await authDataProvider.getUserId() ?? "null";
    Auth user = await authDataProvider.getUserData();
    Session().logSession("category", "user: ${user.vehicleType}");

    final http.Response response = await http.get(
      Uri.parse('$_baseUrlA/get-award-types?'
          'driver_id=$id&orderBy[0].[field]=createdAt&'
          'orderBy[0].[direction]=desc&top=$limit&skip=$page'
          //'&type=${user.vehicleCategory}'
      ),
      headers: await RequestHeader().authorisedHeader(),
    );
    Session().logSession("lottery", "user: $user -> ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      Session().logSession("award", "success");
      Credit credit;

      final List maps = jsonDecode(response.body)['items'];
      final int size = jsonDecode(response.body)['total'];
      List<Award> awards = maps.map((job) => Award.fromJson(job)).toList();

      Session().logSession("award", response.body);
      return AwardStore(awards: awards,total: size);
      //return CreditStore.fromJson(jsonDecode(response.body));
    } else {
      Session().logSession("award", "failure");
      Credit credit;
      List<Award> awards = [];
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
        _refreshToken(loadLotteryTickets);
      }
      return AwardStore(awards: awards,total: 10);
    }
  }
}
