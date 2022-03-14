import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class RideRequest extends Equatable {
  String? id;
  String? driverId;
  double? pickupLocation;
  double? dropOffLocation;
  String passengerName;

  RideRequest({
    this.id,
    required this.driverId,
    required this.passengerName,
    this.pickupLocation,
    this.dropOffLocation,
  });

  @override
  List<Object?> get props =>
      [id, driverId, passengerName, pickupLocation, dropOffLocation];

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    print("this is the response data ${json["rideRequest"]["id"]}");
    return RideRequest(
      id: json["rideRequest"]["id"],
      driverId: json["rideRequest"]["driverId"],
      // pickupLocation: json["rideRequest"]["pickupLocation"],
      // dropOffLocation: json["passenger"]["gender"],
      passengerName: json["rideRequest"]["passengerName"],
    );
  }

  @override
  String toString() => 'RideRequest {DriverId: $driverId }';
}
