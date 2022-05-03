import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class ReverseLocation extends Equatable {
  String address1;
  // String address2;
  // String address3;
  // String address4;

  ReverseLocation({
    required this.address1,
    // required this.address2,
    // required this.address3,
    // required this.address4
  });

  @override
  List<Object> get props => [
        address1, //address2, address3, address4
      ];

  factory ReverseLocation.fromJson(Map<String, dynamic> json) {
    return ReverseLocation(
      address1: json["results"][0]["formatted_address"],
      // address2: json["address2"],
      // address3: json["address3"],
      // address4: json["address4"]
    );
  }

  @override
  String toString() => 'Location {address1: $address1 }';
}
