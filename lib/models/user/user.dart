import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class User extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? password;
  final String? email;
  final String? phoneNumber;
  final  String? gender;
  final String? emergencyContact;
  final String? profileImage;
  final String? fcm;
  final Map<String, dynamic>? preference;

  const User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.phoneNumber,
      this.gender,
      this.emergencyContact,
      this.preference,
      this.profileImage,
      this.fcm});

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        password,
        email,
        phoneNumber,
        gender,
        emergencyContact,
        profileImage,
      ];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        email: json["email"],
        gender: json["gender"],
        phoneNumber: json["phone_number"],
        emergencyContact: json["emergency_contact"],
        profileImage: json["profile_image"],
        fcm: json['fcm_id']);
  }

  @override
  String toString() => 'User {Id: $id }';
}
