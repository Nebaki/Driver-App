import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';

// String geolocator =
//     "https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

// String reverseGeocoding =
//    "https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

class LocationPredictionDataProvider {
  final http.Client httpClient;

  LocationPredictionDataProvider({required this.httpClient});

  Future<List<LocationPrediction>> predictLocation(String location) async {
    final _baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$location&location=8.9806%2C38.7578&radius=500&types=geocode&key=AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

    final response = await httpClient.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List places = data["predictions"];
      return places.map((e) => LocationPrediction.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load loaction');
    }
  }
}
