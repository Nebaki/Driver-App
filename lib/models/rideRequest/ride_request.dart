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
  String? passengerName;
  String? pickUpAddress;
  String? passengerPhoneNumber;
  String? droppOffAddress;
  String? status;
  String? cancelReason;
  String? price;
  String? distance;
  String? duration;
  String? direction;
  String? date;
  String? time;
  RideRequest({
    this.id,
    this.date,
    this.time,
    this.driverFcm,
    this.direction,
    this.duration,
    this.price,
    this.status,
    this.distance,
    this.cancelReason,
    this.passengerPhoneNumber,
    this.pickUpAddress,
    this.droppOffAddress,
    required this.driverId,
    this.passengerName,
    this.pickupLocation,
    this.dropOffLocation,
  });

  @override
  List<Object?> get props =>
      [id, driverId, passengerName, pickupLocation, dropOffLocation];

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      id: json["id"],
      driverId: json["driver_id"] ?? '',
      // pickupLocation: json["rideRequest"]["pickupLocation"],
      // dropOffLocation: json["passenger"]["gender"],
      // passengerPhoneNumber: json["rideRequest"]["passengerName"],
      direction: json['direction'],
      pickUpAddress: json["pickup_address"] ?? '',
      droppOffAddress: json["droppoff_address"] ?? '',
      status: json['status'],
      price: json['price'].toString(),
      distance: json['distance'].toString(),
      // date: DateFormat.yMMMMEEEEd().format(now),
      // time: DateFormat.jm().format(now)
    );
  }

  @override
  String toString() => 'RideRequest {DriverId: $driverId }';
}
