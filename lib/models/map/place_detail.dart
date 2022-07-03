import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class PlaceDetail extends Equatable {
  final String placeName;
  final String placeId;
  final double lat;
  final double lng;

  const PlaceDetail(
      {required this.placeName,
      required this.placeId,
      required this.lat,
      required this.lng});

  @override
  List<Object> get props => [placeName, placeId, lat, lng];

  factory PlaceDetail.fromJson(Map<String, dynamic> json) {
    return PlaceDetail(
        placeName: json["result"]["name"],
        placeId: json["result"]["place_id"],
        lat: json["result"]["geometry"]["location"]["lat"],
        lng: json["result"]["geometry"]["location"]["lng"]);
  }

  @override
  String toString() =>
      'Location {Place Name: $placeName , PlaceId: $placeId, }';
}
