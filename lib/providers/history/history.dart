import 'dart:convert';
import 'dart:math';
import 'package:driverapp/models/trip/trip.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../helper/helper.dart';
import '../../models/weekly_earning/daily_earning.dart';
import '../../utils/session.dart';
import '../auth/auth.dart';
import '../header/header.dart';
import 'package:http/http.dart' as http;

class HistoryDataProvider {
  final _baseUrl = RequestHeader.baseURL + 'ride-requests';
  final http.Client httpClient;

  HistoryDataProvider({required this.httpClient});

  Future<String> loadTripHistory() async {
    final http.Response response = await http.get(
        Uri.parse('$_baseUrl/get-driver-trips'),
        headers: await RequestHeader().authorisedHeader());

    if (response.statusCode == 200) {
      final int size = jsonDecode(response.body)['total'];
      Session().logSession("sz-trans $size", response.body);
      return response.statusCode.toString();
    } else {
      Session().logSession("s-trans", response.statusCode.toString());
      return response.statusCode.toString();
    }
  }

  Future<TripStore> loadTripHistoryDB(BuildContext context,page, limit) async {
    final http.Response response = await http.get(
        Uri.parse(
            '$_baseUrl/get-driver-trips?orderBy[0].[field]=createdAt&'
                'orderBy[0].[direction]=desc&top=$limit&skip=$page'),
        headers: await RequestHeader().authorisedHeader());

    if (response.statusCode == 200) {
      final List maps = jsonDecode(response.body)['items'];
      final int total = jsonDecode(response.body)['total'];

      List<Trip> trips = maps.map((job) => Trip.fromJson(job)).toList();

      Session().logSession("sz-trans $total", response.body);
      return TripStore(trips: trips, total: total);
    } else {
      if(response.statusCode == 401){
        _refreshToken(loadTripHistoryDB, context);
      }
      Session().logSession("s-trans", response.statusCode.toString());
      List<Trip> trips = [];
      return TripStore(trips: trips, total: 0);
    }
  }
  _refreshToken(Function function, BuildContext context) async {
    final res =
    await AuthDataProvider(httpClient: http.Client()).refreshToken();
    if (res.statusCode == 200) {
      return function();
    } else {
      gotoSignIn(context);
    }
  }
  String getRandNum() {
    var rng = Random();
    print(rng.nextInt(999));
    return rng.nextInt(9999).toString();
  }

  Future<DailyEarning> dailyEarning() async {
    final http.Response response = await httpClient.get(
        Uri.parse('$_baseUrl/get-my-todays-earning'),
        headers: await RequestHeader().authorisedHeader());
    if (response.statusCode == 200) {
      final List maps = jsonDecode(response.body)['items'];
      final String totalEarning = jsonDecode(response.body)['totalEarning'];

      List<Trip> trips = maps.map((job) => Trip.fromJson(job)).toList();

      DailyEarning dailyEarning =
          DailyEarning(totalEarning: totalEarning, trips: trips);
      return dailyEarning;
    } else {
      List<Trip> trips = [];
      return DailyEarning(totalEarning: response.statusCode.toString(), trips: trips);
    }
  }


  Future<DailyEarning> weeklyEarning() async {
    final http.Response response = await httpClient.get(
        Uri.parse('$_baseUrl/get-weekly-credit'),
        headers: await RequestHeader().authorisedHeader());
    if (response.statusCode == 200) {
      final List maps = jsonDecode(response.body)['items'];
      final double totalEarning = jsonDecode(response.body)['totalEarning'];

      List<Trip> trips = maps.map((job) => Trip.fromJson(job)).toList();

      DailyEarning dailyEarning =
          DailyEarning(totalEarning: totalEarning.toString(), trips: trips);
      return dailyEarning;
    } else {
      String totalEarning = "0 ${response.statusCode}";
      List<Trip> trips = [];
      return DailyEarning(totalEarning: totalEarning.toString(), trips: trips);
    }
  }
}
