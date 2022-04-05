import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip{
  String id;
  String date;
  String time;
  String from;
  String to;
  String price;
  LatLng origin;
  LatLng destination;
  Trip({required this.id,
    required this.date,
    required this.time,
    required this.from,
    required this.to,
    required this.price,
    required this.origin,
    required this.destination});
}