import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class User extends Equatable {
  String? id;
  String? firstName;
  String? lastName;
  String? password;
  String? email;
  String? phoneNumber;
  String? gender;
  String? emergencyContact;
  String? profileImage;
  String? fcm;
  Map<String, dynamic>? preference;

  User(
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
