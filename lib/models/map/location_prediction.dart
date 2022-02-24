import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class LocationPrediction extends Equatable {
  String placeId;
  String mainText;
  String secondaryText;

  LocationPrediction(
      {required this.placeId,
      required this.mainText,
      required this.secondaryText});

  @override
  List<Object> get props => [mainText, secondaryText];

  factory LocationPrediction.fromJson(Map<String, dynamic> json) {
    return LocationPrediction(
        placeId: json["place_id"],
        mainText: json["structured_formatting"]["main_text"],
        secondaryText:
            json["structured_formatting"]["secondary_text"] ?? "Uknown");
  }

  @override
  String toString() =>
      'Location {PlaceId: $placeId, Main Text: $mainText, Secondary Text: $secondaryText }';
}
