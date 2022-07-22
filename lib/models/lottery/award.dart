import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Award {
  String? id;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? awardFor;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Award(
      {this.id, this.title, this.description,
        this.startDate, this.endDate, this.awardFor,
        this.isActive,this.createdAt,this.updatedAt});

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      id: json["id"] ?? "unknown",
      title: json["title"] ?? "unknown",
      description: json["description"] ?? "unknown",
      startDate: json["start_date"] ?? "unknown",
      endDate: json["end_date"] ?? "unknown",
      awardFor: json["award_for"][0],
      isActive: json["is_active"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"]
    );
  }

  @override
  String toString() => 'credit {'
      'id: $id,'
      'title: $title,'
      'description: $description,'
      'startDate: $startDate,'
      'endDate: $endDate,'
      'awardFor: $awardFor,'
      'isActive: $isActive,'
      'createdAt: $createdAt,'
      'updatedAt: $updatedAt,'
      '}';

  Award.fromStringObject(List<dynamic> parsedJson) {
    parsedJson.map((i) => Award.fromJson(i)).toList();
  }
}
class AwardFor{
  String? taxiDriver;
  String? taxiPassenger;
  AwardFor({required this.taxiDriver,required this.taxiPassenger});

  factory AwardFor.fromJson(Map<String, dynamic> json) {
    return AwardFor(taxiDriver: json['taxi_driver'], taxiPassenger: json['taxi_passenger']);
  }
}
class AwardStore {
  List<Award>? awards;
  int total;
  AwardStore({required this.awards,required this.total});

  AwardStore.fromJson(List<dynamic> parsedJson,this.total) {
    awards = parsedJson.map((i) => Award.fromStringObject(i)).toList();
  }

  String toJson() {
    String data = jsonEncode(awards?.map((i) => i.toString()).toList());
    return data;
  }
}

