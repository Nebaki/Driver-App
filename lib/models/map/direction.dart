import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class Direction extends Equatable {
  String durationText;
  String distanceText;
  int durationValue;
  int distanceValue;
  String encodedPoints;

  Direction(
      {required this.durationText,
      required this.distanceText,
      required this.durationValue,
      required this.distanceValue,
      required this.encodedPoints});

  @override
  List<Object> get props =>
      [durationText, distanceText, durationValue, distanceValue];

  factory Direction.fromJson(Map<String, dynamic> json) {
    return Direction(
        durationText: json["routes"][0]["legs"][0]["duration"]["text"],
        distanceText: json["routes"][0]["legs"][0]["distance"]["text"],
        durationValue: json["routes"][0]["legs"][0]["duration"]["value"],
        distanceValue: json["routes"][0]["legs"][0]["distance"]["value"],
        encodedPoints: json["routes"][0]["overview_polyline"]["points"]);
  }

  @override
  String toString() =>
      'Location {Duration Text: $durationText , Distance Text: $distanceText, Duration Value: $durationValue, Distance Value: $distanceValue, Encoded Points: $encodedPoints}';
}
