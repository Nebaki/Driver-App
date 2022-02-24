import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';

class PlaceDetailDataProvider {
  final String _api_key = "AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

  final http.Client httpClient;

  PlaceDetailDataProvider({required this.httpClient});

  Future<PlaceDetail> getPlaceAddressDetails(String placeId) async {
    final _placeDetailUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_api_key";

    final response = await httpClient.get(Uri.parse(_placeDetailUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return PlaceDetail.fromJson(data);
    } else {
      throw Exception('Failed to load loaction');
    }
  }
}
