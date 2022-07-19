import 'package:driverapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
class RideRequest extends Equatable {
  final String? id;
  final String? driverId;
  final String? driverFcm;
  final LatLng? pickupLocation;
  final LatLng? dropOffLocation;
  final String? pickUpAddress;
  final String? droppOffAddress;
  final String? status;
  final String? cancelReason;
  final String? price;
  final String? distance;
  final String? duration;
  final String? direction;
  final String? date;
  final String? time;
  final Passenger? passenger;
  final String? phoneNumber;
  final String? name;

  const RideRequest(
      {this.id,
      this.date,
      this.time,
      this.driverFcm,
      this.direction,
      this.duration,
      this.price,
      this.phoneNumber,
      this.name,
      this.status,
      this.distance,
      this.cancelReason,
      this.pickUpAddress,
      this.droppOffAddress,
      required this.driverId,
      this.pickupLocation,
      this.dropOffLocation,
      this.passenger});

  @override
  List<Object?> get props =>
      [id, driverId, pickupLocation, dropOffLocation, passenger];

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
        id: json["id"],
        driverId: json["driver_id"] ?? '',
        pickupLocation:
            LatLng(json["pickup_location"][0], json["pickup_location"][1]),
        dropOffLocation:
            LatLng(json["drop_off_location"][0], json["drop_off_location"][1]),
        direction: json['direction'],
        pickUpAddress: json["pickup_address"] ?? '',
        droppOffAddress: json["drop_off_address"] ?? '',
        status: json['status'],
        price: json['price'].toString(),
        distance: json['distance'].toString(),
        passenger: json.containsKey('passenger')
            ? Passenger.fromJson(json['passenger'])
            : const Passenger(name: 'Uknown Customer'));
  }

  @override
  String toString() => 'RideRequest {DriverId: $driverId }';
}
