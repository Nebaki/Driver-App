import 'dart:convert';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/utils/session.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';

class DirectionDataProvider {
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
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey";

    final response = await httpClient.get(Uri.parse(_directionUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Direction.fromJson(data);
    } else {
      throw Exception('Failed to load loaction');
    }
  }

  Future<Direction> getDirectionFromDifrentPickupLocation(
      LatLng pickupLocation, LatLng destination) async {
    final _directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${pickupLocation.latitude},${pickupLocation.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey";

    final response = await httpClient.get(Uri.parse(_directionUrl));
    Session().logSession("getBlack", response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Direction.fromJson(data);
    } else {
      throw Exception('Failed to load loaction');
    }
  }
}
