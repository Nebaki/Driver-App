import 'dart:convert';

import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/helper/api_end_points.dart' as api;

class WeeklyEarningDataProvider {
  final http.Client httpClient;
  const WeeklyEarningDataProvider({required this.httpClient});

  Future<List<WeeklyEarning>> getWeeklyEarning(
      DateTime from, DateTime to) async {
    http.Response response = await httpClient.get(
        Uri.parse(
            api.WeeklyEarningEndPoints.getWeeklyEarningEndPoint(from, to)),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token':
              '${await AuthDataProvider(httpClient: httpClient).getToken()}'
        });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      return json.map((e) => WeeklyEarning.fromJson(e)).toList();
    } else if (response.statusCode == 200) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();
      if (res.statusCode == 200) {
        return getWeeklyEarning(from, to);
      } else {
        throw Exception(res.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }
}
