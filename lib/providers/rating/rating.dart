import 'dart:convert';
import '../providers.dart';
import 'package:driverapp/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:driverapp/helper/api_end_points.dart' as api;

class RatingDataProvider {
  final http.Client httpClient;
  const RatingDataProvider({required this.httpClient});

  Future<Rating> getMyRating() async {
    final http.Response response = await retry(
      () async => httpClient.get(
          Uri.parse(api.UserEndPoints.getMyRatingEndPoint()),
          headers: <String, String>{
            'x-access-token':
                "${await AuthDataProvider(httpClient: httpClient).getToken()}",
          }),
      maxAttempts: 2,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Rating.fromJson(data);
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();
      if (res.statusCode == 200) {
        return getMyRating();
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }
}
