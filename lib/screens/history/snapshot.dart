import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SnapShot{
  Uint8List image;
  SnapShot(this.image);
  Map<MarkerId, Marker> markers = {};

  Map<PolylineId, Polyline> polylines = {};

  List<LatLng> polylineCoordinates = [];

  String googleAPiKey = "AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

  String base64image = "";

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }
}