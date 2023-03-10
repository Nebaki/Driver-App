import 'dart:convert';
import '../header/header.dart';
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
          'orderBy[0].[direction]=desc&top=$limit&skip=$page&is_active=true'),
      headers: await RequestHeader().authorisedHeader(),
    );
    Session().logSession("lottery", "user: $user -> ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      Session().logSession("ticket", "success");

      final List maps = jsonDecode(response.body)['items'];
      final int size = jsonDecode(response.body)['total'];
      List<Ticket> lotteries = maps.map((job) => Ticket.fromJson(job)).toList();

      Session().logSession("ticket", response.body);
      return LotteryStore(lotteries: lotteries,total: size);
    } else {
      Session().logSession("ticket", "failure");
      List<Ticket> lotteries = [];
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
    var driverTypeR = user.vehicleType;
    var driverType = '${driverTypeR?.toLowerCase()}_driver';
    Session().logSession("award", "driver_type: $driverType");

    final http.Response response = await http.get(
      Uri.parse('$_baseUrlA/get-award-types-by-type?'
          'driver_id=$id&orderBy[0].[field]=createdAt&'
          'orderBy[0].[direction]=desc&top=$limit&skip=$page'
          '&type=$driverType&is_active=true'
      ),
      headers: await RequestHeader().authorisedHeader(),
    );
    Session().logSession("award", "user: $user -> ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      Session().logSession("award", "success");
      Credit credit;

      final List maps = jsonDecode(response.body)['items'];
      final int size = jsonDecode(response.body)['total'];
      List<Award> awards = maps.map((job) => Award.fromJson(job)).toList();

      Session().logSession("award", 'size $size');
      return AwardStore(awards: awards,total: size);
    } else {
      Session().logSession("award", "failure");
      List<Award> awards = [];
      if(response.statusCode == 401){
        _refreshToken(loadLotteryTickets);
      }
      return AwardStore(awards: awards,total: 10);
    }
  }
}
