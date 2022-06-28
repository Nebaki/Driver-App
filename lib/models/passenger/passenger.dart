import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
class Passenger extends Equatable {
  final String? id;
  final String? name;
  final String? password;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? emergencyContact;
  final String? profileImage;
  final String? fcmId;
  final LatLng? location;
  final String? ID;
  // Map<String, dynamic>? preference;

  const Passenger({
    this.ID,
    this.id,
    this.name,
    this.email,
    this.password,
    this.phoneNumber,
    this.gender,
    this.emergencyContact,
    this.profileImage,
    this.fcmId,
    this.location,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        password,
        email,
        phoneNumber,
        gender,
        profileImage,
        fcmId
        // emergencyContact,
      ];

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        gender: json["gender"],
        phoneNumber: json["phone_number"],
        emergencyContact: json["emergency_contact"] ?? '',
        profileImage: json["profile_image"] ?? '',
        fcmId: json['fcm_id'],
        location: json.containsKey('location')
            ? LatLng(json['location'][0], json['location'][1])
            : null,
        ID: json.containsKey('id') ? json['id'] : null);
  }

  @override
  String toString() =>
      'Passenger { id:$id, Name: $name, email: $email, Gender:$gender, phoneNumber: $phoneNumber, profileImage: $profileImage,fcmId:$fcmId }';
}
