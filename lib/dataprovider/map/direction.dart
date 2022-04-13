import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';

class DirectionDataProvider {
  final String _api_key = "AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

  Future<Position> _determinePosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  final http.Client httpClient;

  DirectionDataProvider({required this.httpClient});

  Future<Direction> getDirection(LatLng destination) async {
    Position p = await _determinePosition();
    final initialPosition = LatLng(p.latitude, p.longitude);

    final _directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_api_key";

    final response = await httpClient.get(Uri.parse(_directionUrl));


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Direction.fromJson(data);
    } else {
      throw Exception('Failed to load loaction');
    }
  }
}
