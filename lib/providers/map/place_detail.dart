import 'dart:convert';
import 'package:driverapp/helper/constants.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';

class PlaceDetailDataProvider {

  final http.Client httpClient;

  PlaceDetailDataProvider({required this.httpClient});

  Future<PlaceDetail> getPlaceAddressDetails(String placeId) async {
    final _placeDetailUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";

    final response = await httpClient.get(Uri.parse(_placeDetailUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return PlaceDetail.fromJson(data);
    } else {
      throw Exception('Failed to load loaction');
    }
  }
}
