import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
class RideRequest extends Equatable {
  String? id;
  String? driverId;
  LatLng? pickupLocation;
  LatLng? dropOffLocation;
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
