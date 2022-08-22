import 'dart:convert';

import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/helper/api_end_points.dart' as api;

import '../../utils/session.dart';
import '../header/header.dart';

class WeeklyEarningDataProvider {
  final http.Client httpClient;
  const WeeklyEarningDataProvider({required this.httpClient});

  Future<List<WeeklyEarning>> getWeeklyEarning(
      ) async {
    DateTime today = DateTime.now();
    DateTime weekDay = today.subtract(Duration(days: today.weekday-1));
    Session().logSuccess("datez", 'today: $today, weekday: $weekDay');
    http.Response response = await httpClient.get(
        Uri.parse(
            api.WeeklyEarningEndPoints.getWeeklyEarningEndPoint(weekDay, today)),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token':
          '${await AuthDataProvider(httpClient: httpClient).getToken()}'
        });
    Session().logSuccess("datez","response code: ${response.statusCode}, body: ${response.body}");
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      return json.map((e) => WeeklyEarning.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();
      if (res.statusCode == 200) {
        return getWeeklyEarning();
      } else {
        throw Exception(res.statusCode);
      }
    } else {
      throw "error";
    }
  }
}
class DailyEarningDataProvider {
  final http.Client httpClient;
  const DailyEarningDataProvider({required this.httpClient});
  Future<DailyEarning> getDailyEarning() async {
    final http.Response response = await httpClient.get(
        Uri.parse(api.DailyEarningEndPoints.getDailyEarningEndPoint()),
        headers: await RequestHeader().authorisedHeader());
    Session().logSession("dailyE", response.body);
    if (response.statusCode == 200) {
      final List maps = jsonDecode(response.body)['items'];
      final String totalEarning = jsonDecode(response.body)['totalEarning'];

      List<Trip> trips = maps.map((job) => Trip.fromJson(job)).toList();

      DailyEarning dailyEarning =
      DailyEarning(totalEarning: totalEarning, trips: trips);
      return dailyEarning;
    }  else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();
      if (res.statusCode == 200) {
        return getDailyEarning();
      } else {
        throw Exception(res.statusCode);
      }
    } else {
      throw "error";
    }
  }

}

