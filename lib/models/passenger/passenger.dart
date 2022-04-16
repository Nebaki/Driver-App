import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class Passenger extends Equatable {
  String? id;
  String? name;
  String? password;
  String? email;
  String? phoneNumber;
  String? gender;
  String? emergencyContact;
  String? profileImage;
  String? fcmId;
  // Map<String, dynamic>? preference;

  Passenger(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phoneNumber,
      this.gender,
      this.emergencyContact,
      this.profileImage,
      this.fcmId});

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
        fcmId: json['fcm_id']);
  }

  @override
  String toString() =>
      'Passenger { id:$id, Name: $name, email: $email, Gender:$gender, phoneNumber: $phoneNumber, profileImage: $profileImage,fcmId:$fcmId }';
}
