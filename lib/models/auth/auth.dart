import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class Auth extends Equatable {
  String? token;
  String? id;
  String? name;
  String phoneNumber;
  String? password;
  String? email;
  String? emergencyContact;
  String? profilePicture;
  Map<String?, dynamic?>? pref;

  Auth(
      {this.id,
      this.token,
      this.email,
      this.emergencyContact,
      this.name,
      required this.phoneNumber,
      this.password,
      this.pref,
      this.profilePicture});

  @override
  List<Object?> get props => [phoneNumber, password];

  factory Auth.fromStorage(Map<String, dynamic> storage) {
    return Auth(
        id: storage["id"],
        token: storage["token"],
        phoneNumber: storage["phone_number"],
        name: storage["name"],
        emergencyContact: storage["emergency_contact"],
        email: storage["email"],
        profilePicture: storage["profile_image"],
        pref: {
          "gender": storage["driver_gender"],
          "min_rate": storage["min_rate"],
          "car_type": storage["car_type"]
        });
  }

  @override
  String toString() => 'Location {Phone Number: $phoneNumber }';
}
