import 'package:driverapp/models/category/category.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class Auth extends Equatable {
  String? token;
  String? id;
  String? name;
  String? lastName;
  String phoneNumber;
  String? password;
  String? email;
  String? emergencyContact;
  String? profilePicture;
  String? vehicleCategory;
  Map<String?, dynamic?>? pref;
  double? avgRate;
  int? balance;
  String? vehicleType;
  // final Category category;
  int? perKiloMeterCost;
  int? perMinuteCost;
  int? initialFare;

  Auth({
    this.id,
    this.token,
    this.email,
    this.emergencyContact,
    this.name,
    this.lastName,
    required this.phoneNumber,
    this.password,
    this.pref,
    this.profilePicture,
    this.avgRate,
    this.vehicleCategory,
    this.balance,
    this.vehicleType,
    // required this.category,
    this.perKiloMeterCost,
    this.perMinuteCost,
    this.initialFare,
  });

  @override
  List<Object?> get props => [phoneNumber, password];

  factory Auth.fromStorage(Map<String, dynamic> storage) {
    return Auth(
        id: storage["id"],
        token: storage["token"],
        phoneNumber: storage["phone_number"],
        name: storage["name"],
        lastName: storage['last_name'],
        emergencyContact: storage["emergency_contact"],
        email: storage["email"],
        profilePicture: storage["profile_image"],
        vehicleCategory: storage['vehicle_category'],
        vehicleType: storage['vehicle_type'],
        avgRate: storage.containsKey('avg_rate')
            ? double.parse(storage['avg_rate'])
            : 0,
        pref: {
          "gender": storage["driver_gender"],
          "min_rate": storage["min_rate"],
          "car_type": storage["car_type"]
        },
        balance:
            storage.containsKey('balance') ? double.parse(storage['balance']).toInt() : 0,
        perMinuteCost: int.parse(storage['per_minute_cost']),
        perKiloMeterCost: int.parse(storage['per_killo_meter_cost']),
        initialFare: int.parse(storage['initial_fare']));
  }

  @override
  String toString() => 'Location {Phone Number: $phoneNumber }';
}
