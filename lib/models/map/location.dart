import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class ReverseLocation extends Equatable {
  final String address1;
  

  const ReverseLocation({
    required this.address1,
  
  });

  @override
  List<Object> get props => [
        address1, //address2, address3, address4
      ];

  factory ReverseLocation.fromJson(Map<String, dynamic> json) {
    return ReverseLocation(
      address1: json["results"][0]["formatted_address"],
     
    );
  }

  @override
  String toString() => 'Location {address1: $address1 }';
}
