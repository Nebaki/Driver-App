import 'dart:convert';

import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/helper/api_end_points.dart' as api;

class WeeklyEarningDataProvider {
  final http.Client httpClient;
  const WeeklyEarningDataProvider({required this.httpClient});

  Future<List<WeeklyEarning>> getWeeklyEarning(
      ) async {
        DateTime today = DateTime.now();
        DateTime weekDay = today.subtract(Duration(days: today.weekday-1));
    http.Response response = await httpClient.get(
        Uri.parse(
            api.WeeklyEarningEndPoints.getWeeklyEarningEndPoint(weekDay, today)),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token':
              '${await AuthDataProvider(httpClient: httpClient).getToken()}'
        });
    print("response ${response.statusCode} resposebody${response.body}");
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      return json.map((e) => WeeklyEarning.fromJson(e)).toList();
    } else if (response.statusCode == 200) {
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
