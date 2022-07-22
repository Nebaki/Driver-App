import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Ticket {
  String? id;
  String? lotteryNumber;
  String? tripType;
  String? tripId;
  String? awardTypeId;
  String? candidatePhoneNumber;
  String? candidateName;
  String? candidateType;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Ticket(
      {this.id, this.lotteryNumber, this.tripType,
        this.tripId, this.awardTypeId, this.candidatePhoneNumber,
        this.candidateName,this.candidateType,this.isActive,this.createdAt,this.updatedAt});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json["id"] ?? "unknown",
      lotteryNumber: json["lottery_number"] ?? "unknown",
      tripType: json["trip_type"] ?? "unknown",
      tripId: json["trip_id"] ?? "unknown",
      awardTypeId: json["award_type_id"] ?? "unknown",
      candidatePhoneNumber: json["candidate_phone_number"] ?? "unknown",
      candidateName: json["candidate_name"] ?? "unknown",
      candidateType: json["candidate_type"] ?? "unknown",
      isActive: json["is_active"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"]
    );
  }

  @override
  String toString() => 'credit {'
      'id: $id,'
      'lotteryNumber: $lotteryNumber,'
      'tripType: $tripType,'
      'tripId: $tripId,'
      'awardTypeId: $awardTypeId,'
      'candidatePhoneNumber: $candidatePhoneNumber,'
      'candidateName: $candidateName,'
      'candidateType: $candidateType,'
      'isActive: $isActive,'
      'createdAt: $createdAt,'
      'updatedAt: $updatedAt,'
      '}';

  Ticket.fromStringObject(List<dynamic> parsedJson) {
    parsedJson.map((i) => Ticket.fromJson(i)).toList();
  }
}

class LotteryStore {
  List<Ticket>? lotteries;
  int total;
  LotteryStore({required this.lotteries,required this.total});

  LotteryStore.fromJson(List<dynamic> parsedJson,this.total) {
    lotteries = parsedJson.map((i) => Ticket.fromStringObject(i)).toList();
  }

  String toJson() {
    String data = jsonEncode(lotteries?.map((i) => i.toString()).toList());
    return data;
  }
}

