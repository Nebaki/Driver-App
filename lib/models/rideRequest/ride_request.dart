import 'package:driverapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
class RideRequest extends Equatable {
  String? id;
  String? driverId;
  String? driverFcm;
  LatLng? pickupLocation;
  LatLng? dropOffLocation;
  String? pickUpAddress;
  String? droppOffAddress;
  String? status;
  String? cancelReason;
  String? price;
  String? distance;
  String? duration;
  String? direction;
  String? date;
  String? time;
  Passenger? passenger;
  String? phoneNumber;
  String? name;

  RideRequest(
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
    return json['passenger'] != null
        ? RideRequest(
            id: json["id"],
            driverId: json["driver_id"] ?? '',
            // pickupLocation:
            //     LatLng(json["pickup_location"][0], json["pickup_location"][1]),
            // dropOffLocation:
            //     LatLng(json["droppoff_location"][1], json["droppoff_location"][0]),
            // direction: json['direction'],
            pickUpAddress: json["pickup_address"] ?? '',
            droppOffAddress: json["droppoff_address"] ?? '',
            status: json['status'],
            // price: json['price'].toString(),
            // distance: json['distance'].toString(),
            passenger: Passenger.fromJson(json['passenger'])
            // date: DateFormat.yMMMMEEEEd().format(now),
            // time: DateFormat.jm().format(now)
            )
        : RideRequest(
            id: json["id"],
            driverId: json["driver_id"] ?? '',
            // pickupLocation:
            //     LatLng(json["pickup_location"][0], json["pickup_location"][1]),
            // dropOffLocation:
            //     LatLng(json["droppoff_location"][1], json["droppoff_location"][0]),
            // direction: json['direction'],
            pickUpAddress: json["pickup_address"] ?? '',
            droppOffAddress: json["droppoff_address"] ?? '',
            status: json['status'],
            // price: json['price'].toString(),
            // distance: json['distance'].toString(),
            // date: DateFormat.yMMMMEEEEd().format(now),
            // time: DateFormat.jm().format(now)
          );
  }

  @override
  String toString() => 'RideRequest {DriverId: $driverId }';
}
